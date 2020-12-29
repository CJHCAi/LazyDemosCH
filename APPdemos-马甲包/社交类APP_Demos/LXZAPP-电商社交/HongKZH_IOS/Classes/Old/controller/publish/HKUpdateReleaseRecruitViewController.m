//
//  HKUpdateReleaseRecruitViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateReleaseRecruitViewController.h"
#import "HKChooseChannelTableViewCell.h"
#import "HKRecruitIntroductionTableViewCell.h"
#import "HKCompanyProfileTableViewCell.h"
#import "HKPositionTableViewCell.h"
#import "HKEnterpriseInfoViewController.h"
#import "HKPositionManageViewController.h"
#import "HKVideoRecordTool.h"
#import "HKChangeVideoCell.h"
#import "HK_RecruitEnterpriseInfoData.h"
#import "HKEditRecruitment.h"
#import "HK_RecruitTool.h"
@interface HKUpdateReleaseRecruitViewController ()<UITableViewDelegate, UITableViewDataSource,HKChangeVideoCellDelegate>
@property (nonatomic, copy) NSString *enterpriseId;
@property (nonatomic, strong) HKEditRecruitmentData * editRecruitmentData;
@property (nonatomic, strong) HK_RecruitEnterpriseInfoData *enterpriseInfoData;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, assign) NSInteger requestFlag;
@property (nonatomic, weak) HKRecruitIntroductionTableViewCell *introductionCell;
@property (nonatomic,strong) HKVideoRecordTool *tool;   //录制的工具类
@end

@implementation HKUpdateReleaseRecruitViewController

- (HKVideoRecordTool *)tool {
    if (!_tool) {
        _tool = [HKVideoRecordTool videoRecordWithDelegate:self];
    }
    return _tool;
}
- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.requestFlag == 2) {
        [self requstRecruitEnterpriseInfo];
    } else if (self.requestFlag == 3) {
        [self requstRecruitPosition];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//导航右侧按钮点击
- (void)nextStep {
    DLog(@"发布");
    BOOL hasFile = NO;
    //判断是否更换视频
    HKReleaseVideoParam *param =[HKReleaseVideoParam shareInstance];
    param.publishType = ENUM_PublishTypeEditResume;
    
    NSString *filePath = param.filePath;
    if (filePath && [filePath length] > 0) {
        hasFile = YES;
        //保存屏幕宽度
        [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenWidth] key:@"width"];
        //保存屏幕高度
        [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenHeight] key:@"high"];
    }
    //判断是否有新的图片附件
    if ([param.filePath length] > 0) {
        hasFile = YES;
    }
    if (!hasFile) { //修改简历没有文件
        [self requestUpdateReleaseRecruitment];
    } else {    //有文件调以前接口
        //数据验证
        [param validateDatapublishType:ENUM_PublishTypeEditRecruitment success:^{
            [self uploadData];
        } failure:^(NSString *tip) {
            [SVProgressHUD showInfoWithStatus:tip];
        }];
    }
}
#pragma mark 发布
- (void)uploadData {
    
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
//    [self Business_Request:BusinessRequestType_get_ReleaseRecruit dic:[param dataDict] cache:NO];
}

//-(void)Business_Request_State:(BusinessRequestType)type statusCode:(NSInteger)statusCode responseJsonObject:(id)jsonObj{
//    if (type == BusinessRequestType_get_ReleaseRecruit ||
//        type == BusinessRequestType_get_updateReleaseRecruit) {
//        if (jsonObj) {
//            NSString *code = [jsonObj objectForKey:@"code"];
//            if (code && [code integerValue] == 1) {
//                //失败
//                [SVProgressHUD showInfoWithStatus:[jsonObj objectForKey:@"msg"]];
//            } else if(code && [code integerValue] == 0){
//                //成功
//                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
//                [HKReleaseVideoParam clearParam];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        } else {
//            [SVProgressHUD showInfoWithStatus:@"网络错误"];
//        }
//    }
//}

