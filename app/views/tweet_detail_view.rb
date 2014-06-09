class TweetDetailView < UIView
  attr_accessor :webView, :indicatorView

  def initWithFrame(frame)
    super

    self << @webView = UIWebView.alloc.initWithFrame(self.bounds).tap do |wv|
      wv.scrollView.contentInset = [0, 0, 64, 0]
      wv.scalesPageToFit = true
    end

    self << @indicatorView = UIActivityIndicatorView.new.tap do |iv|
      iv.style = UIActivityIndicatorViewStyleGray
      iv.center = [self.center.x, self.center.y - 64]
    end

    self
  end
end
