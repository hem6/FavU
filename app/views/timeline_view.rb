class TimelineView < UIView
  attr_accessor :tableView, :refreshControl, :indicatorView

  def initWithFrame(frame)
    return self unless super

    self << @tableView = UITableView.new.tap do |table|
      table.frame = CGRectZero
      table.registerClass(TweetCell, forCellReuseIdentifier:"TweetCell")
      table.allowsSelection = false
    end

    @tableView << @refreshControl = UIRefreshControl.new

    @tableView.tableFooterView = UIView.new.tap do |fv|
      fv.frame = [[0, 0], [self.frame.size.width, 44]]

      @indicatorView = UIActivityIndicatorView.new.tap do |iv|
        iv.style = UIActivityIndicatorViewStyleGray
        iv.center = [fv.center.x, fv.center.y]
      end

      fv << @indicatorView
    end

    self
  end

  def layoutSubviews
    super
    @tableView.frame = self.bounds
  end
end
