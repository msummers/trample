require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rr'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'trample'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit unless include?(RR::Adapters::TestUnit)

  protected
  def trample(config)
    Trample::Cli.new.start(config)
  end

  def mock_get(url, opts={})
    opts[:times].times do
      mock(foo = RestClient::Resource.new(url, :cookies => opts[:cookies] || {}))
      response = RestClient::Response.new("", stub!)
      stub(response).cookies { opts[:return_cookies] || {} }
      stub(response).code { 200 }
      foo.get {response}
    end
  end

  def mock_post(url, opts={})
    opts[:times].times do
      mock(foo = RestClient::Resource.new(url, :user => opts[:user], :password => opts[:password], :cookies => opts[:cookies] || {}))
      response = RestClient::Response.new("", stub!)
      stub(response).cookies { opts[:return_cookies] || {} }
      stub(response).code { 200 }
      foo.post(opts) {response}
    end
  end

  def stub_get(url, opts = {})
    opts[:times].times do
      stub(foo = RestClient::Resource.new(url, :cookies => opts[:cookies] || {}))
      response = RestClient::Response.new("", stub!)
      stub(response).cookies { opts[:return_cookies] || {} }
      stub(response).code { 200 }
      foo.get {response}
    end
  end
end