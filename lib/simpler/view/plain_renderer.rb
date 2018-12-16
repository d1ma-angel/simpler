module Simpler
  class View
    class PlainRenderer

      def initialize(body, response)
        @body = body
        @response = response
      end

      def plain
        @response.write(@body)
        @response['Content-Type'] = 'text/plain'
      end

    end
  end
end
