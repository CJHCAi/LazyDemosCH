//
//  TributeSelectView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "TributeSelectView.h"


@interface TributeSelectView()
/** 背景图*/
@property (nonatomic, strong) UIImageView *backIV;

/** 选定的贡品模型*/
@property (nonatomic, strong) CliffordTributeModel *selectedTributeModel;
@end

@implementation TributeSelectView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:self.backIV];
        [self initFourTributeBtn];
        
    }
    return self;
}


#pragma mark - 视图初始化
-(void)initFourTributeBtn{
    
    [self initOneTributeBtnWithFrame:CGRectMake(0.1453*CGRectW(self.backIV), 0.1193*CGRectH(self.backIV), 0.6325*CGRectW(self.backIV), 0.1042*CGRectH(self.backIV)) withStr1:@"香烛" withStr2:@"免费" withImage:MImage(@"qf_gp_xianglu") withTag:111+0];
    
    [self initOneTributeBtnWithFrame:CGRectMake(0.1453*CGRectW(self.backIV), 0.1193*CGRectH(self.backIV)+0.1364*CGRectH(self.backIV), 0.6325*CGRectW(self.backIV), 0.1042*CGRectH(self.backIV)) withStr1:@"水果" withStr2:@"2积分/次" withImage:MImage(@"qf_gp_xiangjiao") withTag:111+1];

    [self initOneTributeBtnWithFrame:CGRectMake(0.1453*CGRectW(self.backIV), 0.1193*CGRectH(self.backIV)+0.1364*CGRectH(self.backIV)*2, 0.6325*CGRectW(self.backIV), 0.1042*CGRectH(self.backIV)) withStr1:@"牲礼" withStr2:@"10积分/次" withImage:MImage(@"qf_gp_shengli") withTag:111+2];
    
    [self initOneTributeBtnWithFrame:CGRectMake(0.1453*CGRectW(self.backIV), 0.1193*CGRectH(self.backIV)+0.1364*CGRectH(self.backIV)*3, 0.6325*CGRectW(self.backIV), 0.1042*CGRectH(self.backIV)) withStr1:@"元宝" withStr2:@"10分/次" withImage:MImage(@"qf_gp_yuanbao") withTag:111+3];
    
    //确定按钮
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.2239*CGRectW(self.backIV), 0.7143*CGRectH(self.backIV), 0.2462*CGRectW(self.backIV), 0.0975*CGRectH(self.backIV))];
    [sureBtn setBackgroundImage:MImage(@"qf_gp_queren") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.backIV addSubview:sureBtn];
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5778*CGRectW(self.backIV), CGRectY(sureBtn), CGRectW(sureBtn), CGRectH(sureBtn))];
    [cancelBtn setBackgroundImage:MImage(@"qf_gp_fanhui") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.backIV addSubview:cancelBtn];
}

//一个按钮的方法
-(void)initOneTributeBtnWithFrame:(CGRect)frame withStr1:(NSString *)str1 withStr2:(NSString *)str2 withImage:(UIImage *)image withTag:(NSInteger)tag{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 0.4216*frame.size.width, frame.size.height)];
    [button setImage:MImage(@"qf_gp_xuankuan") forState:UIControlStateNormal];
    [button setImage:MImage(@"qf_gp_xuanzhong") forState:UIControlStateSelected];
    button.tag = tag;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    //button.backgroundColor = [UIColor blueColor];
    [button setTitle:str1 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = MFont(14);
    [button addTarget:self action:@selector(clickToSelectTribute:) forControlEvents:UIControlEventTouchUpInside];
    if ([str1 isEqualToString:@"香烛"]) {
        button.selected = YES;
        button.userInteractionEnabled = NO;
    }
    [self.backIV addSubview:button];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectXW(button)+10, frame.origin.y, 0.1892*frame.size.width, frame.size.height)];
    imageV.image = image;
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.backIV addSubview:imageV];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(imageV)+10, frame.origin.y, 0.3649*frame.size.width, frame.size.height)];
    label.text = str2;
    label.font = MFont(14);
    [self.backIV addSubview:label];
}

#pragma mark - 点击方法
-(void)clickToSelectTribute:(UIButton *)sender{
    if (sender.selected == NO) {
        for (int i = 1; i < 4; i++) {
            UIButton *button = (UIButton *)[self viewWithTag:111+i];
            button.selected = NO;
        }
    }
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.selectedTributeModel = self.tributeArr[sender.tag-111-1];
    }else{
        self.selectedTributeModel = nil;
    }
    MYLog(@"%@",self.selectedTributeModel);
    
}

-(void)clickSureBtn{
    if (!self.selectedTributeModel) {
        [SXLoadingView showAlertHUD:@"请至少选择一样" duration:0.5];
    }else{
        //发购买请求
        [self uploadBuyTribute];
        [self removeFromSuperview];
    }
    
}

-(void)clickCancelBtn{
    [self removeFromSuperview];
}

#pragma mark - lazyLoad
-(UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.04375*CGRectW(self), 0.1451*CGRectH(self), 0.9141*CGRectW(self), 0.6538*CGRectH(self))];
        _backIV.userInteractionEnabled = YES;
        _backIV.image = MImage(@"qf_gp_bg");
    }
    return _backIV;
}

#pragma mark - 请求
-(void)uploadBuyTribute{
   
    
    NSDictionary *logDic = @{@"CoId":@(self.selectedTributeModel.CoId),
                             @"CoprId":@(self.selectedTributeModel.CoprId),
                             @"Type":@"Qifu"};
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"qiuqianqifupay" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic[@"data"]);
        if (succe) {
            if ([jsonDic[@"message"] isEqualToString:@"操作成功"]) {
                //刷新贡品
                [self.delegate buyOneTribute:self.selectedTributeModel];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

@end


