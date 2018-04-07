Bundler.require
require_relative './lib/twitter_client'

twitter_client = TwitterClient.new('ako').client

#twitter_client.update("@jf_nights お茶！！！飲み物！！！このままだと飲み物がお酒しかないですよ！！！！！！")
#twitter_client.update("@jf_nights あとお米もです！！！")
twitter_client.update("@jf_nights World of アドベントカレンダー！！！")
