class UserCell < UICollectionViewCell
  def initWithFrame(frame)
    super

    self << @image_view = UIImageView.new

    self << @name_label = UILabel.new.tap do |label|
      label.font = UIFont.systemFontOfSize(13)
      label.textColor = UIColor.whiteColor
      label.lineBreakMode = NSLineBreakByTruncatingTail
      label.textAlignment = NSTextAlignmentCenter
    end

    self.selectedBackgroundView = UIView.new.tap do |view|
      view.backgroundColor = "#5EC5F4".uicolor
    end

    self.backgroundColor = "#1E95D4".uicolor

    self
  end

  def fillWithUser(user)
    placeholder_image = UIImage.imageNamed("placeholder.png")
    @image_view.setImageWithURL(user.profile_image_url.nsurl,
                                placeholderImage: placeholder_image)
    @name_label.text = user.screen_name
  end

  def layoutSubviews
    super

    @image_view.frame = [[16, 10], [48, 48]]
    @name_label.frame = [[5, 60], [70, 13]]
  end
end
