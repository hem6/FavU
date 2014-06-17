describe Tweet do
  before do
    @data = {
      "id" => 111111111111111111,
      "in_reply_to_status_id" => 111111111111111110,
      "text" => "@uemue hello!",
      "user" => {"screen_name" => "uemue9", "id" => 1234567},
      "favorited" => false
    }
    @tweet = Tweet.new(@data)
  end

  describe "#initialize" do
    context "with simple tweet" do
      it "has right id" do
        @tweet.id.should.equal @data["id"]
      end

      it "has right reply_to" do
        @tweet.reply_to.should.equal @data["in_reply_to_status_id"]
      end

      it "has right text" do
        @tweet.text.should.equal @data["text"]
      end

      it "has right user" do
        @tweet.user.id.should.equal User.new(@data["user"]).id
      end

      it "has right favorited status" do
        @tweet.favorited.should.equal @data["favorited"]
      end

      it "has no retweeted_by user" do
        @tweet.retweeted_by.should.be.nil
      end
    end

    context "with retweet" do
      before do
        @retweeted = {
          "id" => 111111111111111111,
          "in_reply_to_status_id" => 111111111111111110,
          "text" => "@uemue hello!",
          "user" => {"screen_name" => "uemue9", "id" => 1234567},
          "favorited" => false
        }

        @data = {
          "id" => 111111111111111113,
          "in_reply_to_status_id" => nil,
          "text" => "RT @uemue hello!",
          "user" => {"screen_name" => "uemue", "id" => 1234565},
          "favorited" => false,
          "retweeted_status" => @retweeted
        }

        @tweet = Tweet.new(@data)
      end

      it "has right id" do
        @tweet.id.should.equal @data["id"]
      end

      it "has right reply_to" do
        @tweet.reply_to.should.equal @data["in_reply_to_status_id"]
      end

      it "has right text" do
        @tweet.text.should.equal @retweeted["text"]
      end

      it "has right user" do
        @tweet.user.id.should.equal User.new(@retweeted["user"]).id
      end

      it "has right favorited status" do
        @tweet.favorited.should.equal @retweeted["favorited"]
      end

      it "has no retweeted_by user" do
        @tweet.retweeted_by.id.should.equal User.new(@data["user"]).id
      end
    end
  end

  describe "#favorite" do
    it "set true to favorited status" do
      @tweet.favorite
      @tweet.favorited.should.be.true
    end
  end

  describe "#unfavorite" do
    it "set false to favorited status" do
      @tweet.unfavorite
      @tweet.favorited.should.be.false
    end
  end
end
