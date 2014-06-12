class AccountsViewController < UITableViewController
  def viewDidLoad
    @accounts_manager = AccountsManager.sharedManager
    self.tableView.registerClass(UITableViewCell, forCellReuseIdentifier:"Cell")

    unless @accounts_manager.currentAccount
      STTwitterAPI.shared_client.verifyCredentialsWithSuccessBlock(lambda{|user_name|
        @accounts_manager.init_accounts
        self.tableView.reloadData
      }, errorBlock: lambda{|error|})
    end
  end

  ### UITableViewDataSource

  def tableView(tableView, numberOfRowsInSection:section)
    @accounts_manager.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    account = @accounts_manager.accountForIndexPath(indexPath)

    cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
    cell.textLabel.text = account.username

    if account.identifier == @accounts_manager.currentAccount.identifier
      cell.accessoryType = UITableViewCellAccessoryCheckmark
      @selected_index_path = indexPath
    else
      cell.accessoryType = UITableViewCellAccessoryNone
    end

    cell
  end

  ### UITableViewDelegate

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)

    before_selected_cell = tableView.cellForRowAtIndexPath(@selected_index_path)
    before_selected_cell.accessoryType = UITableViewCellAccessoryNone

    selected_cell = tableView.cellForRowAtIndexPath(indexPath)
    selected_cell.accessoryType = UITableViewCellAccessoryCheckmark
    @selected_index_path = indexPath

    account = @accounts_manager.accountForIndexPath(indexPath)
    @accounts_manager.selectAccountWithIdentifier(account.identifier)
  end
end
