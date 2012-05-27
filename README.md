# WARNING
This gem is working on one of my sites but I haven't had the time to
fully spec it out as yet, shame. Please help =).

Spree Refinery Auth
==============
It is an extension that provides authentication and authorization overrides so that we can use Spree AND Refinery both on the same project.

It does work mostly but some tests would be good.


Requirements
------------
- Spree 1.1.0+
- Refinery 2.0.0+
- Rails 3.2 (there is an issue with Refinery and Rails 3.2.2: [https://github.com/resolve/refinerycms/issues/1383](http://))

Install
-------
Add to your ```Gemfile```

	gem "spree_refinery_auth", :git => "https://github.com/maleko/spree_refinery_auth"
	gem 'refinerycms-core'
	gem 'refinerycms-dashboard'
	gem 'refinerycms-images'
	gem 'refinerycms-pages'
	gem 'refinerycms-resources'
	gem 'refinerycms-settings'
	gem 'spree'
	# Do not include the refinerycms-auth gem.


In your devise.rb (in config/initializers):

	config.authentication_keys = [ :email ]
	config.router_name = :spree

Run

	$ bundle install
	$ rails s

Add those two Roles in you "spree_roles" table:

- Refinery
- Superuser

Once your app is launched, first go to the Spree user administration and add those two roles to any user you want.

Notes
-----
You can now log as a Spree user. refinery_users, refinery_roles and refinery_roles_users are not used anymore. You will still need the refinery_user_plugins.

Known issues
------------
- assigning rights within Refinery doesn't work

