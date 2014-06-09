class UsersCache
  def self.sharedCache
    @shared_cache ||= UsersCache.new
  end

  def initialize
    @users = {}
  end

  def cacheUser(user)
    return if @users.include?(user.id)
    @users[user.id] = user
  end

  def userForId(id)
    return @users[id]
  end
end
