class TweetDetailView < UIView
  attr_accessor :webView

  def initWithFrame(frame)
    super
    self << @webView = UIWebView.alloc.initWithFrame(self.bounds).tap do |wv|
      wv.scrollView.contentInset = [0, 0, 64, 0]
    end
  end
end
