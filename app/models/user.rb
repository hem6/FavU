class User
  attr_reader :screen_name, :name, :profile_image_url, :id

  def self.userWithScreenName(screen_name, &callback)
    client = STTwitterAPI.shared_client

    unless client.userName
      client.verifyCredentialsWithSuccessBlock(lambda{ |user_name|
        userWithScreenName(screen_name, &callback)
      }, errorBlock: lambda{ |error|
        UIAlertView.alert("Error", error.localizedDescription)
      })
      return
    end

    client.get_user_information_for(screen_name, successBlock: lambda{|data|
      user = User.new(data)
      callback.call(user)
    }, errorBlock:lambda{|error|
      UIAlertView.alert("Error", error.localizedDescription)
    })
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
end
