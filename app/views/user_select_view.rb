class UserSelectView < UIView
  attr_accessor :collectionView

  def initWithFrame(frame)
    return self unless super

    flowLayout = LXReorderableCollectionViewFlowLayout.new.tap do |layout|
      layout.itemSize = [80, 80]
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      layout.scrollDirection = UICollectionViewScrollDirectionHorizontal
    end

    @collectionView = UICollectionView.alloc.initWithFrame(CGRectZero, collectionViewLayout: flowLayout).tap do |cv|
      cv.registerClass(UserCell, forCellWithReuseIdentifier:"UserCell")
      cv.registerClass(AddUserCell, forCellWithReuseIdentifier:"AddUserCell")
      cv.scrollsToTop = false
      cv.showsHorizontalScrollIndicator = false
      cv.backgroundColor = "#1E95D4".uicolor
    end
    self << @collectionView

    self
  end

  def layoutSubviews
    super
    @collectionView.frame = self.bounds
  end
end
