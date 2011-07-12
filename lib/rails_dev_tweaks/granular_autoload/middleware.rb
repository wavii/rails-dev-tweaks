# Here's an idea, let's not reload the entire dev environment for each asset request.  Let's only do that on regular
# content requests.
class RailsDevTweaks::GranularAutoload::Middleware

  def initialize(app)
    @app      = app
    @reloader = ActionDispatch::Reloader.new(app)
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    # reload, or no?
    if Rails.application.config.dev_tweaks.granular_autoload_config.should_reload?(request)
      return @reloader.call(env)
    end

    Rails.logger.info 'RailsDevTweaks: Skipping ActionDispatch::Reloader middleware for this request.'
    @app.call(env)
  end

end

