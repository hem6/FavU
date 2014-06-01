class AddUserView < UIView
  attr_accessor :text_field, :add_button

  def initWithFrame(frame)
    super

    self.backgroundColor = UIColor.lightGrayColor

    self << @text_field = UITextField.new.tap do |tf|
      tf.placeholder = "user name"
      tf.textAlignment = UITextAlignmentCenter
      tf.autocapitalizationType = UITextAutocapitalizationTypeNone
      tf.borderStyle = UITextBorderStyleRoundedRect
    end
  end

  def layoutSubviews
    @text_field.frame = [[self.frame.origin.x + 10,
                          self.frame.origin.y + 74],
                         [self.frame.size.width - 20, 26]]
  end
end
