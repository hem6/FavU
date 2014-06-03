class TweetDetailViewController < UIViewController
  def initialize(tweet)
    @tweet = tweet
  end

  def viewDidLoad
    super
    config_web_view
  end

  def config_web_view
    @tweet_detail_view = TweetDetailView.alloc.initWithFrame(self.view.bounds)
    @web_view = @tweet_detail_view.webView

    url = "https://twitter.com/#{@tweet["user"]["screen_name"]}/status/#{@tweet["id_str"]}".nsurl
    request = NSURLRequest.requestWithURL(url)

    @web_view.loadRequest(request)
    self.view = @tweet_detail_view
  end
end
