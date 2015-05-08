# coding: utf-8
require 'MeCab'

module Morph
  def init_analyzer
    @mecab = MeCab::Tagger.new
  end
  
  def analyze(text)
    parsed = @mecab.parse(text)
    parsed.force_encoding("UTF-8")
    parsed.gsub(/\nEOS/, "").split("\n").map{|s| s.split("\t")}
  end
  
  def keyword?(part)
    return /名詞,(一般|固有名詞|サ変接続|形容動詞語幹|数)/ =~ part
  end
  
  module_function :init_analyzer, :analyze, :keyword?
end
