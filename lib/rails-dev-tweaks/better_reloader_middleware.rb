require 'active_support'

module RailsDevTweaks
  # Here's an idea, let's not reload the entire dev environment for each asset request.  Let's only do that on regular
  # content requests.
  class BetterReloaderMiddleware

    def initialize(app)
      @app      = app
      @reloader = ActionDispatch::Reloader.new(app)
    end

    def call(env)
      request    = ActionDispatch::Request.new(env)
      main_mount = env['action_dispatch.routes'].set.recognize(request)

      # Unwind until we have an actual app
      while main_mount != nil
        if main_mount.kind_of? Array
          main_mount = main_mount.first

        elsif main_mount.kind_of? Rack::Mount::Route
          main_mount = main_mount.app

        elsif main_mount.kind_of? Rack::Mount::Prefix
          # Bah, no accessor here
          main_mount = main_mount.instance_variable_get(:@app)

        # Well, we got something
        else
          break
        end
      end

      # That's right, skip the reloading middleware if we're hitting sprockets up for some juicy assets
      return @app.call(env) if main_mount.kind_of?(Sprockets::Environment)

      # Sadface, we'd better let the reloader kick in :(
      @reloader.call(env)
    end

  end
end

# Make sure that we wire up the middleware once the app has loaded (but before configuration so it can be overridden)
ActiveSupport.on_load(:before_initialize) do |app|
  # We can't inspect the stack because it's deferred...  For now, just assume we have it when config.cache_clasess is
  # falsy; which should always be the case in the current version of rails anyway.
  unless app.config.cache_classes
    app.config.middleware.swap ActionDispatch::Reloader, RailsDevTweaks::BetterReloaderMiddleware
  end
end

