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
    @web_view.delegate = self

    @indicator_view = @tweet_detail_view.indicatorView
    @indicator_view.startAnimating

    url = "https://twitter.com/#{@tweet.user.screen_name}/status/#{@tweet.id}".nsurl
    request = NSURLRequest.requestWithURL(url)

    @web_view.loadRequest(request)
    self.view = @tweet_detail_view
  end

  def webViewDidFinishLoad(webView)
    @indicator_view.stopAnimating
  end
end
