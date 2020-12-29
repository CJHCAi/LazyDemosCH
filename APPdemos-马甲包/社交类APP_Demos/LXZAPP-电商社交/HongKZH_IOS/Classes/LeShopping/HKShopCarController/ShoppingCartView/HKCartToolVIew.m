//
//  HKCartToolVIew.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCartToolVIew.h"
#import "UIView+BorderLine.h"
@interface HKCartToolVIew()
@property (nonatomic,weak)IBOutlet UIButton *selectBtn;
@property (nonatomic,weak) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,weak) IBOutlet UILabel *numLabel;
@end

@implementation HKCartToolVIew

- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKCartToolVIew" owner:self options:nil].lastObject;
    if (self) {
        [self.deleteBtn borderForColor:[UIColor colorFromHexString:@"999999"] borderWidth:1 borderType:UIBorderSideTypeAll];
    }
    return self;
}
-(IBAction)pay:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(gotoPay)]) {
        [self.delegate gotoPay];
    }
    
}
-(IBAction)deleteClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(deleteVc)]) {
        [self.delegate deleteVc];
    }
}
-(IBAction)selectAll:(id)sender{
    self.selectBtn.selected = !self.selectBtn.selected;
    if ([self.delegate respondsToSelector:@selector(selectAllWithIsSelect:)]) {
        [self.delegate selectAllWithIsSelect:self.selectBtn.selected];
    }
}
-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit) {
        self.deleteView.hidden = NO;
    }else{
        self.deleteView.hidden = YES;
    }
    
}
-(void)setPrice:(NSInteger)price{
    _price = price;
    self.numLabel.text = [NSString stringWithFormat:@"¥%ld",price];
}
@end
