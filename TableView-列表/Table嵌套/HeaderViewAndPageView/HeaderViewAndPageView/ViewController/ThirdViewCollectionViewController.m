//
//  ThirdViewCollectionViewController.m
//  CanPlay
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 ZJW. All rights reserved.
//
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
//单例AppDelegete
#define kAppDelegate [AppDelegate shareAppDelegate]

#import "ThirdViewCollectionViewController.h"
#import "MyCollectionViewCell.h"
#import "MYSegmentView.h"
#import "FourCollectionViewController.h"
@interface ThirdViewCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MYSegmentView * RCSegView;
@property(nonatomic ,strong)UITableView * myTableView;
@property (nonatomic,strong)FourCollectionViewController *collection;
@end
@implementation ThirdViewCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,Main_Screen_Width , Main_Screen_Height-64)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   [cell.contentView addSubview:self.setPageViewControllers];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger i;
    if (section ==0) {
        i =40;
    }else{
        i=0;
    }
    return i;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TitleScrollView *titleview = [[TitleScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    titleview.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    return titleview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height;
}
-(UIView *)setPageViewControllers
{
    if (!_RCSegView) {
         FourCollectionViewController *four=[[FourCollectionViewController alloc]init];
       NSArray *controllers=@[four];
       NSArray *titleArray =@[@""];

        MYSegmentView * rcs=[[MYSegmentView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) controllers:controllers titleArray:titleArray ParentController:self lineWidth:Main_Screen_Width/5 lineHeight:0.0001 titleHeiht:0.0001];

        _RCSegView = rcs;
    }
    return _RCSegView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)dealloc{
    
}
@end
