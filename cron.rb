Bundler.require
require_relative './lib/twitter_client'
require_relative './lib/markov2'

twitter_client = TwitterClient.new('ako').client
markov = Markov.new
# マルコフするもとになるtweetの配列
tweets = []
# updateするtweet
tweet = ''
# Mongo
mongo = Mongo::Client.new(['127.0.0.1:27272'], :database => 'twitter')
db = mongo.database
coll = db[:ako]

# 0分,30分は最近のTLから作る
if Time.now.min == 0 || Time.now.min == 30
  coll.find.sort(:_id => -1).limit(500).each do |row|
    tweets << row[:status][:text]
  end
# 15分,45分は全部から
else
  coll.find.each do |row|
    tweets << row[:status][:text]
  end
end
tweet = markov.generate(tweets)
twitter_client.update(tweet)
