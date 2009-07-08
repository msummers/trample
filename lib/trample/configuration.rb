module Trample
  class Configuration
    attr_reader :pages

    def initialize(&block)
      @pages = []
      instance_eval(&block)
    end

    @concurrency_delay_max = nil
    def concurrency_delay_max(*value)
      @concurrency_delay_max = value.first unless value.empty?
      @concurrency_delay_max
    end

    def http_basic_auth_user(*value)
      @http_basic_auth_user = value.first unless value.empty?
      @http_basic_auth_user
    end

    def http_basic_auth_password(*value)
      @http_basic_auth_password = value.first unless value.empty?
      @http_basic_auth_password
    end

    def concurrency(*value)
      @concurrency = value.first unless value.empty?
      @concurrency
    end

    def iterations(*value)
      @iterations = value.first unless value.empty?
      @iterations
    end

    def get(url, &block)
      @pages << Page.new(:get, url, block || {})
    end

    def post(url, params = nil, &block)
      @pages << Page.new(:post, url, params || block)
    end

    def login
      if block_given?
        yield
        @login = pages.pop
      end

      @login
    end

    def ==(other)
      other.is_a?(Configuration) &&
        other.pages == pages &&
        other.concurrency == concurrency &&
        other.iterations  == iterations
    end
  end
end
