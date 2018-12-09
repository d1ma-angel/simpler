require 'yaml'
require 'singleton'
require 'sequel'
require_relative 'router'
require_relative 'controller'

module Simpler
  class Application

    include Singleton

    attr_reader :db

    def initialize
      @router = Router.new
      @db = nil
    end

    def bootstrap!
      setup_database
      setup_log
      require_app
      require_routes
    end

    def routes(&block)
      @router.instance_eval(&block)
    end

    def call(env)
      @app = run_app(env)
      write_log(env)
      @app
    end

    def run_app(env)
      route = @router.route_for(env)
      if route
        controller = route.controller.new(env)
        action = route.action
        id = parse_id(env)
        make_response(controller, action, id)
      else
        not_found_response
      end
    end

    private

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].each { |file| require file }
    end

    def require_routes
      require Simpler.root.join('config/routes')
    end

    def setup_database
      database_config = YAML.load_file(Simpler.root.join('config/database.yml'))
      database_config['database'] = Simpler.root.join(database_config['database'])
      @db = Sequel.connect(database_config)
    end

    def setup_log
      @log = File.open(Simpler.root.join('log/app.log'), 'a+')
    end

    def write_log(env)
      @log.write(log_record(env))
    end

    def log_record(env)
      record = "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n"
      record += "Handler: #{env['simpler.controller'].class.name}##{env['simpler.action']}\n"
      record += "Parameters: #{env['simpler.controller'].request.params}\n"
      record += "Response: #{env['simpler.controller'].response.status} [#{env['simpler.controller'].response.header['Content-Type']}] "
      record += "#{env['simpler.controller'].name}/#{env['simpler.action']}.html.erb\n\n"
      record
    end

    def make_response(controller, action, id)
      controller.make_response(action, id)
    end

    def not_found_response
      @response = Rack::Response.new
      @response.status = 404
      @response['Content-Type'] = 'text/plain'
      @response.write("404. Page not found")
      @response
    end

    def parse_id(env)
      env['PATH_INFO'].split('/').drop(1)[1]
    end
  end
end
