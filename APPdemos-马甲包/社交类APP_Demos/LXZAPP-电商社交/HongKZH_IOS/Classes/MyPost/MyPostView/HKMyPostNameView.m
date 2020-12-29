//
//  HKMyPostNameView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyPostNameView.h"
#import "UIView+Xib.h"
#import "HKMyPostsRespone.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKMyPostNameView()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *timeLbael;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation HKMyPostNameView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    [self setupSelfNameXibOnSelf];
}
-(void)setModel:(HKMyPostModel *)model{
    _model = model;
    [self.headBtn hk_setBackgroundImageWithURL:model.headImg forState:0 placeholder:kPlaceholderHeadImage];
    if (model.name.length>0) {
        self.name.text = model.name;
    }else{
        self.name.text = model.uName;
    }
    
    self.timeLbael.text = model.createDate;
    if (model.isShowLabel) {
        self.nameLabel.hidden = NO;
        self.rightBtn.hidden = YES;
        self.nameLabel.text = model.title;
    }else{
        self.nameLabel.hidden = YES;
        self.rightBtn.hidden = NO;
    }
}
- (IBAction)rightBarClick:(id)sender {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(repostUserWithUid:)]) {
        
        [self.delegete repostUserWithUid:self.model.uid];
    }
}
- (IBAction)headClick:(id)sender {
    
    if (self.delegete  && [self.delegete respondsToSelector:@selector(clickHeader:userName:uid:)]) {
        [self.delegete clickHeader:self.model.headImg userName:self.model.name uid:self.model.uid];
    }
}


@end
