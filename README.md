# EMS Asset Management Plugin
This plugin provides an option to share a ticket across different prjects.

# Plugin support
This plugin is supported by Redmine 3.0.0 and above

# Installation Setup
1. Copy the plugin code directory into #{RAILS_ROOT}/plugins folder. If you are downloading the plugin directly from GitHub, you can do so bychanging into your plugin directory and issuing a command like
  
  ```
   $cd <your_app_root>/plugin/
   $git clone git@github.com:agiratech/ems_am_redmine.git
   ```
2. The plugin requires a migration, so run the following command in #{RAILS_ROOT}
   
   ```
   bundle exec rake redmine:plugins:migrate
   ```
   
3. Restart your Web Server / App Server of your server instance to restart redmine.  (it depents based on your production server enviroment)

**Note**: if have source code as zip/tar file, instead of step #1, extract the files in #{RAILS_ROOT}/plugins folder and continue the steps #2 & #3 
