require 'fileutils'
require_relative './lib/twitter_client'
require_relative './lib/markov2'

class Ako
  attr_accessor :stream_client
  def initialize
    @twilib = TwitterClient.new('ako')
    @stream_client = @twilib.stream_client
    @twitter_client = @twilib.client
    @markov = Markov.new
    @fav_list = open('./dic/fav_list').read.split("\n")
    # tweetとかの保存先が無かったら作成する
    FileUtils.mkdir_p('data/user') if !File.exists?('data/user')
 end

  def recieve(tweet)
    # 保存
    save_timeline(tweet)
    # ふぁぼるやつだったらふぁぼる
    check_favorite(tweet)
    # 自分へのリプなら返信する
    if tweet.in_reply_to_screen_name == 'Ako_Hieda'
      response = generate_reply(tweet)
      @twitter_client.update("@#{tweet.user.screen_name} #{response}", :in_reply_to_status_id => tweet.id)
    end
  end

  # ------ timeline 保存 ------
  # 保存先は data/timeline.txt !!!!11(((
  def save_timeline(tweet)
    # 普通のTweetは全部保存
    open('./data/timeline.txt', 'a') do |file|
      file.write(@twilib.clear_text(tweet.text) + "\n")
    end

    # リプライなら個別に保存
    # ただし自分の発言は無視
    # 保存先は(ry
    if tweet.in_reply_to_screen_name.class != Twitter::NullObject && tweet.user.screen_name != 'Ako_Hieda'
      # 鍵アカの人のは保存しない
      if tweet.user.protected == false
        open('./data/replies.txt', 'a') do |file|
          file.write(@twilib.clear_text(tweet.text) + "\n")
        end
      end
    end
  end

  # ------ favorite ------
  # とりあえずあらかじめ特定のワードを登録しといて、
  # それがあ含まれてたらふぁぼ(コンちゃんのぱくり
  # 特定ワードは dic/fav_list に書く
  ### こっちにopen('./dic...)を書いたら即座に反映出来るけど
  ### tweetが流れてくるたびにopenするのなんか大丈夫なんかなぁって感じ
  def check_favorite(tweet)
    @fav_list.each do |word|
      regexp = Regexp.new(word)
      @twitter_client.favorite(tweet.id) if tweet.text =~ regexp
    end
  end

  # ------ reply する ------
  # reply する
  # reply 方法は以下
  # 1. 相手の発言を基に文章生成(markov)
  # 2. replies.txt からrandom に
  # 3. markov 以外の方法でそれっぽい文章を作る!!!!!#hai
  # 確率は適当に......
  def generate_reply(tweet)
    reply = ''
    case rand(10)
    when 0..7
      reply = generate_response_by_markov(tweet)
    when 8..9
      reply = generate_response_by_replies
    end
    return reply
  end

  # markov 連鎖でreply を作る
  def generate_response_by_markov(tweet)
    user_id = tweet.user.id
    # いちいちload してるのは、api制限にかからないようにするためだと思われます
    get_tweets(user_id) if need_get_tweets(user_id)
    tweets = load_tweets(user_id)
    reply = @markov.generate(tweets)
  end

  # 相手の過去200件のtweetを取得して保存する
  def get_tweets(user_id)
    recent_tweets = []
    @twitter_client.user_timeline(user_id, :count => 200).each do |status|
      recent_tweets << @twilib.clear_text(status.text)
    end

    # 保存
    open("./data/user/#{user_id}", 'w') do |file|
      file.write(recent_tweets.join("\n"))
    end
  end

  # user_id さんの200件保存日時を見て、
  # 30分以内だったら新しく取得しません
  # 毎回取得してたらapi制限にかかっちゃう
  def need_get_tweets(user_id)
    file_path = "./data/user/#{user_id}"

    # ファイルがあるかどうか先に確認
    if File.exists?(file_path)
      time = Time.now
      save_time = File.stat(file_path).mtime
      if (time - save_time).abs < 60 * 30
        return false
      else
        return true
      end
    else
      # ファイルが無かった場合
      return true
    end
  end

  # 保存済みuser_id さんのついーとを読み込む
  def load_tweets(user_id)
    tweets = []
    open("./data/user/#{user_id}").each do |line|
      tweets << line.chomp
    end
    return tweets
  end

  # replies.txt からランダムに
  def generate_response_by_replies
    replies = []
    open('./data/replies.txt').each do |line|
      replies << line.chomp
    end
    return replies[rand(replies.size)]
  end

end
