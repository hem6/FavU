class UsersManager
  attr_reader :users
  def self.sharedManager
    @instance ||= UsersManager.new
  end

  def initialize
    @users = []
    loadUsers
  end

  def loadUsers
    @users = NSUserDefaults[:users]
  end

  def saveUsers
    NSUserDefaults[:users] = @users
  end

  def userForIndexPath(indexPath)
    @users[indexPath.row]
  end

  def indexPathForUser(user)
    row = @users.index{|u| u["screen_name"] == user["screen_name"]}
    [0, row].nsindexpath
  end

  def deleteUserForIndexPath(indexPath)
    @users.delete_at(indexPath.row)
  end

  def addUser(user)
    @users << user
  end

  def numberOfUsers
    @users.count
  end

  def moveUser(fromIndexPath, toIndexPath)
    temp = @users.delete_at(fromIndexPath.row)
    @users.insert(toIndexPath.row, temp)
  end
end
