//
//  YXWChoseViewController.m
//  StarAlarm
//
//  Created by dllo on 16/4/6.
//  Copyright © 2016年 YXW. All rights reserved.
//
#define cellHeight 250

#import "YXWChoseViewController.h"
#import "YXWBaseTabelView.h"
#import "YXWCalmCosmosViewController.h"
#import "YXWRocketViewController.h"
#import "YXWAlarmModel.h"
#import "YXWTaskTableViewCell.h"
#import "YXWSmileViewController.h"
#import "XFZ_Count_ViewController.h"

@interface YXWChoseViewController ()<UITableViewDelegate,UITableViewDataSource,YXWTaskTableViewCellDelegate>

@property (nonatomic, strong) YXWBaseTabelView *tableView;
@property (nonatomic, strong) NSMutableArray *alarm;

@property (nonatomic, strong) YXWAlarmModel *alarmModel;
@property (nonatomic, strong) TAlertView *alertView;

@end

@implementation YXWChoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //按钮左侧返回
    
    
    [self valuesModel];
    [self creatTabelView];
    [self creatNav];
}

- (void)creatNav {
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
}

#pragma mark - 导航左侧返回按钮
-(void)leftButtonAction:(UIBarButtonItem *)barItem {
    
    [self.navigationController popViewControllerAnimated:YES];
                                                 
}

#pragma mark - 取model
-(void)valuesModel {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AlarmWay" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *array = [dic objectForKey:@"data"];
    self.alarm = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in array) {
        self.alarmModel = [[YXWAlarmModel alloc] initWithDataSource:dic];
        [self.alarm addObject:self.alarmModel];
    }
}


#pragma mark - 创建tableview
- (void)creatTabelView {
    self.tableView = [[YXWBaseTabelView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXWTaskTableViewCell class] forCellReuseIdentifier:@"1"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alarm.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXWTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    cell.delegate = self;
    
    cell.alermModel = self.alarm[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    YXWTaskTableViewCell *taskCell = (YXWTaskTableViewCell *)cell;
    
    [taskCell cellOffset];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSArray<YXWTaskTableViewCell *> *array =[self.tableView visibleCells];
    [array enumerateObjectsUsingBlock:^(YXWTaskTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cellOffset];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXWAlarmModel *alarmModel = self.alarm[indexPath.row];
    
        self.alertView = [[TAlertView alloc] initWithTitle:@"" andMessage:[NSString stringWithFormat:@"已选择%@", alarmModel.title]];
        [self.alertView show];
    
    self.block(alarmModel);

}



- (void)pushVC:(YXWAlarmModel *)model {
    if ([model.title isEqualToString:@"平静的宇宙"]) {
        YXWCalmCosmosViewController *calmVC = [[YXWCalmCosmosViewController alloc] init];
        [self.navigationController pushViewController:calmVC animated:YES];
        calmVC.alarmModel = model;
    } else if ([model.title isEqualToString:@"宇航员的微笑"]) {
        YXWSmileViewController *smileVC = [[YXWSmileViewController alloc] init];
        smileVC.alarmModel = model;
        [self.navigationController pushViewController:smileVC animated:YES];
        
    }
    if ([model.title isEqualToString:@"质量计算器"]) {
        XFZ_Count_ViewController *count = [[XFZ_Count_ViewController alloc] init];
        [self.navigationController pushViewController:count animated:YES];
        count.alarmModel = model;
    }
    if ([model.title isEqualToString:@"火箭发射器"]) {
        YXWRocketViewController *rocketVC = [[YXWRocketViewController alloc] init];
        [self.navigationController pushViewController:rocketVC animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
