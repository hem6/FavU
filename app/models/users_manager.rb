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

  def userForIndexPath(indexPath)
    @users[indexPath.row]
  end

  def addUser(user)
    @users << user
  end

  def numberOfUser
    @users.count
  end
end
