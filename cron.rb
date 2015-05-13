Bundler.require
require_relative './lib/twitter_client'
require_relative './lib/markov2'
require 'pp'

twitter_client = TwitterClient.new('ako').client
markov = Markov.new
mongo = Mongo::Client.new(['127.0.0.1:27272'], :database => 'twitter')
db = mongo.database
coll = db[:ako]

tweets = []
coll.find.each do |row|
  tweets << row[:status][:text]
end

tweet = markov.generate(tweets)
twitter_client.update(tweet)
