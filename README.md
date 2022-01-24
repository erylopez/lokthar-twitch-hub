# Windows template

This empty rails app includes gem versions and some configuration sets that I tested to work fine on windows 10 (no WSL2 or any linux subsystem stuff, just windows).
The Main purpose of this approach is to help RoR newcomers to start playing around with the framework without worrying on seting up a linux virtual machine or anything else.

* Bootstrap + Jquery + Fontawesome flavor
This branch includes bootstrap and jquery configuration to play nice with webpacker. Is not specific to windows but I found that is not a trivial installation like it used to be.

Just run `yarn install` in the repo folder, and you should be good to go.

Theres an example showcasing everything at `app/packs/application.js`, `app/packs/stylesheets/application.scss` and `app/views/homepage/index.html.erb`

* Ruby version
Ruby 2.6.6

* System dependencies
Windows 10, VS Code

* Configuration
Install ruby using [RubyInstaller for windows](https://rubyinstaller.org/downloads/) I highly suggest to go with version 2.6.6, which has the best gem compatibility for windows environemnts.
After cloning this repo, just run `gem install bundler` and then `bundle install`
Theres different set of configurations in this repository, just select the branch that adjust better to yours needs and run the bundle install command from there.

* Database creation
SQLite adapter is known to have many compatibility issues with windows environments (there are versions that work fine tho).
Because of this, I suggest to just go with postgres on development, which is proven to work fine on windows.

You can download postgres for windows from [their official website](https://www.postgresql.org/download/windows/)
Once you get everything ready, create a .env file with the db credentials (there's a `.env.example` included in the repo, so you can edit it and then rename it to just `.env`), we use those env variables in the `database.yml` file to connect to the postgres db.

* How to run the test suite
There's no known issue with rspec or minitest in windows, so you can chose whatever you want here!

* Services (job queues, cache servers, search engines, etc.)
For activejobs, actioncable, and such, I suggest to use redis on windows.
You don't need to switch the adapter tho, the :async adapter should use redis if available for development.

* Deployment instructions
I have included a `nginx.conf` file so you can deploy this to any linux instance without worrying on assets cache, webpack builds, etc.
Once you get the nginx setup with your project, the deployments are easy as running:

```
RAILS_ENV=production rails assets:precompile
RAILS_ENV=production rails db:migrate
systemctl restart rails.service
```

If you want zero downtime you can change your rails service configuration to spawn puma with 2 workers by running`RAILS_ENV=production bundle exec puma -w 2` and then you can restart the server with `bundle exec pumactl phased-restart`, that way puma will restart workers one by one.

Feel free to use [Capistrano](https://capistranorb.com/) for more advanced/scalable deployment instructions, but you can start deploying right away without it if you want.
