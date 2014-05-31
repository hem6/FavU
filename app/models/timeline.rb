class Timeline
  attr_accessor :user, :tweets

  def initialize(user)
    @user = user
    @tweets = []
    @client = STTwitterAPI.shared_client
    update
  end

  def count
    @tweets.count
  end

  def tweetForIndexPath(indexPath)
    @tweets[indexPath.row]
  end

  def update(append=false)
    unless @client.userName
      @client.verifyCredentialsWithSuccessBlock(lambda{ |user_name|
        update(append)
      }, errorBlock: lambda{ |error|
        UIAlertView.alert("Error", error.description)
      })

      return
    end

    get_user_timeline(append) do |tweets|
      unless tweets.instance_of?(Array) # エラーのときerrorBlockが呼ばれずになぜかこちらが呼ばれるので判定
        UIAlertView.alert("Error", tweets["error"]) if tweets.instance_of?(Hash)
        break
      end

      in_reply_to_status_ids = extract_in_reply_to_status_ids(tweets)

      get_tweets_with_ids(in_reply_to_status_ids) do |in_reply_to_tweets|
        merged_tweets = merge_in_reply_to_tweets(tweets, in_reply_to_tweets)
        if append
          append_tweets(merged_tweets)
        else
          prepend_tweets(merged_tweets)
        end
      end
    end
  end

  private

  def get_tweets_with_ids(ids, &callback)
    @client.getStatusesLookupTweetIDs(ids,
      includeEntities: 0,
      trimUser: 0,
      map: 0,
      successBlock: callback,
      errorBlock: lambda { |error| puts error }
    )
  end

  def get_user_timeline(append, &callback)
    @client.getUserTimelineWithScreenName(@user['screen_name'],
      sinceID: append ? nil : newest_tweet_id,
      maxID: append ? oldest_tweet_id : nil,
      count: 100,
      successBlock: callback,
      errorBlock: lambda { |error|
        self.tweets = @tweets # KVOの通知を送る
        UIAlertView.alert("Error", error.description)
      }
    )
  end

  def extract_in_reply_to_status_ids(tweets)
    tweets.map{ |tweet| tweet["in_reply_to_status_id_str"] }.compact
  end

  def merge_in_reply_to_tweets(tweets, in_reply_to_tweets)
    base_tweets = tweets.mutableCopy
    inserted_count = 0

    tweets.each_with_index do |from_tweet, index|
      next unless from_tweet['in_reply_to_status_id_str']

      to_tweet = in_reply_to_tweets.find do |in_reply_to_tweet|
        from_tweet['in_reply_to_status_id_str'] == in_reply_to_tweet['id_str']
      end

      if to_tweet
        base_tweets.insert(index + 1 + inserted_count, to_tweet)
        inserted_count += 1
      end
    end

    return base_tweets
  end

  def newest_tweet_id
    newest_tweet = @tweets.first
    return newest_tweet ? newest_tweet["id_str"] : nil
  end

  def oldest_tweet_id
    oldest_tweet = @tweets.last
    return oldest_tweet ? oldest_tweet["id_str"] : nil
  end

  def prepend_tweets(tweets)
    self.tweets = tweets + @tweets
  end

  def append_tweets(tweets)
    self.tweets = @tweets + tweets
  end
end
