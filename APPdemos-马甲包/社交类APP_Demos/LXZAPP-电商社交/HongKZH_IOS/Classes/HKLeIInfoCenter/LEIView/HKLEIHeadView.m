//
//  HKLEIHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLEIHeadView.h"
#import "HKMyDataRespone.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "LoginUserDataModel.h"
@interface HKLEIHeadView()
@property (weak, nonatomic) IBOutlet UILabel *dayIncome;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *saveNum;
@property (weak, nonatomic) IBOutlet UILabel *zNum;
@property (weak, nonatomic) IBOutlet UILabel *gzNum;
@property (weak, nonatomic) IBOutlet UILabel *fsNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayLabelY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelY;

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *addressEditV;

@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backGView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScollH;

@end

@implementation HKLEIHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
      
        self = [[NSBundle mainBundle]loadNibNamed:@"HKLEIHeadView" owner:self options:nil].lastObject;
        self.frame = CGRectMake(0, 0, kScreenWidth,  228);
        self.headerView.layer.cornerRadius =30;
        self.headerView.clipsToBounds =YES;
        self.headerView.borderColor=[UIColor whiteColor];
        self.headerView.layer.borderWidth =1;
        self.ScollH.constant = 0;
      //设置
        self.setLabel.userInteractionEnabled =YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setInfo)];
        [self.setLabel addGestureRecognizer:tap];
        
      //头像增加点击事件
        UITapGestureRecognizer * tapH =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
        self.headerView.userInteractionEnabled =YES;
        [self.headerView addGestureRecognizer:tapH];
     //姓名 加点击事件 进入自媒体主页..
        self.namelabel.userInteractionEnabled =YES;
        UITapGestureRecognizer *tapName =[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(nameClick)
                                          ];
        [self.namelabel addGestureRecognizer:tapName];
        
        if (isIPhoneXAll) {
            self.todayLabelY.constant = 45;
            self.nameLabelY.constant =32;
        }
        self.level.hidden =YES;
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        bgImgView.layer.masksToBounds =YES;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
                effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
        [self.backGView addSubview:effectView];
     //金币明细
        self.detailLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *taoD =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailClick)];
        [self.detailLabel addGestureRecognizer:taoD];
    }
    return self;
}

-(void)setImageV:(UIImage *)picture {
    
    self.headerView.image = picture;
}

-(void)detailClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(coinDetails)]) {
        [self.delegate coinDetails];
    }
}
-(void)nameClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushUserMainVc)]) {
        [self.delegate pushUserMainVc];
    }
}
-(void)headerClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editHeaderImage)]) {
        [self.delegate editHeaderImage];
    }
}
-(void)setInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSetInfo)]) {
        [self.delegate clickSetInfo];
    }
}
- (IBAction)saveClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(saveClick)]) {
        [self.delegate saveClick];
    }
}
- (IBAction)assistClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(assistClick)]) {
        [self.delegate assistClick];
    }
}
- (IBAction)attention:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(attention)]) {
        [self.delegate attention];
    }
}
- (IBAction)vermicelliClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(vermicelliClick)]) {
        [self.delegate vermicelliClick];
    }
}
- (IBAction)seTBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setBtnClick)]) {
        [self.delegate setBtnClick];
    }
}
-(void)setRespone:(HKMyDataRespone *)respone{
    _respone = respone;
    self.dayIncome.text = [NSString stringWithFormat:@"%ld",(long)respone.data.dayIncome];
    self.level.text = [NSString stringWithFormat:@"%ld",(long)respone.data.currentLevelNum];
//    self.levelW.constant = kScreenWidth*respone.data.currentLevelNum/respone.data.enoughLevelNum;
    self.saveNum.text = [NSString stringWithFormat:@"%ld",(long)respone.data.collections];
    self.zNum.text = [NSString stringWithFormat:@"%ld",(long)respone.data.praises];
    self.gzNum.text = [NSString stringWithFormat:@"%ld",(long)respone.data.follows];
    
    self.fsNum.text = [NSString stringWithFormat:@"%ld",(long)respone.data.fans];
    
    self.namelabel.text = [LoginUserData sharedInstance].name;
    if ([LoginUserData sharedInstance].portait) {
        self.headerView.image =[LoginUserData sharedInstance].portait;
        
    }else {
          [self.headerView sd_setImageWithURL:[NSURL URLWithString:[LoginUserData sharedInstance].headImg]];
        [self.backGView sd_setImageWithURL:[NSURL URLWithString:[LoginUserData sharedInstance].headImg]];
        
    }
}
-(void)cancelAllData  {
    self.dayIncome.text = [NSString stringWithFormat:@"%d",0];
    self.level.text = [NSString stringWithFormat:@"%d",0];
    //    self.levelW.constant = kScreenWidth*respone.data.currentLevelNum/respone.data.enoughLevelNum;
    self.saveNum.text = [NSString stringWithFormat:@"%d",0];
    self.zNum.text = [NSString stringWithFormat:@"%d",0];
    self.gzNum.text = [NSString stringWithFormat:@"%d",0];
    
    self.fsNum.text = [NSString stringWithFormat:@"%d",0];
    self.namelabel.text = @"";
    self.headerView.image =[UIImage imageNamed:@"Man"];
    self.backGView.image =[UIImage imageNamed:@"Man"];
    
}
@end
