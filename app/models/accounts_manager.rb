class AccountsManager
  attr_reader :currentAccount

  def self.sharedManager
    @instance ||= AccountsManager.new
  end

  def initialize
    @account_store = ACAccountStore.new
    type = @account_store.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    @accounts = @account_store.accountsWithAccountType(type)
    init_current_account
  end

  def init_current_account
    return if @accounts.count == 0

    identifier = NSUserDefaults[:account_identifier]
    selectAccountWithIdentifier(identifier)

    @currentAccount ||= @accounts.first
  end

  def selectAccountWithIdentifier(identifier)
    NSUserDefaults[:account_identifier] = identifier
    @currentAccount = @account_store.accountWithIdentifier(identifier)
    STTwitterAPI.changeAccount(@currentAccount)
  end

  def count
    @accounts.count
  end

  def accountForIndexPath(indexPath)
    @accounts[indexPath.row]
  end
end
