module Simpler
  class Logger

    def initialize(app)
      @app = app
      @log = setup_log
    end

    def call(env)
      app = @app.call(env)
      write_log(env)
      app
    end

    private

    def setup_log
      File.open(Simpler.root.join('log/app.log'), 'a+')
    end

    def write_log(env)
      @log.write(log_record(env))
    end

    def log_record(env)
      record = "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n"
      record += "Handler: #{env['simpler.controller'].class.name}##{env['simpler.action']}\n"
      record += "Parameters: #{env['simpler.controller'].request.params}\n"
      record += "Response: #{env['simpler.controller'].response.status} "
      record += "[#{env['simpler.controller'].response.header['Content-Type']}] "
      record += "#{env['simpler.controller'].name}/#{env['simpler.action']}.html.erb\n\n"
      record
    end

  end
end
