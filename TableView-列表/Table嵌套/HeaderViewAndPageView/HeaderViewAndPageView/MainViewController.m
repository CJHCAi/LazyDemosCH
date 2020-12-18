//
//  MainViewController.m
//  CanPlay
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 ZJW. All rights reserved.
//

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#import "MainViewController.h"
#import "ThirdViewCollectionViewController.h"
#import "SecondViewTableViewController.h"
#import "MainTouchTableTableView.h"
#import "MYSegmentView.h"
#import "NavgationBar.h"
#import "ZJWCollectionView.h"
#import "AppDelegate.h"

static CGFloat const headViewHeight = 300;

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NavgationBar *view_bar;
    ZJWCollectionView *collection;
}
@property (nonatomic, strong) MainTouchTableTableView * mainTableView;
@property (nonatomic, strong) MYSegmentView * RCSegView;
@property (nonatomic, strong) UIImageView *headImageView;//头部
@property (nonatomic, strong) UIImageView *photos;
@property (nonatomic, strong) UIView *sencondeView;
@property (nonatomic, strong) UILabel *countentLabel;
@property (nonatomic, strong) SecondViewTableViewController *Second;
@property (nonatomic, strong) ThirdViewCollectionViewController * Third;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@end

@implementation MainViewController
@synthesize mainTableView;
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationBa];
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.mainTableView];
    [self.view bringSubviewToFront:view_bar];
    [self.mainTableView addSubview:self.headImageView];
    self.mainTableView.tableHeaderView =self.sencondeView;
    /* 
     *接收离开顶部的通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];

}

-(void)acceptMsg : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */
    
    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            //到达顶部，置初始y向下偏移20像素
           _RCSegView.frame = CGRectMake(0, 20, Main_Screen_Width, Main_Screen_Height) ;
            _canScroll = NO;
            
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
                }
        }
    }
#pragma mark --******处理头视图
    if(yOffset < -headViewHeight/2) {
        CGRect f = self.headImageView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        self.headImageView.frame= f;
    }

#pragma mark --******上拉导航渐变
    CGFloat alpha = (offsetY + 128)/100.0f;
    if(offsetY < -64) {
        [view_bar setHidden:YES];
    }
   if(offsetY > -64 ){
        [view_bar setHidden:NO];
        view_bar.backgroundColor = [UIColor colorWithRed:0.3 green:0.4 blue:0.5 alpha:alpha];
    }
    if (offsetY >64) {
        view_bar.frame = CGRectMake(0, 0, Main_Screen_Width, 64-(offsetY-64));
        view_bar.title_label.frame = CGRectMake(0, 20-(offsetY-64), Main_Screen_Width, 40-(offsetY-64));
        if (view_bar.frame.size.height <20) {
            [view_bar setHidden:YES];
        }
    }
    if (offsetY <130) {
        _RCSegView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);

    }

}

-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]init];
        _headImageView.backgroundColor = [UIColor greenColor];
        _headImageView.image =[UIImage imageNamed:@"headerImage" ];
        _headImageView.frame=CGRectMake(0, -headViewHeight/2 ,Main_Screen_Width,headViewHeight/2);
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}
-(UIView *)sencondeView
{
    if (_sencondeView == nil)
    {
        _sencondeView= [[UIView alloc]init];
        _sencondeView.backgroundColor = [UIColor whiteColor];
        _sencondeView.frame=CGRectMake(0, -headViewHeight/2 ,Main_Screen_Width,headViewHeight/2+10);
        _sencondeView.userInteractionEnabled = YES;
#pragma mark --*****初始化footerview上的collection
  
        collection = [ZJWCollectionView new];
        [collection createCollectionWithItms:6];
        __weak MainViewController *weakSelf = self;
        collection.itmsBlock = ^(ZJWCollectionView *viewList,NSInteger index){
            NSLog(@"%ld",index+1);
        };
        [_sencondeView addSubview:collection.colleciont];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, headViewHeight/2, Main_Screen_Width, 10)];
        label.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [_sencondeView addSubview:label];
    }
    return _sencondeView;
}

-(UITableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight/2,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
    }
    return mainTableView;
}

#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加pageView
    [cell.contentView addSubview:self.setPageViewControllers];
    return cell;
}

/* 
 * 这里可以任意替换你喜欢的pageView
 */
-(UIView *)setPageViewControllers
{
    if (!_RCSegView) {
       self.Second = [[SecondViewTableViewController alloc]init];
       self.Third=[[ThirdViewCollectionViewController alloc]init];
       
        NSArray *controllers=@[self.Second,self.Third];
        
        NSArray *titleArray =@[@"轻松国内游",@"奢侈国外游"];
       
        MYSegmentView * rcs=[[MYSegmentView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) controllers:controllers titleArray:titleArray ParentController:self lineWidth:Main_Screen_Width/3 lineHeight:3. titleHeiht:41];
        
        _RCSegView = rcs;
    }
    return _RCSegView;
}
//创建导航
-(UIView*)NavigationBa
{
    view_bar =[[NavgationBar alloc]init];
    view_bar .frame=CGRectMake(0, 0,Main_Screen_Width, 64);
    view_bar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: view_bar];
//    [self.mainTableView bringSubviewToFront:view_bar];
    [view_bar creatNavgationgBarWithTextColor:[UIColor whiteColor] withTitleText:@"发现"];
    [view_bar setHidden:YES];
    return view_bar;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"leaveTop" object:nil];
}
@end
