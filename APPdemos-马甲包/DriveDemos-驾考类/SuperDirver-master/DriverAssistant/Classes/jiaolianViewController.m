//
//  jiaolianViewController.m
//  SuperDirvers
//
//  Created by 王俊钢 on 2017/2/19.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "jiaolianViewController.h"
#import "jiaolianCell.h"
@interface jiaolianViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *jiaoliantableview;
@property (nonatomic,strong) NSArray *jiaolianimgarr;
@property (nonatomic,strong) NSArray *jiaoliannamearr;
@property (nonatomic,strong) NSArray *jiaolianmessagearr;
@end
static NSString *jiaolianidentfid = @"jiaolianidentfid";
@implementation jiaolianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self.view addSubview:self.jiaoliantableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.jiaoliantableview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
}


#pragma mark - getters


-(UITableView *)jiaoliantableview
{
    if(!_jiaoliantableview)
    {
        _jiaoliantableview = [[UITableView alloc] init];
        _jiaoliantableview.dataSource = self;
        _jiaoliantableview.delegate = self;
    }
    return _jiaoliantableview;
}


-(NSArray *)jiaolianimgarr
{
    if(!_jiaolianimgarr)
    {
        _jiaolianimgarr = @[@"http://www.ygjj.com/bookpic2/2012-07-19/new472128-20120719223926800045.jpg",@"http://v.114la.com/img/2014/12/16/v114la/movie/7/Ti28h0j014b.jpg",@"http://www.qqai.net/uploads/i_5_3638816665x1081999124_21.jpg",@"http://img3.imgtn.bdimg.com/it/u=1010896261,3694164435&fm=214&gp=0.jpg",@"http://a.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0206fd0bb37eca80125031e3a413bbeb/4d086e061d950a7bb21f15ec09d162d9f2d3c9f4.jpg"];
        
    }
    return _jiaolianimgarr;
}

-(NSArray *)jiaoliannamearr
{
    if(!_jiaoliannamearr)
    {
        _jiaoliannamearr = @[@"张教练",@"李教练",@"吴教练",@"孙教练",@"王教练"];
        
    }
    return _jiaoliannamearr;
}

-(NSArray *)jiaolianmessagearr
{
    if(!_jiaolianmessagearr)
    {
        _jiaolianmessagearr = @[@"驾校现场直招",@"学正在的技术",@"c1c2学院速成",@"管理正规",@"暑假班免费约车"];
        
    }
    return _jiaolianmessagearr;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jiaolianimgarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    jiaolianCell *cell = [tableView dequeueReusableCellWithIdentifier:jiaolianidentfid];
    if (!cell) {
        cell = [[jiaolianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jiaolianidentfid];
    }
    [cell.leftimg sd_setImageWithURL:[NSURL URLWithString:self.jiaolianimgarr[indexPath.row]]];
    cell.namelab.text = self.jiaoliannamearr[indexPath.row];
    cell.messagelab.text = self.jiaolianmessagearr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*HEIGHT_SCALE;
}
@end
