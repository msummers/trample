module Trample
  class Session
    include Logging
    include Timer

    attr_reader :config, :response_times, :cookies, :last_response

    def initialize(config)
      @config         = config
      @response_times = []
      @cookies        = {}
    end

    def trample
      hit @config.login unless @config.login.nil?
      @config.iterations.times do
        @config.pages.each do |p|
          hit p
        end
      end
    end

    protected
    def hit(page)
      response_times << request(page)
      # this is ugly, but it's the only way that I could get the test to pass
      # because rr keeps a reference to the arguments, not a copy. ah well.
      @cookies = cookies.merge(last_response.cookies)
      logger.info ", #{page.request_method.to_s.upcase}, #{page.url}, #{response_times.last}, #{last_response.code}"
    end

    def request(page)
      time do
        @last_response = send(page.request_method, page)
      end
    end

    def get(page)
      resource = RestClient::Resource.new(page.url, :cookies => @cookies, :user => @config.http_basic_auth_user, :password => @config.http_basic_auth_password)
      result = resource.get
      Thread.current[:result] = result
      result
    end

    def post(page)
      resource = RestClient::Resource.new(page.url, :cookies => @cookies, :user => @config.http_basic_auth_user, :password => @config.http_basic_auth_password)
      result = resource.post(page.parameters)
      Thread.current[:result] = result
      result
    end
  end
end
