class ConfigurationController < ApplicationController
    
    # The configuration view/edit page
    def load
        
        # Only director and labasst can access the configuration
        if (current_user.nil? || (!current_user.director? && !current_user.labasst?))
           render 'static_pages/403'
           return
        end
        
        @title = "Configuration"
        @config = YAML.load_file(File.join(Rails.root, 'config', 'lrc_settings.yml'))
        render "configuration"
    end
    
    # POST, save the settings back to the configuration file
    def save
        if (current_user.nil? || (!current_user.director? && !current_user.labasst?))
           render 'static_pages/403'
           return
        end
        
        @config = params[:config]
        File.open(File.join(Rails.root, 'config', 'lrc_settings.yml'), 'w') do |f|
            f.puts @config
        end
        
        flash[:success] = "Configuration successfully saved."
        redirect_to configuration_path
    end
end