#pragma mark 请求
//请求编辑招聘
-(void)requstEditRecruitment
{
    [HK_RecruitTool getEditRecruitmentSuccessBlock:^(HKEditRecruitment *recuit) {
        
        self.editRecruitmentData = recuit.data;
        self.enterpriseId = self.editRecruitmentData.enterpriseId;
      
    } fial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
    
}
//修改招聘
- (void)requestUpdateReleaseRecruitment {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
//    [self Business_Request:BusinessRequestType_get_updateReleaseRecruit dic:dic cache:NO];
}

//请求企业信息
-(void)requstRecruitEnterpriseInfo
{
    [HK_RecruitTool getRecruitSuccessBlock:^(HK_RecruitEnterpriseInfoData *infoData) {
        self.enterpriseInfoData =infoData;
       
        [self reloadData];
        
    } fial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
//请求职位列表
-(void)requstRecruitPosition
{
    [HK_RecruitTool getCurrentPositionListSuccessBlock:^(HK_RecriutPosition *infoData) {
        if (self.listData.count) {
        [self.listData removeAllObjects];
        }
        [self.listData addObjectsFromArray:infoData.data];
        [self reloadData];
        
    } fial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];

}
-(NSMutableArray *)listData {
    if (!_listData) {
        _listData =[[NSMutableArray alloc] init];
    }
    return _listData;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasNoBottomBar = YES;
    }
    return self;
}
//更新 UI
- (void)reloadData {
    if (self.requestFlag == 1) {
        [self.tableView reloadData];
        //更新招聘职位个数
        if ([self.listData count] > 0) {
            NSString *text = [NSString stringWithFormat:@"(%ld)",[self.listData count]];
            self.countLabel.text = text;
        }
    }
    if (self.requestFlag == 2) {
        //更新公司信息
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (self.requestFlag == 3) {
        //更新招聘职位个数
        if ([self.listData count] > 0) {
            NSString *text = [NSString stringWithFormat:@"(%ld)",[self.listData count]];
            self.countLabel.text = text;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:2];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑发布内容";
    self.requestFlag = 1;
    self.tableView.frame = CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight);
    [self.tableView registerNib:[UINib nibWithNibName:@"HKChangeVideoCell" bundle:nil] forCellReuseIdentifier:@"HKChangeVideoCell"];
    [HKReleaseVideoParam clearParam];
    [self requstEditRecruitment];
    [self requstRecruitEnterpriseInfo];
    
    [self requstRecruitPosition];
    
}

- (void)setUpUI {
    //只是为了重写父类方法
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return [self.listData count];
            break;
        default:
            return 0;
            break;
    }
}
-(void)changeVideoBlock{
    [self.tool toRecordView];
    [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypeEditRecruitment;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            //拍摄并更换视频
            HKChangeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKChangeVideoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.data = self.editRecruitmentData;
            cell.delegate = self;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *cellIdentifier = @"HKCompanyProfileTableViewCell";
            HKCompanyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKCompanyProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
           }
            cell.data = self.enterpriseInfoData;
            [cell layoutIfNeeded];
            return cell;
        }
            break;
        case 2:
        {
            static NSString *cellIdentifier = @"HKPositionTableViewCell";
            HKPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKPositionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            HK_positionData *data = [self.listData objectAtIndex:indexPath.row];
            [cell confiueCellWithModel:data];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}
#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 105.f;
            break;
        case 1:
            return UITableViewAutomaticDimension;
            break;
        case 2:
            return 32.f;
            break;
            
        default:
            return 0;
            break;
    }
}


//header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 55;
    } else if (section == 0) {
        return 10;
    } else {
        return 0.01;
    }
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        
        UIControl *control = [[UIControl alloc] init];
        [view addSubview:control];
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(51,51,51) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:14.f] text:@"在招职位" supperView:view];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(16);
            make.top.equalTo(view).offset(15);
        }];
        
        UILabel *countLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(153,153,153) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:14.f] text:@"" supperView:view];
        self.countLabel = countLabel;
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right);
            make.top.equalTo(titleLabel);
        }];
        
        UIImageView *arrowView = [HKComponentFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"nestchose"] supperView:view];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(-16);
            make.centerY.equalTo(titleLabel);
        }];
        
        UIView *line = [HKComponentFactory viewWithFrame:CGRectZero supperView:view];
        line.backgroundColor = RGB(226,226,226);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.top.equalTo(titleLabel.mas_bottom).offset(16);
            make.height.mas_equalTo(1);
        }];
        return view;
    } else if (section == 0) {
        return [UIView new];
    } else {
        return nil;
    }
}
#pragma mark 跳转到在招职位
- (void)controlClick {
    self.requestFlag = 3;
    HKPositionManageViewController *vc = [[HKPositionManageViewController alloc] init];
    vc.listData = self.listData;
    vc.enterpriseId = self.enterpriseId;
    [self.navigationController pushViewController:vc animated:YES];
}

//footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB(241, 241, 241);
    return view;
}

//footer 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

//cell 选中处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        case 1: //跳转到修改企业信息页面
        {
            self.requestFlag = 2;
            HKEnterpriseInfoViewController *vc = [[HKEnterpriseInfoViewController alloc] init];
            vc.enterpriseInfoData = self.enterpriseInfoData;
            vc.enterpriseId = self.enterpriseId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
}



@end
