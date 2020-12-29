//
//  HKRewardViewsController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRewardViewsController.h"
#import "HKRewardView.h"
#import "HKEditRewardView.h"
#import "HKLeSeeViewModel.h"
@interface HKRewardViewsController ()<HKRewardViewDelegate,HKEditRewardViewDelegate>
@property (nonatomic, strong)HKRewardView *rewardViews;
@property (nonatomic, strong)HKEditRewardView *editView;
@end

@implementation HKRewardViewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)setUI{
    [self.view addSubview:self.rewardViews];
    [self.view addSubview:self.editView];
    [self.rewardViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.width.mas_equalTo(kScreenWidth-30);
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(225);
    }];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScreenWidth);
        make.bottom.equalTo(self.view).offset(-(kScreenHeight-225)*0.5);
        make.width.mas_equalTo(kScreenWidth-30);
        make.height.mas_equalTo(225);
    }];
}
-(void)gotoShowedit{
    [self.rewardViews mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(-kScreenWidth);
    }];
    [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
    }];
    [UIView animateWithDuration:0.1 animations:^{
    
        [self.view layoutIfNeeded];
        [self.view layoutSubviews];
      
    }completion:^(BOOL finished) {
        [self.editView startEdit];
    }];
}
- (void)gotoLeft{
    [self.rewardViews mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
    }];
    [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScreenWidth);
    }];
    [UIView animateWithDuration:0.1 animations:^{
        
        [self.view layoutIfNeeded];
        [self.view layoutSubviews];
        
    }completion:^(BOOL finished) {
        [self.view endEditing:YES];
    }];
}
-(void)hideView{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)confirmWithNum:(NSInteger)money{
    int type = 0;
    NSDictionary*dic;
    if (self.ID.length>0) {
        dic = @{@"loginUid":HKUSERLOGINID,@"money":@(money),@"id":self.ID.length>0?self.ID:@""};
    }else{
        type = 1;
        dic = @{@"loginUid":HKUSERLOGINID,@"money":@(money),@"cityAdvId":self.cityAdvId.length>0?self.cityAdvId:@""};
    }
    
    [HKLeSeeViewModel advReward:dic type:type success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showSuccessWithStatus:@"打赏成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:responde.msg];
        }
    }];
}
- (void)keyBoardWillShow:(NSNotification *)notify{

    CGRect keyboardRect = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transY = - keyboardRect.size.height;
    
    NSTimeInterval timeInterval = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];//动画持续时间
    UIViewAnimationCurve curve = [notify.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];//动画曲线类型
    
    [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(transY);
    }];
    [UIView setAnimationCurve:curve];
    [UIView animateWithDuration:timeInterval animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)keyBoardWillHide:(NSNotification *)notify{
    [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(kScreenHeight-225)*0.5);
    }];
    [UIView animateWithDuration:0.05 animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(HKRewardView *)rewardViews{
    if (!_rewardViews) {
        _rewardViews = [[HKRewardView alloc]init];
        _rewardViews.delegate = self;
        
    }
    return _rewardViews;
}
-(HKEditRewardView *)editView{
    if (!_editView) {
        _editView = [[HKEditRewardView alloc]init];
        _editView.delegate = self;
    }
    return _editView;
}
+(void)showReward:(UIViewController*)subVc andType:(int)type andId:(NSString*)ID{
    subVc.navigationController.definesPresentationContext = YES;
    HKRewardViewsController *vc = [[HKRewardViewsController alloc]init];
    if (type == 0) {
        vc.ID = ID;
    }else{
        vc.cityAdvId = ID;
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    subVc.navigationController.definesPresentationContext = YES;
    [subVc.navigationController presentViewController:vc animated:YES completion:nil];
}
@end
