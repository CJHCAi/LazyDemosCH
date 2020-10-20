//
//  AddMemberViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "AddMemberViewController.h"
#import "AddMenberView.h"
@interface AddMemberViewController ()<BackScrollAndDetailViewDelegate>

/**创建家谱view*/
@property (nonatomic,strong) AddMenberView *AddFameView;

/**添加成员的id*/
@property (nonatomic,copy) NSString *gemeId;


@end

@implementation AddMemberViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=false;
    AddMenberView *addM = [[AddMenberView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height)];
    addM.delegate = self;
    self.AddFameView = addM;
    [self.view addSubview:addM];
    [self.view bringSubviewToFront:self.comNavi];
  
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = false;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = true;

}

#pragma mark *** BackScrollAndDetailViewDelegate ***

-(void)BackScrollAndDetailViewDidTapCreateButton{
    MYLog(@"add");

    //添加成员
    if ([self.AddFameView.name.detailLabel.text isEqualToString:@""]) {
        [SXLoadingView showAlertHUD:@"姓名不能为空" duration:0.5];
        return;
    }
    if ([self.AddFameView.fatheView.inputLabel.text isEqualToString:@""]) {
        [SXLoadingView showAlertHUD:@"父亲不能为空" duration:0.5];
        return;
    }
    
    if ([self.AddFameView.parnName.text isEqualToString:@""]) {
        self.AddFameView.parnName.text = @"不详";
    }
    if ([self.AddFameView.motherView.text isEqualToString:@""]) {
        [SXLoadingView showAlertHUD:@"母亲不能为空" duration:0.5];
        return;
    }
    //截取代数
    NSString *genNumber = [self.AddFameView.gennerNum.inputLabel.text stringByReplacingOccurrencesOfString:@"第" withString:@""];
    NSString *genNumberF = [genNumber stringByReplacingOccurrencesOfString:@"代" withString:@""];
    
    NSString *shenfenId = [WIDModel sharedWIDModel].idDic[self.AddFameView.idView.inputLabel.text];
    NSString *fatherId = [WIDModel sharedWIDModel].fatherDic[self.AddFameView.fatheView.inputLabel.text];
    
    NSDictionary *addDic = @{@"GeId":[WFamilyModel shareWFamilModel].myFamilyId,
                             @"Zb":self.AddFameView.gennerZB.inputLabel.text,
                             @"Father":fatherId,
                             @"Ds":genNumberF,
                             @"Sf":shenfenId,
                             @"Photo":@"",
                             @"Grjl":self.AddFameView.selfTextView.text,
                             @"Jzd":self.AddFameView.moveCity.text,
                             @"GemeSurname":@"",
                             @"GemeName":self.AddFameView.name.detailLabel.text,
                             @"GemeSex":[self.AddFameView.sexInView.inputLabel.text isEqualToString:@"女"]?@"0":@"1",
                             @"GemeIsfamous":self.AddFameView.famousPerson.marked?@"1":@"0",
                             @"GemeYear":self.AddFameView.birthLabel.inputLabel.text,
                             @"GemeMonth":self.AddFameView.monthLabel.inputLabel.text,
                             @"GemeDay":self.AddFameView.dayLabel.inputLabel.text,
                             @"GemeHour":self.AddFameView.birtime.inputLabel.text,
                             @"GemeDeathtime":[self.AddFameView.liveNowLabel.inputLabel.text isEqualToString:@"是"]?@"":[NSString stringWithFormat:@"%@-%@-%@",self.AddFameView.selfYear.inputLabel.text,self.AddFameView.selfMonth.inputLabel.text,self.AddFameView.selfDay.inputLabel.text],
                             @"GemeIslife":[self.AddFameView.liveNowLabel.inputLabel.text isEqualToString:@"是"]?@"1":@"0",
                             @"Po":self.AddFameView.parnName.text,
                             @"Mother":self.AddFameView.motherView.text,
                             @"IsEnt":@"1",
                             @"Ph":self.AddFameView.rankingView.inputLabel.text,
                             @"IsJp":@""
                             };
//    [SXLoadingView showProgressHUD:@"正在添加..."];
    [TCJPHTTPRequestManager POSTWithParameters:addDic requestID:GetUserId requestcode:kRequestCodeaddgeme success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            _gemeId = [NSString jsonDicWithDic:jsonDic[@"data"]][@"gemeid"];
            [self uploadImageWithGemeid:_gemeId];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCodeAddMember object:nil];
            
            }
        
    } failure:^(NSError *error) {
        MYLog(@"失败");
    }];
}
/**
 *  上传添加家谱成员的头像
 *
 *  @param gemeid 家谱成员id
 */
-(void)uploadImageWithGemeid:(NSString *)gemeid{
    
    if (self.AddFameView.selecProtrai.image) {
        UIImage *cemeteryImage = self.AddFameView.selecProtrai.image;
        NSData *imageData = UIImageJPEGRepresentation(cemeteryImage, 0.5);
        NSString *encodeimageStr =[imageData base64EncodedString];
        
        [TCJPHTTPRequestManager POSTWithParameters:@{@"userid":GetUserId,@"genmemid":_gemeId,@"imgbt":encodeimageStr} requestID:GetUserId requestcode:kRequestCodeuploadgenimg success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            
            if (succe) {
                [SXLoadingView showProgressHUD:jsonDic[@"message"] duration:0.5];
            }
            
        } failure:^(NSError *error) {
            MYLog(@"错误");
        }];
    }else{
        [SXLoadingView showAlertHUD:@"没有头像" duration:0.5];
    }

}


@end
