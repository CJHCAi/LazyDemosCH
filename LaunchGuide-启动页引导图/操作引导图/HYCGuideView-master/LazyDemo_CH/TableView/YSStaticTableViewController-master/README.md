# YSStaticTableViewController
只需一个数组即可快速搭建个人中心以及设置界面

如下图：

![](http://ozhr26838.bkt.clouddn.com/hexo/statictablevc.gif)

* 支持自定义cell
* 支持网络请求+本地数据

#### 引用
方法1. CocoaPods
```
pod 'YSStaticTableViewController'
```
方法2. 直接拖入项目中

简单讲解下使用说明吧，其实看Demo就够了...
#### 普通使用
1. 新建VC继承 YSStaticTableViewController
2. 准备数据
```
__weak typeof(self) weakSelf = self;
    YSStaticDefaultModel *model0 = [[YSStaticDefaultModel alloc] init];
    model0.title = @"朋友圈";
    model0.titleImageName = @"ff_IconShowAlbum";
    model0.indicatorImageName = @"avatar";

    YSStaticSectionModel *sm0 = [YSStaticSectionModel sectionWithItemArray:@[model0]];

    YSStaticDefaultModel *model1 = [[YSStaticDefaultModel alloc] init];
    model1.title = @"扫一扫";
    model1.titleImageName = @"ff_IconQRCode";

    YSStaticDefaultModel *model2 = [[YSStaticDefaultModel alloc] init];
    model2.title = @"摇一摇";
    model2.titleImageName = @"ff_IconShake";

    YSStaticSectionModel *sm1 = [YSStaticSectionModel sectionWithItemArray:@[model1, model2]];

    YSStaticDefaultModel *model3 = [[YSStaticDefaultModel alloc] init];
    model3.title = @"附近的人";
    model3.titleImageName = @"ff_IconLocationService";

    YSStaticDefaultModel *model4 = [[YSStaticDefaultModel alloc] init];
    model4.title = @"漂流瓶";
    model4.titleImageName = @"ff_IconBottle";

    YSStaticSectionModel *sm2 = [YSStaticSectionModel sectionWithItemArray:@[model3, model4]];

    YSStaticDefaultModel *model5 = [[YSStaticDefaultModel alloc] init];
    model5.title = @"购物";
    model5.titleImageName = @"CreditCard_ShoppingBag";

    YSStaticDefaultModel *model6 = [[YSStaticDefaultModel alloc] init];
    model6.title = @"游戏";
    model6.titleImageName = @"MoreGame";
    model6.indicatorImageName = @"wzry";
    model6.indicatorTitle = @"一起来玩王者荣耀呀!";

    YSStaticDefaultModel *model7 = [[YSStaticDefaultModel alloc] init];
    model7.title = @"游戏2";
    model7.titleImageName = @"MoreGame";
    model7.indicatorImageName = @"wzry";
    model7.indicatorTitle = @"一起来玩王者荣耀呀!";
    model7.isIndicatorImageLeft = YES;

    YSStaticSectionModel *sm3 = [YSStaticSectionModel sectionWithItemArray:@[model5, model6, model7]];

    YSStaticDefaultModel *model8 = [[YSStaticDefaultModel alloc] init];
    model8.title = @"我";
    model8.titleImageName = @"tabbar_meHL";
    model8.indicatorTitle = @"微信的个人中心界面";
    model8.indicatorTitleColor = [UIColor redColor];
    model8.didSelectCellBlock = ^(YSStaticCellModel *cellModel, NSIndexPath *indexPath) {
        __strong typeof(self) strongSelf = weakSelf;
        WXUserCenterViewController *userCenter = [[WXUserCenterViewController alloc] init];
        [strongSelf.navigationController pushViewController:userCenter animated:YES];
    };

    YSStaticSectionModel *sm4 = [YSStaticSectionModel sectionWithItemArray:@[model8]];
```
2. 赋值给 sectionModelArray
```
self.sectionModelArray = @[sm0, sm1, sm2, sm3, sm4];
```
OK，界面搭好了

#### 自定义Cell使用
1. 新建一个 xxxCell 继承自 YSStaticTableViewCell （如Demo中 YSAvatorCell）
   - 重写`- (void)configureTableViewCellWithModel:(__kindof YSStaticCellModel *)cellModel`
   - 重写`@property (nonatomic, readwrite, strong) YSAvatarModel *cellModel;` 将cell里面的cellModel代替 YSStaticTableViewCell 里面的cellModel
   - `@dynamic cellModel;` cellModel的set get 方法在子类生成使用
2. 新建一个 xxxModel 继承自 YSStaticCellModel （如Demo中 YSAvatarModel）
   - 重写init方法，并配置初始化数据，不写也行，写了下面这个步骤就不需要了
   - 使用的时候,新建一个Model vm0 并配置好下面这些，其余信息自行配置
```
vm0.cellIdentifier = @"avatarCell";
// 请使用这种方法设置classname，不要使用字符串，防止类没加载
// 导致调用 NSClassFromstring 时 为 nil 报错
vm0.cellClassName = NSStringFromClass([YSAvatorCell class]);
//    vm0.cellClassName = @"YSAvatorCell";
vm0.cellHeight = 80;
vm0.cellType = YSStaticCellTypeCustom;
```
3. 然后其他操作如普通使用

#### 随便说说
0. 有兴趣请`star`
1. 项目刚写，可能存在问题，如果有任何问题，请提 `issue`
2. 如果有好的意见也请提 `issue`
