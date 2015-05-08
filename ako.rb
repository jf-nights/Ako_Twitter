require_relative './lib/twitter_client'
class Ako
  attr_accessor :stream_client
  def initialize
    twi = TwitterClient.new('ako')
    @stream_client = twi.stream_client
    @twitter_client = twi.client
  end

  def recieve(tweet)
    # 保存
    save_timeline(tweet)
    # 自分へのリプなら反応する
  end

  # 保存先は data/timeline.txt !!!!11(((
  def save_timeline(tweet)
    # 無かったら作成する
    Dir.mkdir('data') if !File.exists?('data')

    # 普通のTweetは全部保存
    open('./data/timeline.txt', 'a') do |file|
      file.write(tweet.text + "\n")
    end

    # リプライなら個別に保存
    # ただし自分の発言は無視
    # 保存先は(ry
    if tweet.in_reply_to_screen_name.class != Twitter::NullObject && tweet.user.screen_name != 'Ako_Hieda'
      open('./data/replies.txt', 'a') do |file|
        file.write(tweet.text + "\n")
      end
    end
  end
end
