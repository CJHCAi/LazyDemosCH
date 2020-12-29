//
//  HKLEIViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLEIViewController.h"
#import "HKLEIOperationModel.h"
#import "HKLEIOperationCell.h"
#import "HKLEIHeadView.h"
#import "HKMyApplyViewController.h"
#import "HKMyTravelViewController.h"
#import "HKMyFollowsContainerViewController.h"
#import "HKMyFansViewController.h"
#import "HK_WalletController.h"
#import "HKViewMyOrderController.h"
#import "HKShareFriendViewController.h"
#import "HKSearchShareViewController.h"
#import "HKSaleHomeViewController.h"
#import "HKBaseCartListViewController.h"
#import "HKBuyerAfterSale.h"
#import "HK_BaseRequest.h"
#import "HK_UserInfoDataModel.h"
#import "HKLeIViewModel.h"
#import "HKMyPostManageViewController.h"
#import "HKMyDataRespone.h"
#import "HKTagSetController.h"
#import "HK_baseVideoConrtoller.h"
#import "HKMyDraftViewController.h"
#import "HKMyRecruitViewController.h"
#import "HKUpdateUserDataViewController.h"
#import "HKCouponSubVc.h"
#import "HKSetingVc.h"
#import "HKSetTool.h"
#import "HK_ShopsDetailVc.h"
#import "ImageUtil.h"
#import "HKDateTool.h"
#import "HK_LoginRegesterTool.h"
#import "HKPersonAuthVc.h"
#import "HKRealNameAuthViewController.h"
#import "HKMyCoinViewController.h"
@interface HKLEIViewController ()<UITableViewDelegate,UITableViewDataSource,HKLEIHeadViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataAray;
@property (nonatomic, strong)HKLEIHeadView *headView;
@property (nonatomic, strong)HKMyDataRespone *respone;
@property (nonatomic, strong) HK_UserRecruitData *infoData;
@property (nonatomic, copy)NSString *realNameState;
@end

