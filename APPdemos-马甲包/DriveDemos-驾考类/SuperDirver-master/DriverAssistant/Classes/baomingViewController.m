//
//  baomingViewController.m
//  SuperDriver
//
//  Created by 王俊钢 on 2017/2/22.
//  Copyright © 2017年 C. All rights reserved.
//

#import "baomingViewController.h"
#import "SDCycleScrollView.h"
#import "jiaolianViewController.h"
#import "baoViewController.h"
@interface baomingViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic,strong) UITableView *baomingtableView;
@property (nonatomic,strong) SDCycleScrollView *cycleview;
@property (strong,nonatomic) NSArray *netImages;  //网络图片
@property (nonatomic,strong) NSArray *baomingarr;
@end
static NSString *baomingidentfid = @"baomingidentfid";
@implementation baomingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报名须知";
    self.view.backgroundColor = [UIColor orangeColor];
    [self ScrollNetWorkImages];
    
    [self.view addSubview:self.baomingtableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - getters

-(UITableView *)baomingtableView
{
    if(!_baomingtableView)
    {
        _baomingtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStyleGrouped];
        _baomingtableView.dataSource = self;
        _baomingtableView.delegate = self;
        _baomingtableView.tableHeaderView = self.cycleview;

    }
    return _baomingtableView;
}
/**
 *  懒加载网络图片数据
 */

-(NSArray *)netImages{
    
    if (!_netImages) {
        _netImages = @[
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487768742&di=8d2bca0811694f185d7b69b2acbf3983&imgtype=jpg&er=1&src=http%3A%2F%2Fwww.jiakaotuan.com%2Fimages%2Fhelpcenter%2Fmedia8-pic.png",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487174061522&di=242c14d0924449ca057546c15e94fb0b&imgtype=0&src=http%3A%2F%2Fwww.gjjx.com.cn%2Fsites%2Fdefault%2Ffiles%2Fupload%2F201608%2F201608241402332781.png",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487174122834&di=0ebeb1f04e8bf6b3a381f411d5e12334&imgtype=0&src=http%3A%2F%2Fwww1.pconline.com.cn%2Fdownload%2Fimages%2Fsoft%2Ftpyzt1%2F201585154117.jpg"
                       ];
    }
    return _netImages;
}

/**
 *  轮播网络图片
 */

-(void)ScrollNetWorkImages{
    
    /** 测试本地图片数据*/
    CGRect rect = CGRectMake(0,0, DEVICE_WIDTH, 200*HEIGHT_SCALE);
    self.cycleview = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"PlacehoderImage.png"]];
    
    //设置网络图片数组
    self.cycleview.imageURLStringsGroup = self.netImages;
    
    //设置图片视图显示类型
    self.cycleview.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    //设置轮播视图的分页控件的显示
    self.cycleview.showPageControl = YES;
    
    //设置轮播视图分也控件的位置
    self.cycleview.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    //当前分页控件小圆标图片
    self.cycleview.pageDotImage = [UIImage imageNamed:@"pageCon.png"];
    
    //其他分页控件小圆标图片
    self.cycleview.currentPageDotImage = [UIImage imageNamed:@"pageConSel.png"];
    
}


-(NSArray *)baomingarr
{
    if(!_baomingarr)
    {
        _baomingarr = @[@"电话咨询",@"报名学车",@"班车服务",@"教练信息"];
        
    }
    return _baomingarr;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.baomingarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baomingidentfid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baomingidentfid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.baomingarr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            NSLog(@"电话咨询");
            [self indexclick0];
            break;
        case 1:
            NSLog(@"报名学车");
            [self indexclick1];
            break;
        case 2:
            NSLog(@"班车服务");
            [self indexclick2];
            break;
        case 3:
            NSLog(@"教练信息");
            [self indexclick3];
            break;
        default:
            break;
    }
}

-(void)indexclick0
{
    UIAlertController *alertcoltrol = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要拨打咨询电话吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcoltrol addAction:action1];
    [alertcoltrol addAction:action2];
    [self presentViewController:alertcoltrol animated:YES completion:nil];

}

-(void)indexclick1
{
    baoViewController *baovc = [[baoViewController alloc] init];
    [self.navigationController pushViewController:baovc animated:YES];
}

-(void)indexclick2
{

}

-(void)indexclick3
{
    jiaolianViewController *jiaolianvc = [[jiaolianViewController alloc] init];
    [self.navigationController pushViewController:jiaolianvc animated:YES];
}
@end
