require_relative './morph'
include Morph

class Markov
  ENDMARK = "%END%"
  CHAIN_MAX = 30
  def initialize
    Morph::init_analyzer
    @dic = {}
    @starts = {}
    @replies = []
    @nouns = []

  end

  def generate(tweets)
    # tweetsは文章の配列で
    initialize
    # ユーザーの発言200を解析
    analyze(tweets)
    # 解析したデータをもとに発言をgenerate
    response = generate_sentence(@starts.keys[rand(@starts.keys.size)])
  end

  def analyze(tweets)
    # tweetsを解析・保存する関数を呼ぶ関数
    tweets.each do |tweet|
      analyzed_tweet = Morph::analyze(tweet)
      save_sentence(analyzed_tweet)
      search_noun(analyzed_tweet)
    end
  end

  def save_sentence(parts)
    # 文章を形態素解析した配列を受け取って、
    # 文章の連鎖を保存する関数
    return if parts.size < 3

    parts = parts.dup
    # 最初のprefix達
    prefix1, prefix2 = parts.shift[0], parts.shift[0]

    # prefix1 を保存してなんかに使えるといいな
    add_start(prefix1)

    parts.each do |suffix, info|
      # info は形態素の情報なので使わない。
      add_suffix(prefix1, prefix2, suffix)
      # prefix1,2 の組に suffix を挿入したら、一つずつずらす
      prefix1, prefix2 = prefix2, suffix
    end

    # parts が最後まで行ったら、suffix に ENDMARK を入れて終わり。
    add_suffix(prefix1, prefix2, ENDMARK)
  end

  def search_noun(parts)
    # 受け取った文字が名詞かどうか判定、
    # 名詞なら @nouns に格納
    parts.each do |word, info|
      @nouns << word if Morph::keyword?(info)
    end
  end

  def generate_sentence(keyword)
    return if @dic.nil?
    words = []
    # prefix1 は @startsの中から適当に
    # prefix2 はそれに続くものの中からランダムに
    prefix1 = keyword
    prefix2 =  @dic[prefix1].keys[rand(@dic[prefix1].keys.size)]
    words.push(prefix1, prefix2)

    # prefix1 prefix2 に続く言葉を並べる
    # 最大でCHAIN_MAX 回。
    CHAIN_MAX.times do 
      prefix = @dic[prefix1][prefix2]
      suffix = prefix[rand(prefix.size)]
      break if suffix == ENDMARK
      words << suffix
      prefix1, prefix2 = prefix2, suffix
    end
    return words.join
  end

  def add_start(prefix1)
    @starts[prefix1] = 0 unless @starts[prefix1]
    @starts[prefix1] += 1
  end

  def add_suffix(prefix1, prefix2, suffix)
    # @dic{prefix1}, @dic{prefix1 => {prefix2 => []}} を
    # それぞれなかったら作る
    @dic[prefix1] = {} unless @dic[prefix1]
    @dic[prefix1][prefix2] = [] unless @dic[prefix1][prefix2]
    @dic[prefix1][prefix2].push(suffix)
  end
end
