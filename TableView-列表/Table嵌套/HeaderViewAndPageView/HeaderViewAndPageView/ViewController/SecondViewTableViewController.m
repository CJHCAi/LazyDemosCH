//
//  SecondViewTableViewController.m
//  CanPlay
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 ZJW. All rights reserved.
//
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#import "SecondViewTableViewController.h"
#import "TitleScrollView.h"
#import "RecommendeTableViewCell.h"
@interface SecondViewTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSArray *imageArrs;
@property(nonatomic,strong)NSArray *paperArrs;
@property(nonatomic,strong)NSArray *priceArrs;
@property(nonatomic,strong)NSArray *soldArrs;
@end

@implementation SecondViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,Main_Screen_Width , Main_Screen_Height-64)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.imageArrs = @[@"imageshow_1",@"imageshow_2",@"imageshow_3",@"imageshow_4",@"imageshow_5",@"imageshow_6",@"imageshow_7",@"imageshow_8",@"imageshow_9",@"imageshow_10",];
    self.paperArrs = @[@" 海利公館",@" 香港丽思卡尔顿酒店",@" 香港半岛酒店",@" 港岛香格里拉大酒店",@" 香港四季酒店",@" 香港文华东方酒店",@" 香港置地文华东方酒店",@" 香港皇悦卓越酒店",@" 香港遨凯酒店",@" 香港迪士尼乐园酒店",];
    self.priceArrs = @[@" ¥2488",@" ¥1308",@" ¥2269",@" ¥1688",@" ¥1358",@" ¥1432",@" ¥3199",@" ¥1258",@" ¥2229",@" ¥4396"];
    self.soldArrs =  @[@"58",@"1023",@"973",@"213",@"233",@"458",@"873",@"112",@"102",@"364",];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendeTableViewCell *cell = [RecommendeTableViewCell cellWithTableView:tableView];
    cell.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageArrs[indexPath.row]]];
    cell.price.text = [NSString stringWithFormat:@"%@",_priceArrs[indexPath.row]];
    cell.sold.text = [NSString stringWithFormat:@"已售出 %@",_soldArrs[indexPath.row]];
    cell.name.text = [NSString stringWithFormat:@"%@",_paperArrs[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"第%ld组第%ld行",(long)indexPath.section+1,(long)indexPath.row+1);


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
@end
