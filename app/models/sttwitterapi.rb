class STTwitterAPI
  def self.shared_client
    @shared_client ||= self.twitterAPIOSWithFirstAccount
  end

  def get_tweets_with_ids(ids, successBlock: successBlock, errorBlock: errorBlock)
    getStatusesLookupTweetIDs(ids,
      includeEntities: 0,
      trimUser: 0,
      map: 0,
      successBlock: lambda{|tweets_raw|
        tweets = tweets_raw.map{|tweet| Tweet.new(tweet)}
        successBlock.call(tweets)
      },
      errorBlock: errorBlock
    )
  end

  def get_user_timeline(screenName, sinceID: sinceID, maxID: maxID, successBlock: successBlock, errorBlock: errorBlock)
    getUserTimelineWithScreenName(screenName,
      sinceID: sinceID,
      maxID: maxID,
      count: 100,
      successBlock: lambda{|tweets_raw|
        tweets = tweets_raw.map{|tweet| Tweet.new(tweet)}
        successBlock.call(tweets)
      },
      errorBlock: errorBlock
    )
  end
end
