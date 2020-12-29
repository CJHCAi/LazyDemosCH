//
//  HKLeBuyShoppingCartSectionView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeBuyShoppingCartSectionView.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"

@interface HKLeBuyShoppingCartSectionView()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineR;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionH;

@end

@implementation HKLeBuyShoppingCartSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKLeBuyShoppingCartSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}
-(void)setModel:(getCartListData *)model{
    _model = model;
    self.nameBtn.text = model.name;
    self.selectBtn.selected = model.isSelectList;
    [self.headBtn hk_setBackgroundImageWithURL:model.headImg forState:0 placeholder:kPlaceholderHeadImage];
}
- (IBAction)selectClick:(id)sender {
    self.model.isSelectList = ! self.model.isSelectList;
    if ([self.delegate respondsToSelector:@selector(selectCartSectionDataProducts:isSelect:section:)]) {
        [self.delegate selectCartSectionDataProducts:self.model isSelect:self.model.isSelectList section:self.section];
    }
}
-(void)setIsHideLine:(BOOL)isHideLine{
    _isHideLine = isHideLine;
    if (isHideLine) {
        self.selectBtn.hidden = YES;
        self.actionBtn.hidden = YES;
        self.lineR.constant = 0;
        self.lineLeft.constant = 0;
        self.btnLeft.constant = 0;
        self.actionH.constant = 15;
    }else{
        self.selectBtn.hidden = NO;
        self.actionBtn.hidden = NO;
        self.lineR.constant = 10;
        self.lineLeft.constant = 10;
        self.btnLeft.constant = 4;
        self.actionH.constant = 40;
    }
}
@end
