class UsersManager
  attr_accessor :users
  def self.sharedManager
    @instance ||= UsersManager.new
  end

  def initialize
    @client = STTwitterAPI.shared_client
    loadUsers
  end

  def loadUsers
    @users = NSUserDefaults[:users] || []
  end

  def saveUsers
    NSUserDefaults[:users] = @users
  end

  def userForIndexPath(indexPath)
    @users[indexPath.row]
  end

  def indexPathForUser(user)
    row = @users.index{|u| u["screen_name"] == user["screen_name"]}
    return [0, row].nsindexpath if row
    nil
  end

  def deleteUserForIndexPath(indexPath)
    @users.delete_at(indexPath.row)
    self.users = @users # KVOの通知を送るためself.users=を呼ぶ
  end

  def addUser(user)
    self.users = @users << user # KVOの通知を送るためself.users=を呼ぶ
  end

  def numberOfUsers
    @users.count
  end

  def moveUser(fromIndexPath, toIndexPath)
    temp = @users.delete_at(fromIndexPath.row)
    @users.insert(toIndexPath.row, temp)
  end

  def addUserWithScreenName(screenName)
    unless @client.userName
      @client.verifyCredentialsWithSuccessBlock(lambda{ |user_name|
        addUserWithScreenName(screenName)
      }, errorBlock: lambda{ |error|
        puts error
      })

      return
    end

    @client.getUserInformationFor(screenName, successBlock: lambda{|user|
      addUser(user)
    }, errorBlock: nil)
  end
end
