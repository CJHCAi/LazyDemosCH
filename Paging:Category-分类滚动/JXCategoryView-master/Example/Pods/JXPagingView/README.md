# JXPagingView

类似微博主页、简书主页、QQ联系人页面等效果。多页面嵌套，既可以上下滑动，也可以左右滑动切换页面。支持HeaderView悬浮、支持下拉刷新、上拉加载更多。

## 功能特点

- 支持OC与Swift;
- 支持列表懒加载，等到列表真正显示的时候才加载，而不是一次性加载所有列表；
- 支持首页下拉刷新、列表视图下拉刷新、列表视图上拉加载更多；
- 支持悬浮SectionHeader的垂直位置调整；
- 列表封装简洁，只要遵从`JXPagingViewListViewDelegate`协议即可。UIView、UIViewController等都可以；
- 使用JXCategoryView分类控制器，几乎支持所有主流效果、高度自定义、可灵活扩展；
- 支持横竖屏切换；
- 支持点击状态栏滚动当前列表到顶部；
- 支持列表显示和消失的生命周期方法；
- isListHorizontalScrollEnabled属性控制列表是否可以左右滑动，默认YES；
- 支持`FDFullscreenPopGesture`等全屏手势兼容处理；

## 预览

| 效果  | 预览图 |
|-------|-------|
| **头图缩放** <br/>参考[ZoomViewController](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagerViewExample-OC/JXPagerViewExample-OC/Example/Zoom/ZoomViewController.m)类 | ![Zoom](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/Zoom.gif) | 
| **主页下拉刷新&列表上拉加载更多** <br/>参考[RefreshViewController](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagerViewExample-OC/JXPagerViewExample-OC/Example/Refresh/RefreshViewController.m)类 | ![Refresh](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/Refresh.gif) |
| **列表下拉刷新** <br/>参考[ListRefreshViewController](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagerViewExample-OC/JXPagerViewExample-OC/Example/Refresh/ListRefreshViewController.m)类 | ![Refresh](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/ListRefresh.gif) |
| **悬浮sectionHeader位置调整**  | ![Refresh](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/PinSectionHeaderPosition.gif) |
| **导航栏隐藏** <br/> 参考[NaviBarHiddenViewController](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagerViewExample-OC/JXPagerViewExample-OC/Example/NavigationBarHidden/NaviBarHiddenViewController.m)类 | ![Refresh](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/NaviHidden.gif) |
| **CollectionView列表示例**<br/>参考[CollectionViewViewController.swift](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Example/CollectionView/CollectionViewViewController.swift)类 <br/> 只有swift的demo工程有该示例 | ![Refresh](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/CollectionViewList.gif) |
| **HeaderView更新高度示例**<br/> 参考[HeightChangeAnimationViewController.swift](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Example/HeightChange/HeightChangeAnimationViewController.swift)类 <br/> 只有swift demo工程才有该示例 | ![Refresh](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/HeaderViewHeightChange.gif) |
| **PagingView嵌套CategoryView** <br/> 参考[NestViewController](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagerViewExample-OC/JXPagerViewExample-OC/Example/Nest/NestViewController.m)类 <br/> 只有 **OC!OC!OC!** 的demo工程才有该示例 <br/> 操作比较特殊，如果需要此效果，<br/> 请认真参考源码，有问题多试试 <br/> 参考NestViewController.h类 | ![Nest](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/Nest.gif) |
| **CategoryView嵌套PagingView** <br/> 参考[NestViewController.swift](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Example/CategoryNestPaging/NestViewController.swift)类 <br/> 只有 **Swift!Swift!Swift!** 的demo工程才有该示例 <br/> 操作比较特殊，如果需要此效果，<br/> 请认真参考源码，有问题多试试 <br/> 参考NestViewController.swift类 | ![Nest](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/CategoryNestPaging.gif) |
| **点击状态栏**  | ![Zoom](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/StatusBarClicked.gif) | 
| **横竖屏旋转**  | ![Zoom](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/ScreenRotate.gif) | 
| **JXPageListView**<br/> 顶部需要自定义cell的场景，类似于电商APP首页，滑动到列表最底部才是分类控制器 <br/> 该效果是另一个库，点击查看[JXPageListView](https://github.com/pujiaxin33/JXPageListView) <br/> 该效果是另一个库，点击查看[JXPageListView](https://github.com/pujiaxin33/JXPageListView) <br/> 该效果是另一个库，点击查看[JXPageListView](https://github.com/pujiaxin33/JXPageListView) | ![list](https://github.com/pujiaxin33/JXPageListView/blob/master/JXPageListView/Gif/headerLoading.gif) |

## 安装

### 手动

**Swift版本：** Clone代码，拖入JXPagingView-Swift文件夹，使用`JXPagingView`类；

**OC版本：** Clone代码，拖入JXPagerView文件夹，使用`JXPagerView`类；

### CocoaPods

- **Swift版本**

支持swift版本：5.0+

```ruby
target '<Your Target Name>' do
    pod 'JXPagingView/Paging'
end
```

- **OC版本**
```ruby
target '<Your Target Name>' do
    pod 'JXPagingView/Pager'
end
```

Swift与OC的仓库地址不一样，请注意选择！

先`pod repo update`然后再`pod install`


## 使用

swift版本使用类似，只是类名及相关API更改为`JXPagingView`，具体细节请查看Swfit工程。

### 1、初始化`JXCategoryTitleView`和`JXPagerView`

```Objective-C
self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:frame];
//配置categoryView，细节参考源码

self.pagerView = [[JXPagerView alloc] initWithDelegate:self];
[self.view addSubview:self.pagerView];

//关联contentScrollView，这样列表就可以和categoryView联动了。
self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
```

### 2、实现`JXPagerViewDelegate`协议

```Objective-C
/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return JXTableHeaderViewHeight;
}

/**
 返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}


/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return JXheightForHeaderInSection;
}


/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

/**
 返回列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.titles.count;
}

/**
 根据index初始化一个对应列表实例。注意：一定要是新生成的实例！！！
 只要遵循JXPagerViewListViewDelegate即可，无论你返回的是UIView还是UIViewController都可以。
 */
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    TestListBaseView *listView = [[TestListBaseView alloc] init];
    if (index == 0) {
        listView.dataSource = @[@"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪"...].mutableCopy;
    }else if (index == 1) {
        listView.dataSource = @[@"吃烤肉", @"吃鸡腿肉", @"吃牛肉", @"各种肉"].mutableCopy;
    }else {
        listView.dataSource = @[@"【剑士】罗罗诺亚·索隆", @"【航海士】娜美", @"【狙击手】乌索普"...].mutableCopy;
    }
    [listView beginFirstRefresh];
    return listView;
}
```

### 3、实现`JXPagerViewListViewDelegate`协议

列表可以是任意类，UIView、UIViewController等等都可以，只要实现了`JXPagerViewListViewDelegate`协议就行。

⚠️⚠️⚠️一定要保证`scrollCallback`的正确回调，许多朋友都容易疏忽这一点，导致异常，务必重点注意！

下面的使用代码参考的是`TestListBaseView`类

```Objective-C
/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。
 */
- (UIView *)listView {
    return self;
}

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
 */
- (UIScrollView *)listScrollView {
    return self.tableView;
}


/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}
```

### 4、列表回调处理

`TestListBaseView`在其`tableView`的滚动回调中，通过调用上面持有的scrollCallback，把列表的滚动事件回调给JXPagerView内部。
```Objective-C
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}
```

## 实现原理

[实现原理](https://github.com/pujiaxin33/JXPagingView/blob/master/Document/JXPagingView%E5%8E%9F%E7%90%86.md)

## 特殊说明

### JXCategoryView
悬浮的HeaderView，用的是我写的：[JXCategoryView](https://github.com/pujiaxin33/JXCategoryView) 几乎实现了所有主流效果，而且非常容易自定义扩展，强烈推荐阅读。

### 头图缩放说明
头图缩放原理，参考这个库：[JXTableViewZoomHeaderImageView](https://github.com/pujiaxin33/JXTableViewZoomHeaderImageView)

### 列表下拉刷新说明

需要使用`JXPagerListRefreshView`类（是`JXPagerView`的子类）

### 关于下方列表视图的代理方法`- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath`有时候需要点击两次才回调

出现步骤：当手指放在下方列表视图往下拉，直到TableHeaderView完全显示。

原因：经过上面的步骤之后，手指已经离开屏幕且列表视图已经完全静止，UIScrollView的isDragging属性却依然是true。就导致了后续的第一次点击，让系统认为当前UIScrollView依然在滚动，该点击就让UIScrollView停止下来，没有继续转发给UITableView，就没有转化成didSelectRow事件。

解决方案：经过N种尝试之后，还是没有回避掉系统的`isDragging`异常为true的bug。大家可以在自定义cell最下方放置一个与cell同大小的button，把button的touchUpInside事件当做`didSelectRow`的回调。因为UIButton在响应链中的优先级要高于UIGestureRecognizer。

代码：请参考`TestTableViewCell`类的配置。

### 指定默认选中index

默认显示index=2的列表，代码如下：
```
self.pagerView.defaultSelectedIndex = 2;
self.categoryView.defaultSelectedIndex = 2;
```

### 顶部轮播图手势处理

如果TableHeaderView添加了轮播图，获取其他可以横向滚动的UIScrollView。如果不处理，就会出现左右滚动轮播图的时候又可以触发整个页面的上下滚动。为了规避该问题，请参考示例仓库中`BannerViewController`类的处理方法。即可同一时间只允许左右滚动或者上下滚动。

### 关于JXCategoryView点击item之后的切换处理

如果要完美配合列表的懒加载机制，务必参考demo添加下面的代码：
```Objective-C
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickedItemContentScrollViewTransitionToIndex:(NSInteger)index {
    //请务必实现该方法
    //因为底层触发列表加载是在代理方法：`- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath`回调里面
    //所以，如果当前有5个item，当前在第1个，用于点击了第5个。categoryView默认是通过设置contentOffset.x滚动到指定的位置，这个时候有个问题，就会触发中间2、3、4的cellForItemAtIndexPath方法。
    //如此一来就丧失了延迟加载的功能
    //所以，如果你想规避这样的情况发生，那么务必按照这里的方法处理滚动。
    [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    //如果你想相邻的两个item切换时，通过有动画滚动实现。未相邻的两个item直接切换，可以用下面这段代码
    /*
    NSInteger diffIndex = labs(categoryView.selectedIndex - index);
     if (diffIndex > 1) {
         [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
     }else {
         [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
     }
     */
}
```

### 关于列表用UIViewController封装且要支持横竖屏的tips

在列表UIViewController类里面一定要加上下面这段代码：(不要问我为什么，我也不知道，谁知道系统内部是怎么操作的，反正加上就没毛病了)
```
- (void)loadView {
    self.view = [[UIView alloc] init];
}
```

### `FDFullscreenPopGesture`等全屏手势兼容处理

[全屏手势兼容处理文档，点击查看 ❗️❗️❗️](https://github.com/pujiaxin33/JXPagingView/blob/master/Document/%E5%85%A8%E5%B1%8F%E6%89%8B%E5%8A%BF%E5%A4%84%E7%90%86.md)


## 迁移指南
- 0.0.9版本将下面两个API的返回值修改为了NSUInteger(swift版本为Int)，之前版本是CGFloat，升级为0.0.9及以上的时候，记得修改一下使用地方的返回值类型，不然会引起crash。
  - `- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView`
  - `- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView`
- 1.0.0版本：
  删除代理方法`- (NSArray <id<JXPagerViewListViewDelegate>> *)listViewsInPagerView:(JXPagerView *)pagerView;`，请参考示例使用下面两个代理方法:
  - `- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView;`
  - `- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index;`
    

## 补充

有不明白的地方，建议多看下源码。再有疑问的，欢迎提Issue交流🤝


