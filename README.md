# rails-dev-tweaks
A collection of tweaks to improve your Rails (3.1+) development experience.

To install, simply add it to your gemfile:

    gem 'rails-dev-tweaks', '~> 0.2.1'

At the moment, the current tweaks center around speeding up requests by giving granular control over which requests
cause the Rails autoloader to kick in:


# Granular Autoload
Rails' autoloading facility is a wonderful help for development mode, but sometimes it's a little overkill and ends up
hampering your rate of iteration while developing a Rails app.  rails-dev-tweaks introduces granular control over which
kinds of requests are autoloaded.

However, why should you use request-based autoload control instead of smart autoloaders that check file modification
times, such as [rails-dev-boost](https://github.com/thedarkone/rails-dev-boost)?  The primary worry with smart
autoloaders is that they have an extremely difficult time tracking all dependencies of a particular constant.  You can
end up with extremely confusing bugs, usually because you're accidentally hanging on to instances of a class that was
reloaded, rather than instantiating new instances with the updated copy of that class.  Request-based autoloading
hopefully avoids confusing and time-consuming bugs like that.

You can specify autoload rules for your app via a configuration block in your application or environment configuration.
These rules are specified via exclusion (`skip`) and inclusion (`keep`).  Rules defined later override those defined
before.

    config.dev_tweaks.autoload_rules do
      # You can used named matchers (see below).  This particular matcher effectively clears any default matchers
      keep :all

      # Exclude all requests that begin with /search
      skip '/search'
      # But include routes that include smerch
      keep /smerch/

      # Use a block if you want to inspect the request
      skip {|request| request.post?}
    end

The default autoload rules should cover most development patterns:

    config.dev_tweaks.autoload_rules do
      keep :all

      skip '/favicon.ico'
      skip :assets
      skip :xhr
      keep :forced
    end

If you find you're turning certain matchers on and off for most of your projects, be vocal about it!  These defaults
are not set in stone!

## Named Matchers
Named matchers are classes defined under RailsDevTweaks::GranularAutoload::Matchers:: and simply define a call
method that is given a ActionDispatch::Request and returns true/false on whether that request matches. Match names
are converted into a module name via "#{name.to\_s.classify}Matcher".  E.g. :assets will specify the
RailsDevTweaks::GranularAutoload::Matchers::AssetMatcher.

Any additional arguments given to a `skip` or `keep` call will be passed as initializer arguments to the matcher.

### :all
Matches every request passed to it.

### :assets
Rails 3.1 integrated [Sprockets](http://getsprockets.org/) as its asset packager.  Unfortunately, since the asset
packager is mounted using the traditional Rails dispatching infrastructure, it's hidden behind the Rails autoloader
(unloader). This matcher will match any requests that are routed to Sprockets (specifically any mounted
Sprockets::Environment instance).

_The downside_ to this matcher is that your Rails environment won't reload until you make a regular request to the dev
server (which should be your usual request pattern, anyway).  Assets still reload properly (unless you're referencing
your application's Ruby code).

### :forced
To aid in live-debugging when you need to, this matcher will match any request that has `force_autoload` set as a
parameter (GET or POST), or that has the `Force-Autoload` header set to something.

If you are live-debugging jQuery ajax requests, this helpful snippet will turn on forced autoloading for the remainder
of the browser's session:

    $.ajaxSetup({"beforeSend": function(xhr) {xhr.setRequestHeader("Force-Autoload", "true")} })

### :path
Matches the path of the request via a regular expression.

    keep :path, /thing/ # Match any request with "thing" in the path.

Note that `keep '/stuff'` is just shorthand for `keep :path, /^\/stuff/`.  Similarly, `keep /thing/` is shorthand for
`keep :path, /thing/`

### :xhr
Matches any XHR request (via request.xhr?).  The assumption here is that you generally don't live-debug your XHR
requests, and are instead refreshing the page that kicks them off before running against new response code.


# License
rails-dev-tweaks is MIT licensed by Wavii, Inc.  http://wavii.com

See the accompanying file, `MIT-LICENSE`, for the full text.

