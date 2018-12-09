module Simpler
  class Router
    class Route

      attr_reader :method, :controller, :action, :id

      def initialize(method, url, controller, action, id)
        @method = method
        @url = url
        @controller = controller
        @action = action
        @id = id
      end

      def match?(method, path)
        path = path.split('/').drop(1)
        @method == method && path[0].match(@url) && @id == !path[1].nil?
      end

    end
  end
end