@implementation HKLEIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self addNotification];
}
-(void)cancelNewUser {
    [super cancelNewUser];
}
-(void)loadData{
    [HKLeIViewModel myData:@{@"loginUid":HKUSERLOGINID} success:^(HKMyDataRespone *responde) {
        if (responde.responeSuc) {
            
            self.respone = responde;
            [self.tableView reloadData];
            self.headView.respone = responde;
            
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
   
    if ([LoginUserDataModel isHasSessionId]) {
       //刷新数据
        [self UserIntegral];
        [self loadData];
        [self loadMyInfo];
        [self realNameRequest];
    }else  {
      //退出登录.移除数据...
        [self.headView cancelAllData];
        [self clearAllData];
    }
}
-(void)realNameRequest {
    //是否实名认证了
    [HKSetTool userIsRealNamesuccessBlock:^(id response) {
       self.realNameState =response[@"data"][@"state"];
    } fail:^(NSString *error) {
        
    }];
}
-(void)clearAllData {
    self.respone.data.afterService = 0;
    self.respone.data.answer = 0;
    self.respone.data.sells = 0;
    self.respone.data.dayIncome = 0;
    self.respone.data.carts =0;
    self.respone.data.task =0;
    self.respone.data.orders = 0;
    [self.tableView reloadData];
}
-(void)loadMyInfo {
    [HK_BaseRequest buildPostRequest:get_recruitUserInfo body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HK_BaseInfoResponse *response =[HK_BaseInfoResponse mj_objectWithKeyValues:responseObject];
        if (response.code==0) {
            self.infoData = response.data;
        }else {
         //登录信息失效清除loginUid
            [LoginUserDataModel clearUserInfo];
        }
    } failure:^(NSError * _Nullable error) {
    }];
}
-(void)UserIntegral {
    [HK_BaseRequest buildPostRequest:get_usergetUserIntegral body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {

        HK_UserInfoDataModel * model =[HK_UserInfoDataModel mj_objectWithKeyValues:responseObject];
        if (!model.code) {
            id interger =model.data;
            if ([interger isKindOfClass:[NSNull class]]) {
                [LoginUserData sharedInstance].integral =0;
            }else {
                [LoginUserData sharedInstance].integral =model.data.integral;
            }
        }
    } failure:^(NSError * _Nullable error) {
    }];
}
-(void)setUI{
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(-StatusBarHeight);
        make.bottom.equalTo(self.view).offset(0);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.tableHeaderView = self.headView;
        _tableView.showsVerticalScrollIndicator =NO;
    }
    return _tableView;
}
#pragma mark 编辑查看个人资料
-(void)clickSetInfo {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKUpdateUserDataViewController *upvc =[[HKUpdateUserDataViewController alloc]init];
    upvc.infoData  =self.infoData;
    [self.navigationController pushViewController:upvc animated:YES];
}
#pragma mark 金币详情
-(void)coinDetails {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKMyCoinViewController *coinV =[[HKMyCoinViewController alloc] init];
    [self.navigationController pushViewController:coinV animated:YES];
}
#pragma mark 进入个人主页...
-(void)pushUserMainVc {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKMyFollowAndFansList *model =[[HKMyFollowAndFansList alloc] init];
    model.uid =[LoginUserData sharedInstance].chatId;
    model.name =[LoginUserData sharedInstance].name;
    model.headImg =[LoginUserData sharedInstance].headImg;
    model.gcount = 100000;
    [AppUtils pushUserDetailInfoVcWithModel:model andCurrentVc:self];
}
-(void)saveClick{
    
    //我的收藏
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HK_baseVideoConrtoller *baseV =[[HK_baseVideoConrtoller alloc] init];
    baseV.videoType = Cater_collectionCaterGory;
    [self.navigationController pushViewController:baseV animated:YES];

}
-(void)assistClick{
    //我的点赞
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HK_baseVideoConrtoller *baseV =[[HK_baseVideoConrtoller alloc] init];
    baseV.videoType = Cater_priseCaterGory;
    [self.navigationController pushViewController:baseV animated:YES];
    
}
-(void)attention{
 
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    //我的关注
       HKMyFollowsContainerViewController *vc = [[HKMyFollowsContainerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)vermicelliClick{

    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
//    //我的粉丝
       HKMyFansViewController *vc = [[HKMyFansViewController alloc] init];
       vc.type = FollowsFan_Fans;
       [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark 进入设置界面
-(void)setBtnClick {
    HKSetingVc *setVc =[[HKSetingVc alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataAray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray*array = self.dataAray[section];
    return array.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   UIView*headv = [[UIView alloc]init];
    headv.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    return headv;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKLEIOperationCell *cell = [HKLEIOperationCell lEIOperationCellWithTableView:tableView];
    cell.dataModel = self.dataAray[indexPath.section][indexPath.row];
    cell.respone = self.respone;
//    if (indexPath.section==2&&indexPath.row==1) {
//        [cell configueRecuitCell];
//    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
                {
                    HKBaseCartListViewController * shopVc =[[HKBaseCartListViewController alloc] init];
                    [self.navigationController pushViewController:shopVc animated:YES];
                    
                }
                    break;
                case 1:{
    
                    HKViewMyOrderController *orderVc =[[HKViewMyOrderController alloc] init];
                    [self.navigationController pushViewController:orderVc animated:YES];
                    
                }
                    break;
                case 2:
                {
                    HKBuyerAfterSale *buyAfterVc =[[HKBuyerAfterSale alloc] init];
                    [self.navigationController pushViewController:buyAfterVc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    HKSaleHomeViewController *vc = [[HKSaleHomeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                    break;
                    
                default:
                    break;
            }
 
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
              //我的视频
                HK_baseVideoConrtoller *baseV =[[HK_baseVideoConrtoller alloc] init];
                baseV.videoType = Cater_videoCatergory;
                [self.navigationController pushViewController:baseV animated:YES];
                
            }else if (indexPath.row==3){
                
                DLog(@"%ld==",(long)[LoginUserData sharedInstance].isEnterpriserecRuited);
#pragma mark 判断是企业还是个人...进入招聘或者应聘
                if ([LoginUserData sharedInstance].isEnterpriserecRuited==2) {
                  //企业招聘
                HKMyRecruitViewController *vc = [[HKMyRecruitViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];


                }else {
                    //我的应聘
                    HKMyApplyViewController *vc = [[HKMyApplyViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if (indexPath.row == 1){
                //我的游记
                HKMyTravelViewController *vc = [[HKMyTravelViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row ==2) {
               //我的草稿箱
                  HKMyDraftViewController *vc = [[HKMyDraftViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 3:{
            if (indexPath.row==0) {
             //我的钱包
                HK_WalletController *wallert =[[HK_WalletController alloc] initWithNibName:@"HK_WalletController" bundle:nil];
                [self.navigationController pushViewController:wallert animated:YES];
                
            }else if (indexPath.row==1) {
                HKCouponSubVc *con =[[HKCouponSubVc alloc] init];
                [self.navigationController pushViewController:con animated:YES];
            }
        }
            break;
        case 4:{
            if (indexPath.row==0) {
               //实名认证
                if (self.realNameState.integerValue) {
                    HKPersonAuthVc *person =[[HKPersonAuthVc alloc] init];
                    person.state =self.realNameState.intValue;
                    [self.navigationController pushViewController:person animated:YES];
                }else {
                    //实名认证
                    HKRealNameAuthViewController * relaNmaeVC =[[HKRealNameAuthViewController alloc] init];
                    [self.navigationController pushViewController:relaNmaeVC animated:YES];
                }
    
            }else if (indexPath.row==1) {
                //设置.
                HKSetingVc *setVC =[[HKSetingVc alloc] init];
                [self.navigationController pushViewController:setVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
- (NSArray *)dataAray
{
    if(_dataAray == nil)
    {
        
    NSString*path =    [[NSBundle mainBundle]pathForResource:@"LEI" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray*dataArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSArray*a in array) {
            NSMutableArray*b = [NSMutableArray arrayWithCapacity:a.count];
            for (NSDictionary*dict in a) {
              HKLEIOperationModel*m =   [HKLEIOperationModel mj_objectWithKeyValues:dict];
                [b addObject:m];
            }
            [dataArray addObject:b];
        }
        _dataAray = dataArray.copy;
    }
    return _dataAray;
}
- (HKLEIHeadView *)headView
{
    if(_headView == nil)
    {
        _headView = [[ HKLEIHeadView alloc]init];
        _headView.delegate = self;
        
    }
    return _headView;
}
-(void)editHeaderImage {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    [SRActionSheet sr_showActionSheetViewWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"拍照",@"去相册选取"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
       
        if (index ==0) {
            [self snapImage];
        }else {
            
            [self pickImage];
        }
    }];
}
//拍照
- (void)snapImage{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [AppUtils openImagePicker:self sourceType:UIImagePickerControllerSourceTypeCamera allowsEditing:YES];
    }];
}
//从相册里找
- (void)pickImage{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [AppUtils openImagePicker:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:YES];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *img=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    UIImage * im =[ImageUtil fixImageOrientation:img];
    [self uploadImage:im];
}
#pragma  mark 上传图片
-(void)uploadImage:(UIImage *)image{
    NSMutableArray *headArr =[[NSMutableArray alloc] init];
    [headArr addObject:image];
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:HKUSERLOGINID forKey:kloginUid];
    [Toast loading];
    [HK_NetWork uploadImageURL:[NSString stringWithFormat:@"%@%@",Host,get_userUpdateUserHeadImg] parameters:params images:headArr name:@"headImg" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:@"jpeg" progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
      
        [Toast loaded];
        if (error) {
            [EasyShowTextView showText:@"头像更换失败"];
        }else {
            if ([[responseObject objectForKey:@"code"] integerValue]==0) {
                NSDictionary * dataDic =[responseObject objectForKey:@"data"];
                NSString * data =dataDic[@"headImg"];
                [LoginUserData sharedInstance].headImg =data;
                self.headView.respone = self.respone;
                [EasyShowTextView showText:@"头像更换成功"];
                
            }else {
                 [EasyShowTextView showText:@"头像更换失败"];
            }
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
