class AddUserCell < UICollectionViewCell
  def initWithFrame(frame)
    super

    self << @add_icon = UILabel.new.tap do |label|
      label.textColor = UIColor.blueColor
      label.textAlignment = NSTextAlignmentCenter
      label.attributedText = :plus.awesome_icon(:size => 40).color(UIColor.lightGrayColor)
    end

    self << @description_label = UILabel.new.tap do |label|
      label.font = UIFont.systemFontOfSize(13)
      label.textColor = UIColor.blackColor
      label.lineBreakMode = NSLineBreakByTruncatingTail
      label.textAlignment = NSTextAlignmentCenter
      label.text = "Add User"
    end

    self.selectedBackgroundView = UIView.new.tap do |view|
      view.backgroundColor = UIColor.lightGrayColor
    end

    self.backgroundColor = UIColor.colorWithRed(0.950, green:0.950, blue:0.950, alpha:0.7)

    self
  end

  def layoutSubviews
    super

    @add_icon.frame = [[16, 10], [48, 48]]
    @description_label.frame = [[5, 60], [70, 13]]
  end
end
