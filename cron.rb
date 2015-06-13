Bundler.require
require_relative './lib/twitter_client'
require_relative './lib/markov2'
require 'pp'

twitter_client = TwitterClient.new('ako').client
markov = Markov.new
# マルコフするもとになるtweetの配列
tweets = []
# updateするtweet
tweet = ''

# 0分,30分は最近のTLから作る
if Time.now.min == 0 || Time.now.min == 30
  recent_tl = twitter_client.home_timeline(:count => 200)
  recent_tl.each do |status|
    tweets << status.text
  end
# 15分,45分は全部から
else
  mongo = Mongo::Client.new(['127.0.0.1:27272'], :database => 'twitter')
  db = mongo.database
  coll = db[:ako]

  coll.find.each do |row|
    tweets << row[:status][:text]
  end
end
tweet = markov.generate(tweets)
twitter_client.update(tweet)
