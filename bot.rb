require 'twitter'

token = open('/home/jf712/.twitter/ako').read.split("\n")

stream_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key         = token[0]
  config.consumer_secret      = token[1]
  config.access_token         = token[2]
  config.access_token_secret  = token[3]
end

warn "start!!!"

stream_client.user do |object|
  case object
  when Twitter::Tweet
    puts object.text
  end
end
