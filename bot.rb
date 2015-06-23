require 'pp'
Bundler.require

require_relative './ako'
ako = Ako.new

# mongo
mongo_client = Mongo::Client.new(['127.0.0.1:27272'], :database => 'twitter')
db = mongo_client.database
collection = db[:ako]

warn "system start!!!"

ako.stream_client.user do |object|
  doc = nil
  case object
  when Twitter::Tweet
    if object.user.protected == false
      doc = { :status => object.to_h }
    end
    ako.recieve(object)
  end
  collection.insert_one(doc) unless doc.nil?
end
