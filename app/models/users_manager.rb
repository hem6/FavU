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
