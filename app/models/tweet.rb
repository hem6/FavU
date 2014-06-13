class Tweet
  attr_reader :id, :reply_to, :text, :user, :favorited, :retweeted_by, :created_at

  def initialize(data)
    if data["retweeted_status"]
      fill_with_data(data["retweeted_status"])
      @id = data["id"]
      @reply_to = data["in_reply_to_status_id"]
      @retweeted_by = User.new(data["user"])
    else
      fill_with_data(data)
      UsersCache.sharedCache.cacheUser(@user)
    end

    self
  end

  def fill_with_data(data)
    @id         = data["id"]
    @reply_to   = data["in_reply_to_status_id"]
    @text       = data["text"].unescape_tweet
    @user       = User.new(data["user"])
    @favorited  = data["favorited"]
    @created_at = data["created_at"]
  end

  def toggleFavorite
    if @favorited
      unfavorite
    else
      favorite
    end
  end

  def favorite
    client = STTwitterAPI.shared_client
    client.favu_postFavoriteState(true,
              forStatusID: @id.to_s)

    @favorited = true
  end

  def unfavorite
    client = STTwitterAPI.shared_client
    client.favu_postFavoriteState(false,
              forStatusID: @id.to_s)

    @favorited = false
  end
end
