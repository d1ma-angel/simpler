module Simpler
  class Router
    class Route

      attr_reader :method, :controller, :action, :params

      def initialize(method, controller, action, path)
        @method = method
        @controller = controller
        @action = action
        @path = path
        @params = {}
      end

      def match?(method, path)
        @route_matching = true
        route_params = @path.split('/')
        request_params = path.split('/')
        if route_params.size == request_params.size
          parse_route(route_params, request_params)
        else
          @route_matching = false
        end
        @route_matching && @method == method
      end

      private

      def parse_route(route_params, request_params)
        request_params.each_with_index do |request_param, index|
          if request_param == route_params[index]
            next
          elsif !route_params[index].nil? && route_params[index][0] == ":"
            @params[route_params[index][1..-1]] = request_param.split('+').join(' ')
          else
            @route_matching = false
          end
        end
      end

    end
  end
end
