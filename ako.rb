require_relative './lib/twitter_client'
class Ako
  attr_accessor :stream_client
  def initialize
    twi = TwitterClient.new('ako')
    @stream_client = twi.stream_client
  end
end
