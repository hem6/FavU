class User
  attr_reader :screen_name, :name, :profile_image_url, :id

  def self.userWithScreenName(screen_name)
    user = self.alloc.initWithScreenName(screen_name)
    return user
  end

  def initialize(data)
    init_with_data(data)
    return self
  end

  def to_hash
    return {
      "screen_name" => @screen_name,
      "name" => @name,
      "profile_image_url" => @profile_image_url,
      "id" => @id
    }
  end

  def init_with_data(data)
    @screen_name       = data["screen_name"]
    @name              = data["name"]
    @profile_image_url = data["profile_image_url"]
    @id                = data["id"]
  end

  def initWithScreenName(screen_name)
    @screen_name = screen_name
    client = STTwitterAPI.shared_client

    unless client.userName
      client.verifyCredentialsWithSuccessBlock(lambda{ |user_name|
        initWithScreenName(screen_name)
      }, errorBlock: lambda{ |error|
        UIAlertView.alert("Error", error.localizedDescription)
      })
      return self
    end

    client.get_user_information_for(@screen_name, successBlock: lambda{|data|
      init_with_data(data)
    }, errorBlock:lambda{|error|
      UIAlertView.alert("Error", error.localizedDescription)
    })
    return self
  end
end
