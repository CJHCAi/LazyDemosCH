# ZJCollectionViewSummary

博客地址：https://www.jianshu.com/p/ff7089782d6c

GitHub地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git

####1、ZJCollectionViewSummary的由来

项目对collectionView使用率较高，就花费了两周的业余时间对CollectionView进行了总结，并起名为[ZJCollectionViewSummary](https://github.com/zhijiaxin/ZJCollectionViewSummary.git)发布到了Github上了，感觉有用就给个星吧。

####2、ZJCollectionViewSummary的功能

####基础用法总结（只是代码实现、看代码即可）
>1、给CollectionView添加headerView
2、给CollectionView添加/删除cell以及添加section
3、CollectionView中cell 的多选

####进阶用法（抽取出了框架）
>1、实现图片轮播
2、CollectionView给添加右边索引
3、CollectionView长安拖动cell重新排序
4、常见的几种布局，包括水平/竖直华东缩小、水平/竖直流水布局、环形布局、网格布局。（后两种事网上常见的就拿来了）。

####3、各功能的示意图、介绍以及相关用法

####3.1、注：基础用法都是UI层面或是处理数据刷新界面

####3.1.1、给CollectionView添加headerView

![添加headerView.gif](https://upload-images.jianshu.io/upload_images/1204112-dbe7a6614a386595.gif?imageMogr2/auto-orient/strip)

设置
      
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 120);
直接将headerView添加到collectionView就可实现。即：

     [_collectionView addSubview:self.headerView];

也可以实现代理分组的形式实现添加headerView.若只有一组这是比较好使的代码简单，有利于查看。

####3.1.2、给CollectionView添加/删除cell以及添加section

![添加cell:section.gif](https://upload-images.jianshu.io/upload_images/1204112-2c004dafe47aeac0.gif?imageMogr2/auto-orient/strip)

都是操作数组刷新界面。没什么的。

####3.1.3、CollectionView中cell 的多选

![cell的全选.gif](https://upload-images.jianshu.io/upload_images/1204112-6e0ef7b88cb51bf5.gif?imageMogr2/auto-orient/strip)

思路：创建两个数组，一个是数据源_listArray，一个用作保存选中数据selectedArray。只有全选或非全选才刷新界面，点选只刷新当前cell。

核心代码：

    ZJMultiSelectCollectionViewCell *cell = (ZJMultiSelectCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dict = _listArray[indexPath.row];
    if ([self.selectedArray containsObject:dict]) {
        [self.selectedArray removeObject:dict];
        cell.markV.image = [UIImage imageNamed:@"unselected_icon"];
    }else{
        [self.selectedArray addObject:dict];
        cell.markV.image = [UIImage imageNamed:@"select_Icon"];
    }
    
    if (self.selectedArray.count < self.listArray.count) {
        self.isSelectAll = NO;//是否全选。
        [self.selectButton setImage:[UIImage imageNamed:@"unselected_icon"] forState:UIControlStateNormal];
    }

####3.2、进阶用法
#####3.2.1、实现图片轮播

![轮播.gif](https://upload-images.jianshu.io/upload_images/1204112-a9bfc3eaa34ad697.gif?imageMogr2/auto-orient/strip)

ZJCycleView可显示本地图片，也可以是网络图片，还可以本地图片与网络图片混合现实。样式如图。相关属性和方法。

    @class ZJCycleView;

    @protocol ZJCycleViewDelegate <NSObject>

    @optional

    /** 点击图片回调 */
    - (void)cycleView:(ZJCycleView *)cycleView didSelectItemAtIndex:(NSInteger)index;

    @end

    @interface ZJCycleView : UIView

    @property (nonatomic, weak) id <ZJCycleViewDelegate> delegate;

    /** 本地图片 */
    @property (nonatomic, strong) NSArray<NSString *> *images;
    /** 图片链接 */
    @property (nonatomic, strong) NSArray<NSString *> *urlA;
    /** 每张图片对应要显示的文字数组 */
    @property (nonatomic, strong) NSArray *titles;

    /** 图片和标题字典（字典结构为：@{@"imageUrl":@"",@"title":@""}） */
    @property (nonatomic, strong) NSArray<NSDictionary *> *arrayD;

    @property (nonatomic, assign) ZJCycleViewType cycleViewType;

    /** 自动轮播时间间隔,默认2s */
    @property (nonatomic, assign) CGFloat autoCycleTimeInterval;

    /** 是否显示分页控件 */
    @property (nonatomic, assign) BOOL showPageControl;

    /** 分页控件的位置 */
    @property (nonatomic, assign) ZJCyclePageContolLocation pageControlLocation;

    /** pageContol点的样式 */
    @property (nonatomic, assign) ZJCyclePageContolStyle pageContolStyle;

    /**
    初始化方法

    @param frame 位置尺寸
    @param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
    @param placeholderImage 占位图片
    @return ZJCycleView对象
    */
    - (instancetype)initWithFrame:(CGRect)frame
                    imageUrls:(NSArray <NSString *> *)imageUrls
             placeholderImage:(UIImage*)placeholderImage;

    /**
    初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20

    @param frame 位置尺寸
    @param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
    @param titles 每张图片对应要显示的文字数组
    @param placeholderImage 占位图片
    @return ZJCycleView对象
    */
    - (instancetype)initWithFrame:(CGRect)frame
                    imageUrls:(NSArray <NSString *> *)imageUrls
                       titles:(NSArray <NSString *> *)titles
             placeholderImage:(UIImage*)placeholderImage;

    /**
    初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20

    @param frame 位置尺寸
    @param arrayDict 是字典数组：（字典结构为：@{@"imageUrl":@"",@"title":@""}）imageUrl可以是本地的，也可以是网络的图片链接
    @param placeholderImage 占位图片
    @return ZJCycleView对象
    */
    - (instancetype)initWithFrame:(CGRect)frame
                    arrayDict:(NSArray <NSDictionary *> *)arrayDict
             placeholderImage:(UIImage*)placeholderImage;

    /**
    初始化方法

    @param frame 位置尺寸
    @param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
    @param placeholderImage 占位图片
    @return ZJCycleView对象
    */
    + (instancetype)cycleViewWithFrame:(CGRect)frame
                         imageUrls:(NSArray <NSString *> *)imageUrls
                  placeholderImage:(UIImage *)placeholderImage;

    /**
    初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20

    @param frame 位置尺寸
    @param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
    @param titles 每张图片对应要显示的文字数组
    @param placeholderImage 占位图片
    @return ZJCycleView对象
    */
    + (instancetype)cycleViewWithFrame:(CGRect)frame
                    imageUrls:(NSArray <NSString *> *)imageUrls
                       titles:(NSArray <NSString *> *)titles
             placeholderImage:(UIImage*)placeholderImage;

    /**
    初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20

    @param frame 位置尺寸
    @param arrayDict 是字典数组：（字典结构为：@{@"imageUrl":@"",@"title":@""}）imageUrl可以是本地的，也可以是网络的图片链接
    @param placeholderImage 占位图片
    @return ZJCycleView对象
    */
    + (instancetype)cycleViewWithFrame:(CGRect)frame
                         arrayDict:(NSArray <NSDictionary *> *)arrayDict
                  placeholderImage:(UIImage*)placeholderImage;

    /**
    当选中的ZJCyclePageContolStyle 是ZJCyclePageContolStyleImage, 图片类型的时候调用，如果不调用使用默认图片

    @param currentImage 选中图片
    @param pageImage 默认图片
    */
    - (void)currentImage:(UIImage *)currentImage
          pageImage:(UIImage *)pageImage;

    /**
    当选中的ZJCyclePageContolStyle 不是ZJCyclePageContolStyleImage,如果不使用默认颜色，可以调用此方法设置

    @param currentColor 选中颜色
    @param pageColor 默认颜色
    */
    -(void)currentColor:(UIColor *)currentColor
          pageColor:(UIColor *)pageColor;

####3.2.2、CollectionView给添加右边索引
![添加索引.gif](https://upload-images.jianshu.io/upload_images/1204112-12302855b573e8e3.gif?imageMogr2/auto-orient/strip)

    - (ZJCollectionViewRightIndex *)collectionViewIndex
    {
        if (_collectionViewIndex == nil) {
            _collectionViewIndex = [[ZJCollectionViewRightIndex alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 0, 20, SCREEN_HEIGHT)];
            _collectionViewIndex.titleIndexes = self.listArray;
            _collectionViewIndex.color = [UIColor blackColor];
            _collectionViewIndex.isSelectVisible = YES;
            CGRect rect = _collectionViewIndex.frame;
            rect.size.height = _collectionViewIndex.titleIndexes.count * 16;
            rect.origin.y = (SCREEN_HEIGHT - rect.size.height) / 2 + 64;
            _collectionViewIndex.frame = rect;
            _collectionViewIndex.collectionDelegate = self;
        }
        return _collectionViewIndex;
    }

    #pragma mark- ZJCollectionViewRightIndexDelegate
    -(void)collectionViewIndex:(ZJCollectionViewRightIndex *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title{
        
        if ([_collectionView numberOfSections]>index&&index>-1) {
            
            UICollectionViewLayoutAttributes *attributes = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
            CGRect rect = attributes.frame;
            [_collectionView setContentOffset:CGPointMake(_collectionView.frame.origin.x, rect.origin.y - 40) animated:YES];
            
        }
     }

####3.2.3、CollectionView长安拖动cell重新排序

![长安拖动.gif](https://upload-images.jianshu.io/upload_images/1204112-9be3de452e8c9da9.gif?imageMogr2/auto-orient/strip)

主要代码：

        ZJReorderFlowLayout *layout = [[ZJReorderFlowLayout alloc] init];
        CGFloat cellWidth = (SCREEN_WIDTH - 20) / 3.0;
        layout.itemSize = CGSizeMake(cellWidth, 145);
        _collectionView = [[UICollectionView alloc] initWithFrame:size collectionViewLayout:layout];

    #pragma mark - ZJReorderCollectionViewDataSource methods
    - (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
        NSDictionary *dict = self.listArray[fromIndexPath.item];
        
        [self.listArray removeObjectAtIndex:fromIndexPath.item];
        [self.listArray insertObject:dict atIndex:toIndexPath.item];
    }

    - (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
    {
        return YES;
    }

    - (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
    {
        return YES;
    }

    #pragma mark - ZJReorderCollectionViewDelegateFlowLayout methods
    - (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
        NSLog(@"将开始拖动");
    }

    - (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
        NSLog(@"开始拖动完成");
    }

    - (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
        NSLog(@"将拖动完成");
    }

    - (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
        NSLog(@"拖动完成");
    }

####3.2.4、常见的几种布局，包括水平/竖直华东缩小、水平/竖直流水布局、
####A、水平/竖直华东缩小

![线性布局（水平与竖直）.gif](https://upload-images.jianshu.io/upload_images/1204112-9aea6c5eaae91ec5.gif?imageMogr2/auto-orient/strip)

    self.currentIndex = 0;
    if (self.layout.lineDirection == ZJWaterHorizontal)
    {
        self.layout.lineDirection = ZJWaterVertical;
        [self.collectionView setCollectionViewLayout:self.layout animated:YES];
    } else {
        self.layout.lineDirection = ZJWaterHorizontal;
        [self.collectionView setCollectionViewLayout:self.layout animated:YES];
    }
    [self.collectionView reloadData];

####B、水平/竖直流水布局

![流水布局（竖直:水平）.gif](https://upload-images.jianshu.io/upload_images/1204112-b99159968a1e4240.gif?imageMogr2/auto-orient/strip)

    typedef NS_ENUM(NSInteger, ZJWaterDirection) {
        ZJWaterVertical,//竖直方向布局
        ZJWaterHorizontal//水平方向布局
    };

    @protocol ZJWaterLayoutDelegate <NSObject>

    @required
    /** 宽高转换：ZJWaterVertical根据宽算高，ZJWaterHorizontal根据高算宽 */
    - (CGFloat)waterFlowLayout:(ZJWaterLayout *)layout hieghtForItemAtIndex:(NSUInteger)index itemwidth:(CGFloat)itemwidth;

    @optional
    /** 列数 */
    - (NSInteger)waterFlowLayoutColumnCount:(ZJWaterLayout *)layout;
    /** 列间距 */
    - (CGFloat)waterFlowLayoutColumnSpacing:(ZJWaterLayout *)layout;
    /** 行间距 */
    - (CGFloat)waterFlowLayoutRowSpacing:(ZJWaterLayout *)layout;
    /** 边距 */
    - (UIEdgeInsets)waterFlowLayoutEdgeInsets:(ZJWaterLayout *)layout;

    @end

    @interface ZJWaterLayout : UICollectionViewLayout
    /** 代理 */
    @property (nonatomic,weak) id <ZJWaterLayoutDelegate> delegate;
    /** 布局方向 */
    @property (nonatomic, assign) ZJWaterDirection waterDirection;

    @end
