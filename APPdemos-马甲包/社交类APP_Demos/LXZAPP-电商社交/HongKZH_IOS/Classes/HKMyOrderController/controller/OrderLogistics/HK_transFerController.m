//
//  HK_transFerController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_transFerController.h"
#import "HK_BaseRequest.h"
#import "HK_transHeaderView.h"
#import "HKMyDeliveryCell.h"

@interface HK_transFerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, strong)HK_transHeaderView *trHeaderView;

@end

@implementation HK_transFerController



#pragma  mark 根据类型 选择是投诉还是举证
-(void)initNav {
    self.title =@"物流";
    [self setShowCustomerLeftItem:YES];
}
-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources=[[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(HK_transHeaderView *)trHeaderView {
    if (!_trHeaderView) {
        _trHeaderView =[[HK_transHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,90)];
        [_trHeaderView setDataWithOrderNumber:self.transModel.data.orderNumber andCouriesName:self.transModel.data.courier];
    }
    return _trHeaderView;
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark 获取物流信息
-(void)getlogistInfoMation {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:self.transModel.data.courier forKey:@"courier"];
    [params setValue:self.transModel.data.courierNumber forKey:@"courierNumber"];
    [HK_BaseRequest buildPostRequest:get_logisticsInformation body:params success:^(id  _Nullable responseObject) {
        
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self.view addSubview:self.listTableView];
    //获取物流信息
   // [self getlogistInfoMation];
    NSArray *arr =@[@"河北石家庄市高新开发区公司 已发出,下一站石家庄转运中心",@"河北省石家庄市桥东区北国商场",@"卖家已发货,包裹等待揽收"];
//    @interface  : NSObject
//
//    @property (nonatomic, copy) NSString *content;
//
//    @property (nonatomic, copy) NSString *createDate;
//
//    @property (nonatomic, assign) NSInteger lineStyle; //1--首个 2--中间 3--最后一个
   
    for (int i=0; i< arr.count; i++) {
        HKMyDeliveryLogs * model =[[HKMyDeliveryLogs alloc] init];
        model.content = arr[i];
        model.createDate =@"2018.09:12";
        model.lineStyle =i +1;
        [self.dataSources addObject:model];
        [self.listTableView reloadData];
    }
}
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-36-46) style:UITableViewStyleGrouped];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        //_listTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
       
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerClass:[HKMyDeliveryCell class] forCellReuseIdentifier:@"orderLogist"];
        
        _listTableView.tableHeaderView = self.trHeaderView;
    }
    return _listTableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.dataSources.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyDeliveryCell * cell =[tableView dequeueReusableCellWithIdentifier:@"orderLogist" forIndexPath:indexPath];
    cell.timeLineFlag.backgroundColor =[UIColor colorFromHexString:@"f76654"];
    if (indexPath.row) {
        cell.contentLabel.textColor =[UIColor colorFromHexString:@"999999"];
        cell.createDateLabel.textColor =[UIColor colorFromHexString:@"999999"];
        cell.contentLabel.font =PingFangSCRegular14;
        cell.createDateLabel.font =PingFangSCRegular12;
    }else {
        cell.contentLabel.textColor =[UIColor colorFromHexString:@"333333"];
        cell.contentLabel.font =PingFangSCRegular14;
        cell.createDateLabel.textColor =[UIColor colorFromHexString:@"999999"];
        cell.createDateLabel.font =PingFangSCRegular12;
    }
    cell.data = self.dataSources[indexPath.row];
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString * content =self.dataSources[indexPath.row];
//
//    HKMyDeliveryCell *cell =(HKMyDeliveryCell *)[tableView cellForRowAtIndexPath:indexPath];
//
//    CGRect rectContent =[content boundingRectWithSize:CGSizeMake(cell.contentLabel.frame.size.width,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PingFangSCRegular14,NSForegroundColorAttributeName:[UIColor colorFromHexString:@"333333"]} context:nil];
//
//    cell.contentLabel.frame = CGRectMake(cell.contentLabel.frame.origin.x,cell.contentLabel.frame.origin.y,cell.contentLabel.frame.size.width,rectContent.size.height);
//    cell.createDateLabel.frame =CGRectMake(cell.createDateLabel.frame.origin.x,CGRectGetMaxY(cell.contentLabel.frame)+10,cell.createDateLabel.frame.size.width,cell.createDateLabel.frame.size.height);
//
//
//
//
////    make.left.equalTo(self.contentLabel);
////    make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
////    make.height.mas_equalTo(12);

    return 70;
    
}
@end
