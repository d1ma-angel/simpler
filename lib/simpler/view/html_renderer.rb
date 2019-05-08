module Simpler
  class View
    class HTMLRenderer

      def initialize(env)
        @env = env
      end

      def render(binding)
        template = File.read(template_path)

        ERB.new(template).result(binding)
      end

      private

      def template_path
        path = template || [@env['simpler.controller'].name, @env['simpler.action']].join('/')

        Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
      end

      def template
        @env['simpler.template']
      end

    end
  end
end
