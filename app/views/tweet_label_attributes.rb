class TweetLabelAttributes
  attr_reader :attributes

  def self.sharedAttributes
    @instance ||= new
  end

  def initialize
    truncate_paragraph_style = NSMutableParagraphStyle.new
    truncate_paragraph_style.lineBreakMode = NSLineBreakByTruncatingTail

    word_wrap_paragraph_style = NSMutableParagraphStyle.new
    word_wrap_paragraph_style.lineBreakMode = NSLineBreakByCharWrapping

    @attributes ||= {
      :name_label => {
        NSForegroundColorAttributeName => UIColor.blackColor,
        NSFontAttributeName => UIFont.boldSystemFontOfSize(16),
        NSParagraphStyleAttributeName => truncate_paragraph_style
      },
      :screen_name_label => {
        NSForegroundColorAttributeName => UIColor.lightGrayColor,
        NSFontAttributeName => UIFont.systemFontOfSize(13),
        NSParagraphStyleAttributeName => truncate_paragraph_style
      },
      :time_label => {
        NSForegroundColorAttributeName => UIColor.lightGrayColor,
        NSFontAttributeName => UIFont.systemFontOfSize(13),
        NSParagraphStyleAttributeName => truncate_paragraph_style
      },
      :text_label => {
        NSForegroundColorAttributeName => UIColor.blackColor,
        NSFontAttributeName => UIFont.systemFontOfSize(15),
        NSParagraphStyleAttributeName => word_wrap_paragraph_style
      },
      :rt_label => {
        NSForegroundColorAttributeName => UIColor.lightGrayColor,
        NSFontAttributeName => UIFont.systemFontOfSize(13),
        NSParagraphStyleAttributeName => truncate_paragraph_style
      }
    }
  end
end
