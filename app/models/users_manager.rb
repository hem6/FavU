class UsersManager
  attr_accessor :users
  def self.sharedManager
    @instance ||= UsersManager.new
  end

  def initialize
    loadUsers
  end

  def loadUsers
    users = NSUserDefaults[:users] || []
    @users = users.map{|u| User.new(u) }
  end

  def saveUsers
    NSUserDefaults[:users] = @users.map{|u| u.to_hash }
  end

  # UsersCacheにはタイムラインを読み込む際に現れたユーザー情報が保存されている。
  # @usersにはNSUserDefaultsからロードされた古い情報が入っているので、
  # UsersCacheに同一のユーザーが含まれていればそれと置き換える。
  def updateUsers
    cache = UsersCache.sharedCache
    @users.map do |u|
      cache.userForId(u.id) || u
    end
  end

  def userForIndexPath(indexPath)
    @users[indexPath.row]
  end

  def indexPathForUser(user)
    row = @users.index{|u| u.screen_name == user.screen_name}
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
end
