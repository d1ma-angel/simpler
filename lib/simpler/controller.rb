require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response, :params

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, env)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def render(template)
      View.new(@request.env, template).render
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def params
      @request.params.merge(@request.env['simpler.route_params'])
    end

    def write_response
      if @response.body.empty?
        body = render_body
      end

      @response.write(body)
    end

    def render_body
      View::HTMLRenderer.new(@request.env).render(binding)
    end

    def status(code)
      @response.status = code
    end

    def headers
      @response
    end

  end
end
