阿古さんがTwitter してます
# 概要
15分に1回の間隔で保存してある自分のTLから文章を作って投稿します。  
今のところ生成方法はマルコフ連鎖に頼っています。

自分へのリプライがあると、リプライを送ってきた相手の過去200件の発言からマルコフ連鎖で返信を作ったり、  
リプライだけを保存したリストからてきとうに返信したりします。

dic/fav_list に書いてある語句が含まれているツイートを頑張ってふぁぼります。

# 環境
- ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-linux]

# いんすとーる
`git clone git@github.com:jf-nights/Ako_Twitter.git`  
`bundle install`

# 使い方
## 起動
`bundle exec ruby bot.rb`

## ふぁぼ
dic/fav_list にふぁぼりたい語句を改行区切りで書き込めます  
※ 反映するには再起動が必要です

# 親
[jf_nights](https://twitter.com/jf_nights)
