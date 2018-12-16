module Simpler
  class View
    class InlineRenderer

      def initialize(body, response)
        @body = body
        @response = response
      end

      def inline
        @response.write(ERB.new(@body).result(binding))
      end

    end
  end
end
