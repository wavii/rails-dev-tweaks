class RailsDevTweaks::GranularAutoload::Matchers::AssetMatcher

  def call(request)
    main_mount = request.headers['action_dispatch.routes'].set.recognize(request)

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

    # what do we have?
    main_mount.kind_of? Sprockets::Environment
  end

end
