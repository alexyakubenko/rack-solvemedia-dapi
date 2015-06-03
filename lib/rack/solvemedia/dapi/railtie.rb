module Rack
  module SolveMedia
    class DAPI::Railtie < Rails::Railtie
      config.solvemedia_dapi = ActiveSupport::OrderedOptions.new

      initializer "rack.solvemedia.dapi.initializer" do |app|
        site_id     = app.config.solvemedia_dapi[:site_id]
        ssl         = app.config.solvemedia_dapi[:ssl]
        site_domain = app.config.solvemedia_dapi[:site_domain]
        site_path   = app.config.solvemedia_dapi[:site_path]

        raise "A unique publisher identifier is required to use the Solve Media data API. Contact Solve Media (http://www.solvemedia.com) if you do not have one." unless site_id
        
        options = {}
        options[:ssl]         = ssl if ssl
        options[:site_domain] = site_domain if site_domain
        options[:site_path]   = site_path if site_path

        app.middleware.use 'Rack::SolveMedia::DAPI', site_id, options
      end

      initializer "rack.solvemedia.dapi.helpers" do
        ActionView::Base.send :include, Rack::SolveMedia::DAPI::Helpers
      end

    end
  end
end
