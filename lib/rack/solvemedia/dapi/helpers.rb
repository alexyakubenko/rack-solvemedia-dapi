require 'multi_json'

module Rack
  module SolveMedia
    class DAPI
      module Helpers
        
        # Outputs the Solve Media data collection Javascript code. A cookie is
        # set indicating the user has been collected from; a call to this helper
        # for a user who has been cookied will return the empty string.
        #
        # This method accepts a hash of options that allows the developer to
        # override the options set at the middleware's initialization.
        #
        # As this helper outputs HTML tags, when used in Rails it must be
        # marked HTML safe before being written to the page.
        #
        # @param [Hash] user_data The data to be collected
        # @param [Hash] options
        # @option options [String] :site_id
        # @option options [Boolean] :ssl
        def sm_dapi_html(user_data, options = {})
          return "" if Rack::SolveMedia::DAPI.get_session_cookie(request)
          return "" if request.cookies.empty?

          user_data.delete_if { |k,v| v.nil? || v.empty? }
          return "" if user_data.empty?

          site_id = options[:site_id] || Rack::SolveMedia::DAPI.site_id 
          use_ssl = options[:ssl] || Rack::SolveMedia::DAPI.ssl
          
          user_data[:sid] = site_id

          user_data.each do |k,v|
            v.strip!
            v.downcase! if k == "email"
          end


          server = use_ssl ? Rack::SolveMedia::DAPI::SECURE_SERVER : Rack::SolveMedia::DAPI::SERVER

          html = <<EOS
<script type="text/javascript">
    var SMInformation = #{MultiJson.dump(user_data, :pretty => true)};
</script>
<script type="text/javascript" src="#{server}/dapi/collect" async></script>
EOS

          request.env[:solvemedia_dapi_collected] = true

          return html

        end

        def sm_hash_email(email)
          require 'digest'

          email = email.strip
          (uname, domain) = email.split('@')

          h = ""
          h = h +  "H1:" + Digest::SHA1.hexdigest(email.downcase)
          h = h + ",H2:" + Digest::SHA1.hexdigest(email.upcase)
          h = h + ",H3:" + Digest::SHA1.hexdigest(domain.downcase)
          h = h + ",H4:" + Digest::MD5.hexdigest(email.downcase)
          h = h + ",H5:" + Digest::MD5.hexdigest(email.upcase)
          
          return h
        end

      end
    end
  end
end
