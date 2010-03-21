module Rack
  module Client
    class Base
      extend Forwardable

      def_delegator :@app, :call

      def initialize(app, url = nil)
        @app = app
        @base_uri = URI.parse(url) unless url.nil?
      end

      def delete(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('DELETE', url, headers, body)) {|tuple| yield parse(*tuple) }
        else
          parse *call(build_env('DELETE', url, headers, body))
        end
      end

      def get(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('GET', url, headers, body)) {|tuple| yield parse(*tuple) }
        else
          parse *call(build_env('GET', url, headers, body))
        end
      end

      def head(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('HEAD', url, headers, body)) {|tuple| yield parse(*tuple) }
        else
          parse *call(build_env('HEAD', url, headers, body))
        end
      end

      def post(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('POST', url, headers, body)) {|tuple| yield parse(*tuple) }
        else
          parse *call(build_env('POST', url, headers, body))
        end
      end

      def put(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('PUT', url, headers, body)) {|tuple| yield parse(*tuple) }
        else
          parse *call(build_env('PUT', url, headers, body))
        end
      end

      def build_env(request_method, url,  headers = {}, body = nil)
        env = {}
        env.update 'REQUEST_METHOD' => request_method
        env.update 'CONTENT_TYPE'   => 'application/x-www-form-urlencoded'

        uri = @base_uri.nil? ? URI.parse(url) : @base_uri + url
        env.update 'PATH_INFO'   => uri.path
        env.update 'REQUEST_URI' => uri.path
        env.update 'SERVER_NAME' => uri.host
        env.update 'SERVER_PORT' => uri.port
        env.update 'SCRIPT_NAME' => ''

        input = case body
                when nil        then StringIO.new
                when String     then StringIO.new(body)
                end
        env.update 'rack.input' => input
        env.update 'rack.errors' => StringIO.new

        env
      end

      def parse(status, headers = {}, body = [])
        Rack::Response.new(body, status, headers)
      end
    end
  end
end
