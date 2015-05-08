Bundler.require

require_relative './ako'
ako = Ako.new
warn "system start!!!"

ako.stream_client.user do |object|
  case object
  when Twitter::Tweet
    puts object.text
  end
end
