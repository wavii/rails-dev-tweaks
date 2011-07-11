# rails-dev-tweaks
A collection of tweaks to improve your Rails (3.1+) development experience.

To install, simply add it to your gemfile:

    gem 'rails-dev-tweaks', '~> 0.1.0'

For now, it's a single tweak to speed up developing on Rails 3.1 w/ asset packaging:

## Asset Packaging
Rails 3.1 integrated [Sprockets](http://getsprockets.org/) as its asset packager.  Unfortunately, since the asset packager is
mounted using the traditional Rails dispatching infrastructure, it's hidden behind the Rails autoloader (unloader).

This tweak simply disables autoloading for requests that are routed to Sprockets (specifically, to a
`Sprockets::Environment`), to dramatically speed up asset requests.  _The downside to this tweak_ is that your Rails
environment won't reload until you make a regular request to the dev server (which should be your usual
request pattern, anyway).  Assets still reload properly (unless you're referencing your application's Ruby code).

# License
rails-dev-tweaks is MIT licensed by Wavii, Inc.  http://wavii.com

See the accompanying file, `MIT-LICENSE`, for the full text.

