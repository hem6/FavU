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
        unless tweets_raw.instance_of?(Array) # エラーのときerrorBlockが呼ばれずにこちらが呼ばれるので判定
          error = error_with_hash(tweets_raw)
          errorBlock.call(error)
          break
        end
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
        unless tweets_raw.instance_of?(Array) # エラーのときerrorBlockが呼ばれずにこちらが呼ばれるので判定
          error = error_with_hash(tweets_raw)
          errorBlock.call(error)
          break
        end
        tweets = tweets_raw.map{|tweet| Tweet.new(tweet)}
        successBlock.call(tweets)
      },
      errorBlock: errorBlock
    )
  end

  def get_user_information_for(screenName, successBlock: successBlock, errorBlock: errorBlock)
    getUserInformationFor(screenName,
      successBlock: lambda{|data|
        if data["error"]
          error = error_with_hash(data)
          errorBlock.call(error)
          break
        end
        successBlock.call(data)
      },
      errorBlock:errorBlock
    )
  end

  def error_with_hash(data)
    domain = "com.twitter.hem6"
    code = 1
    user_info = {
      NSLocalizedDescriptionKey => data["error"]
    }
    return NSError.errorWithDomain(domain, code: code, userInfo: user_info)
  end
end
