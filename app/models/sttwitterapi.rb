class STTwitterAPI
  def self.shared_client
    @shared_client ||= self.twitterAPIOSWithFirstAccount
  end
end
