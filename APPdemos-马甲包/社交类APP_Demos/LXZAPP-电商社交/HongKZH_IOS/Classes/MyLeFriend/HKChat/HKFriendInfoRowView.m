//
//  HKFriendInfoRowView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFriendInfoRowView.h"
#import "UIView+Xib.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKFriendInfoRowView()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *sex;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *lv;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headImage;

@end

@implementation HKFriendInfoRowView

-(void)awakeFromNib{
    [super awakeFromNib];
     [self settingUI];
    [self setupSelfNameXibOnSelf];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSelfNameXibOnSelf];
        [self settingUI];
    }
    return self;
}
-(void)settingUI{
    self.backView.layer.cornerRadius = 6;
    self.backView.layer.masksToBounds = YES;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick)];
    [self addGestureRecognizer:tap];
}
-(void)viewClick{
    if ([self.delegate respondsToSelector:@selector(goToInfo)]) {
        [self.delegate goToInfo];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // TODO:init
        [self setupSelfNameXibOnSelf];
        self.frame = frame;
         [self settingUI];
    }
    return self;
}
-(void)settingInfoWithName:(NSString*)name sex:(NSInteger)sex desc:(NSString*)desc headImage:(NSString*)headImage{
    self.name.text = name;
   
    if (sex>0) {
        self.backView.hidden = NO;
    }else{
        self.backView.hidden = YES;
       self.sex.selected = sex;
        if (sex == 1) {
            self.backView.backgroundColor = [UIColor colorFromHexString:@"FFC0CB"];
        }else{
            self.backgroundColor = [UIColor blueColor];
        }
    }
    self.descLabel.text = desc.length>0?desc:@"";
    [self.headImage hk_setBackgroundImageWithURL:headImage forState:0 placeholder:kPlaceholderHeadImage];
}
@end
