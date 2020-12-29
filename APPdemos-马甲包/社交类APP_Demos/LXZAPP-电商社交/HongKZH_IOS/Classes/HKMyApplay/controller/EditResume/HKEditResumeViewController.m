//
//  HKEditResumeViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditResumeViewController.h"
#import "HKResumeOpenwCell.h"
#import "HKResumeCompletionCell.h"
#import "HKChangeVideoCell.h"
#import "HKVideoRecordTool.h"
#import "HKUpdateResumeViewController.h"
#import "HKShieldCompanyViewController.h"
#import "HK_MyApplyTool.h"
@interface HKEditResumeViewController ()<HKChangeVideoCellDelegate>
@property (nonatomic,strong) HKVideoRecordTool *tool;   //录制的工具类
@property (nonatomic, assign, getter=isOpen) BOOL open;
@property (nonatomic, strong) NSString *complete;
@property (nonatomic, strong) HKEditResumeData *editResumeData;
@property (nonatomic, strong) NSMutableArray *pickImages;
@end

@implementation HKEditResumeViewController

- (HKVideoRecordTool *)tool {
    if (!_tool) {
        _tool = [HKVideoRecordTool videoRecordWithDelegate:self];
    }
    return _tool;
}

- (NSMutableArray *)pickImages {
    if(!_pickImages) {
        _pickImages = [NSMutableArray array];
    }
    return _pickImages;
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
    [self.tableView reloadData];
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
    if (param.photographyImages && [param.photographyImages count] > 0) {
        hasFile = YES;
    }
    if (self.isOpen) {
        [HKReleaseVideoParam setObject:@"1" key:@"isOpen"];
    } else {
        [HKReleaseVideoParam setObject:@"0" key:@"isOpen"];
    }
    if (!hasFile) {
        //修改没有文件 上传
        [self requestUpdateReleaseResume];
    } else {    //有文件调以前接口
        //数据验证
        [param validateDatapublishType:ENUM_PublishTypeEditResume success:^{
            [self uploadData];
        } failure:^(NSString *tip) {
            
            [SVProgressHUD showInfoWithStatus:tip];
        }];
    }
}
#pragma mark 发布
- (void)uploadData {
    
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
    [HKReleaseVideoParam setObject:HKUSERLOGINID key:@"loginUid"];
//    [self Business_Request:BusinessRequestType_get_ReleaseResume dic:[param dataDict] cache:NO];

}
#pragma mark 获取用户简历基本信息
- (void)requestEditResume {
    
    [HK_MyApplyTool getEditResumeSuccessBlock:^(HKEditResumeData *resumeData) {
        self.editResumeData = resumeData;
        self.complete = self.editResumeData.complete;
        self.open = self.editResumeData.isOpen;
        [self.tableView reloadData];
        
    } failed:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
#pragma mark 删除简历附件图片
- (void)requestDelResumeImgWith:(NSString *)imgId {
    [HK_MyApplyTool deleteUserEditResumeWithImageId:imgId successBlock:^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
       //刷新列表
        [self requestEditResume];

    } andFail:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
#pragma mark 更新简历不上传
- (void)requestUpdateReleaseResume {
    [HK_MyApplyTool updateUSerEditResumeIsOpen:self.isOpen successBlock:^{
        //成功
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [HKReleaseVideoParam clearParam];
        [self.navigationController popViewControllerAnimated:YES];
    } andFail:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑视频简历";
    [self requestEditResume];
    [self.tableView registerNib:[UINib nibWithNibName:@"HKChangeVideoCell" bundle:nil] forCellReuseIdentifier:@"HKChangeVideoCell"];
}

- (void)setUpUI {
    //只是为了重写父类方法
}
-(NSMutableArray *)annexImages {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (HKEditResumeDataImgs *imageData in self.editResumeData.imgs) {
        [tempArray addObject:imageData];
    }
    for (UIImage *image in self.pickImages) {
        [tempArray addObject:image];
    }
    return tempArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(void)changeVideoBlock{
    [self.tool toRecordView];
    [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypeEditResume;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            //拍摄并更换视频
            HKChangeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKChangeVideoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.data = self.editResumeData;
//            @weakify(self);
            cell.delegate = self;
            return cell;
        }
            break;
        case 1:
        {
            NSString *cellIdentifier = @"HKResumeCompletionCell";
            HKResumeCompletionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKResumeCompletionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            cell.complete = self.complete;
            return cell;
        }
            break;
        case 2:
        {
//            @weakify(self);
            HKImageAnnexCell *cell = [HKImageAnnexCell imageAnnexCellWithDelegate:self
                                                                              tip:@"添加图片附件"
                                                                           images:[self annexImages]
                                                               cellPickImageBlock:^(NSMutableArray<UIImage *> *pickImages) {
                                                                   DLog(@"选择了图片--:%@",pickImages);
//                                                                   @strongify(self);
                                                                   [HKReleaseVideoParam shareInstance].photographyImages = pickImages;
                                                                   self.pickImages = pickImages;
                                                               } DeleteNetImageBlock:^(HKEditResumeDataImgs *imageData) {
                                                                   //删除网络图片
//                                                                   @strongify(self);
                                                                   [self requestDelResumeImgWith:imageData.ID];
                                                               }];
            return cell;
        }
            break;
        case 3:
        {
            NSString *cellIdentifier = @"UITableViewCell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.textLabel.text = @"屏蔽公司";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = PingFangSCRegular14;
                cell.textLabel.textColor = RGB(102,102,102);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
            break;
        case 4:
        {
            NSString *cellIdentifier = @"HKResumeOpenwCell";
            HKResumeOpenwCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKResumeOpenwCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            cell.open = self.isOpen;
            cell.block = ^(BOOL changed) {
                
                self.open = changed;
                
            };
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
            return 105;
            break;
        case 2:
            return 141.f;
            break;
            
        default:
            return 45;
            break;
    }
}

//header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
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
    if (indexPath.section == 1) {
        HKUpdateResumeViewController *vc = [[HKUpdateResumeViewController alloc] init];
//        @weakify(self);
        vc.block = ^(NSString *complete) {
//            @strongify(self);
            self.complete = complete;
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 3) {
        HKShieldCompanyViewController *vc = [[HKShieldCompanyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
