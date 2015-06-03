require "rack/solvemedia/dapi/version"
require "rack/solvemedia/dapi/helpers"

module Rack
  module SolveMedia
    class DAPI

      class << self
        attr_accessor :site_id, :ssl, :site_domain, :site_path

        # Reads the Solve Media DAPI cookie and returns its contents
        # @param [Rack::Request] req The current request
        def get_session_cookie(req)
          return req.cookies[SESSION_COOKIE]                
        end

      end

      SERVER = "http://data.solvemedia.com"
      SECURE_SERVER = "https://data-secure.solvemedia.com"
      SESSION_COOKIE = "sm_dapi_session"
      SESSION_LENGTH = 14 * 24 * 60 * 60

      # @param [String] site_id The site ID provided to you by Solve Media
      # @param [Hash] options
      # @option options [Boolean] :ssl (false) Use SSL?
      def initialize(app, site_id, options = {})
        @app = app
        
        self.class.site_id      = site_id
        self.class.ssl          = options[:ssl] || false
        self.class.site_domain  = options[:site_domain] || ""
        self.class.site_path    = options[:site_path] || "/"
      end

      def call(env)
        dup._call(env)
      end

      def _call(env)
        status, headers, body = @app.call(env)

        set_session_cookie!(headers) if env[:solvemedia_dapi_collected]

        [status, headers, body]
      end

      def set_session_cookie!(headers)
        cookie_val = {
          :value => 1,
          :domain => Rack::SolveMedia::DAPI.site_domain,
          :path => Rack::SolveMedia::DAPI.site_path,
          :expires => Time.now + SESSION_LENGTH
        }

        ::Rack::Utils.set_cookie_header!(headers, SESSION_COOKIE, cookie_val)
      end

    end
  end
end
