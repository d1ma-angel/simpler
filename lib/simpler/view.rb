require 'erb'

require_relative 'view/plain_renderer'
require_relative 'view/inline_renderer'
require_relative 'view/html_renderer'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env, template)
      @env = env
      @template = template
    end

    def render
      if @template[:plain]
        PlainRenderer.new(@template[:plain], controller.response).plain
      elsif @template[:inline]
        InlineRenderer.new(@template[:inline], controller.response).inline
      else
        @request.env['simpler.template'] = template
      end
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

  end
end
