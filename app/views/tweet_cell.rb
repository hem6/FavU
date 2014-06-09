class TweetCell < UITableViewCell
  def self.heightForTweet(tweet)
    height_for_name_labels = 10 + 16 + 3
    text_label_size = [320 - 65 - 10, 1000]

    text_rect = tweet.text.boundingRectWithSize(text_label_size,
      options: NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin,
      attributes: TweetLabelAttributes.sharedAttributes.attributes[:text_label],
      context: nil
    )

    height_for_rt_label = tweet.retweeted_by ? 18 : 0

    return [text_rect.size.height + height_for_name_labels + height_for_rt_label + 10, 68].max
  end

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super

    self.contentView << @user_image_view = UIImageView.new
    self.contentView << @name_label = UILabel.new
    self.contentView << @screen_name_label = UILabel.new
    self.contentView << @time_label = UILabel.new
    self.contentView << @text_label = UILabel.new.tap{ |label| label.numberOfLines = 0 }
    self.contentView << @rt_label = UILabel.new
    self.contentView << @fav_star_label = UILabel.new

    self
  end

  def fill_with_tweet(tweet)
    text_attributes = TweetLabelAttributes.sharedAttributes.attributes

    @name_label.attributedText = tweet.user.name.unescape_tweet.nsattributedstring(text_attributes[:name_label])

    @screen_name_label.attributedText = ("@" + tweet.user.screen_name).nsattributedstring(text_attributes[:screen_name_label])

    timestamp = FavU::TextUtil.make_relative_timestamp(tweet.created_at)
    @time_label.attributedText = timestamp.nsattributedstring(text_attributes[:time_label])

    @text_label.attributedText = tweet.text.nsattributedstring(text_attributes[:text_label])

    @user_image_view.setImageWithURL(tweet.user.profile_image_url.nsurl)

    if tweet.retweeted_by
      rt_icon = :retweet.awesome_icon(:size => 13, :color => UIColor.lightGrayColor)
      rt_by = tweet.retweeted_by.screen_name.nsattributedstring(text_attributes[:rt_label])
      @rt_label.attributedText = rt_icon +" "+ rt_by
    else
      @rt_label.attributedText = nil
    end

    configure_star(tweet.favorited)
  end

  def configure_star(favorited)
    if favorited
      yellow = UIColor.colorWithRed(1.0, green:0.8, blue:0.0, alpha:1.0)
      star = :star.awesome_icon(:size => 16, :color => yellow).mutableCopy
      star.addAttribute(NSBackgroundColorAttributeName, value:UIColor.whiteColor, range:0..0)

      @fav_star_label.attributedText = star
    else
      @fav_star_label.attributedText = nil
    end
  end

  def layoutSubviews
    super

    self.contentView.frame = self.bounds

    # アイコンのレイアウト
    @user_image_view.frame = [[10, 10], [48, 48]]

    # タイムスタンプのレイアウト
    # 右側を揃えるために、sizeToFitしたあと右端からwidthを引いた値をorigin.xに指定
    @time_label.sizeToFit
    @time_label.frame = [[self.frame.size.width - @time_label.frame.size.width - 10, 10], @time_label.frame.size]

    # name_label & screen_name_label レイアウト
    # name_labelとtime_labelの間に40px以上のスペースがあればscreen_name_labelを配置
    # 最初にscreen_name_labelを初期化
    @screen_name_label.frame = CGRectZero

    @name_label.sizeToFit
    if @name_label.frame.size.width > @time_label.frame.origin.x - 65 - 40
      @name_label.frame = [[65, 10], [@time_label.frame.origin.x - 65, 16]]
    else
      @name_label.frame = [[65, 10], @name_label.frame.size]
      @screen_name_label.frame = [[@name_label.frame.size.width + 65 + 5, 13], [@time_label.frame.origin.x - 65 - @name_label.frame.size.width - 5, 13]]
    end

    # テキストのレイアウト
    @text_label.frame = [[65, 10 + 16 + 3], [self.frame.size.width - 65 - 10, self.frame.size.height - (10 + 16 + 3)]]
    @text_label.sizeToFit

    # retweeted by 表示のレイアウト
    if @rt_label.attributedText
      origin = @text_label.frame.origin
      origin.y += @text_label.frame.size.height

      @rt_label.frame = [origin, [self.frame.size.width - 65 - 10, 17]]
    else
      @rt_label.frame = CGRectZero
    end

    #星のレイアウト
    @fav_star_label.frame = [[self.frame.size.width - 23, 10], [16, 16]]
  end
end
