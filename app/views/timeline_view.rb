class TimelineView < UIView
  attr_accessor :tableView, :refreshControl

  def initWithFrame(frame)
    return self unless super

    self << @tableView = UITableView.new.tap do |table|
      table.frame = CGRectZero
      table.registerClass(TweetCell, forCellReuseIdentifier:"TweetCell")
    end

    @tableView << @refreshControl = UIRefreshControl.new

    self
  end

  def layoutSubviews
    super
    @tableView.frame = self.bounds
  end
end
