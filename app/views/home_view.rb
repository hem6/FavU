class HomeView < UIView
  attr_accessor :tableView, :refreshControl, :collectionView

  def initWithFrame(frame)
    if super
      @tableView = UITableView.new.tap do |table|
        table.frame = CGRectZero
        table.contentInset = [0, 0, 0, 0]
        table.registerClass(TweetCell, forCellReuseIdentifier:"Cell")
      end
      self << @tableView

      @refreshControl = UIRefreshControl.new
      @tableView << @refreshControl

      flowLayout = LXReorderableCollectionViewFlowLayout.new.tap do |layout|
        layout.itemSize = [80, 80]
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal
      end

      @collectionView = UICollectionView.alloc.initWithFrame(CGRectZero, collectionViewLayout: flowLayout).tap do |collectionView|
        collectionView.frame = [[0, self.frame.size.height - 80], [self.frame.size.width, 80]]
        collectionView.registerClass(UserCell, forCellWithReuseIdentifier:"UserCell")
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundView = UIToolbar.alloc.initWithFrame(self.bounds)
      end
      self << @collectionView

      self
    end
  end

  def layoutSubviews
    @tableView.frame = [[0, 0], [self.bounds.size.width, self.bounds.size.height - 80]]
  end
end
