describe User do
  before do
    @data = {
      "screen_name" => "uemue",
      "name" => "Uem",
      "profile_image_url" => "http://pbs.twimg.com/profile_images/475605971058712577/SOJto7IT_normal.png",
      "id" => 2554490028
    }
    @user = User.new(@data)
  end

  describe "#initWithScreenName" do
    before do
      @screen_name = "uemue"
      @user = User.alloc.initWithScreenName(@screen_name)
    end

    it "returns an instance with passed screen_name" do
      @user.screen_name.should.equal @screen_name
    end

    it "fetches other paramaters" do
      wait 3.0 do
        @user.id.should.not.be.nil
      end
    end
  end

  describe "#initialize" do
    it "has right screen_name" do
      @user.screen_name.should.equal @data["screen_name"]
    end

    it "has right name" do
      @user.name.should.equal @data["name"]
    end

    it "has right profile_image_url" do
      @user.profile_image_url.should.equal @data["profile_image_url"]
    end

    it "has right id" do
      @user.id.should.equal @data["id"]
    end
  end

  describe "#to_hash" do
    before do
      @hash = @user.to_hash
    end

    it "has right data" do
      @hash.should.equal @data
    end
  end
end
