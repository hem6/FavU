class AddUserView < UIView
  attr_accessor :text_field, :add_button
  
  def initWithFrame(frame)
    super

    self.backgroundColor = UIColor.whiteColor

    self << @text_field = UITextField.new.tap do |tf|
      tf.placeholder = "user name"
      tf.textAlignment = UITextAlignmentCenter
      tf.autocapitalizationType = UITextAutocapitalizationTypeNone
      tf.borderStyle = UITextBorderStyleRoundedRect
    end

    self << @add_button = UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |btn|
      btn.setTitle("add", forState:UIControlStateNormal)
    end
  end

  def layoutSubviews
    @text_field.frame = [[100, 100], [160, 26]]
    @add_button.sizeToFit
    @add_button.frame = [[100, 130], @add_button.frame.size]
  end
end
