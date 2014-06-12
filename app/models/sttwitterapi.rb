class STTwitterAPI
  def self.shared_client
    @accounts_manager ||= AccountsManager.sharedManager
    @shared_client ||= self.twitterAPIOSWithAccount(@accounts_manager.currentAccount)
    return @shared_client
  end

  def self.changeAccount(account)
    @shared_client = self.twitterAPIOSWithAccount(account)
  end

  def get_tweets_with_ids(ids, successBlock: successBlock, errorBlock: errorBlock)
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true
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

        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      },
      errorBlock: lambda{|error|
        errorBlock.call(error)
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      }
    )
  end

  def get_user_timeline(screenName, sinceID: sinceID, maxID: maxID, successBlock: successBlock, errorBlock: errorBlock)
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true
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

        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      },
      errorBlock: lambda{|error|
        errorBlock.call(error)
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      }
    )
  end

  def get_user_information_for(screenName, successBlock: successBlock, errorBlock: errorBlock)
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true
    getUserInformationFor(screenName,
      successBlock: lambda{|data|
        if data["error"]
          error = error_with_hash(data)
          errorBlock.call(error)
          break
        end

        successBlock.call(data)

        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      },
      errorBlock:lambda{|error|
        errorBlock.call(error)
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      }
    )
  end

  def favu_postFavoriteState(state, forStatusID: id)
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true

    on_complete = lambda{|status|
      UIApplication.sharedApplication.networkActivityIndicatorVisible = false
    }

    postFavoriteState(state,
              forStatusID: id,
             successBlock: on_complete,
               errorBlock: on_complete)
  end

  def error_with_hash(data)
    domain = "com.twitter.uemue"
    code = 1
    user_info = {
      NSLocalizedDescriptionKey => data["error"]
    }
    return NSError.errorWithDomain(domain, code: code, userInfo: user_info)
  end
end
