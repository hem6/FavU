class NSString
  def unescape_tweet
    self.gsub(/&lt;|&gt;/,{"&lt;" => "<", "&gt;" => ">"})
  end
end
