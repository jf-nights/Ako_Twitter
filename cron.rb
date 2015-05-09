Bundler.require
require_relative './lib/twitter_client'
require_relative './lib/markov2'

twitter_client = TwitterClient.new('ako').client
markov = Markov.new

tweets = []
open("./data/timeline.txt", "r").each do |line|
    tweets << line.chomp
end

tweet = markov.generate(tweets)
twitter_client.update(tweet)
