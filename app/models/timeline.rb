class Timeline
  attr_accessor :user, :tweets, :displayOffset

  def initialize(user)
    @user = user
    @tweets = []
    @displayOffset = [0, -64]
    @updating = false
    @prepended = false
  end

  def updating?
    @updating
  end

  def prepended?
    @prepended
  end

  def count
    @tweets.count
  end

  def tweetForIndexPath(indexPath)
    @tweets[indexPath.row]
  end

  def update(append=false)
    client = STTwitterAPI.shared_client

    unless client.userName
      client.verifyCredentialsWithSuccessBlock(lambda{ |user_name|
        update(append)
      }, errorBlock: lambda{ |error|
        UIAlertView.alert("Error", error.localizedDescription)
      })

      return
    end

    @updating = true

    get_user_timeline(append) do |tweets|
      in_reply_to_status_ids = extract_in_reply_to_status_ids(tweets)

      get_tweets_with_ids(in_reply_to_status_ids) do |in_reply_to_tweets|
        merged_tweets = merge_in_reply_to_tweets(tweets, in_reply_to_tweets)
        @prepended = !append
        if append
          append_tweets(merged_tweets)
        else
          prepend_tweets(merged_tweets)
        end
      end

      @updating = false
    end
  end

  private

  def get_tweets_with_ids(ids, &callback)
    client = STTwitterAPI.shared_client

    ids_str = ids.map{|id| id.to_s }
    client.get_tweets_with_ids(ids,
      successBlock: callback,
      errorBlock: lambda { |error| puts error }
    )
  end

  def get_user_timeline(append, &callback)
    client = STTwitterAPI.shared_client

    client.get_user_timeline(@user.screen_name,
      sinceID: !append && newest_tweet_id ? newest_tweet_id.to_s : nil,
      maxID: append ? (oldest_tweet_id - 1).to_s : nil,
      successBlock: callback,
      errorBlock: lambda { |error|
        self.tweets = @tweets # KVOの通知を送る
        UIAlertView.alert("Error", error.localizedDescription)
        @updating = false
      }
    )
  end

  def extract_in_reply_to_status_ids(tweets)
    tweets.map{ |tweet| tweet.reply_to }.compact
  end

  def merge_in_reply_to_tweets(tweets, in_reply_to_tweets)
    base_tweets = tweets.mutableCopy
    inserted_count = 0

    tweets.each_with_index do |from_tweet, index|
      next unless from_tweet.reply_to

      to_tweet = in_reply_to_tweets.find do |in_reply_to_tweet|
        from_tweet.reply_to == in_reply_to_tweet.id
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
    return newest_tweet ? newest_tweet.id : nil
  end

  def oldest_tweet_id
    oldest_tweet = @tweets.last
    return oldest_tweet ? oldest_tweet.id : nil
  end

  def prepend_tweets(tweets)
    self.tweets = tweets + @tweets
  end

  def append_tweets(tweets)
    self.tweets = @tweets + tweets
  end
end
