class RailsDevTweaks::Railtie < Rails::Railtie

  config.dev_tweaks = RailsDevTweaks::Configuration.new

end

