//
//  HKAdvertisingTypeTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAdvertisingTypeTableViewCell.h"
#import "CorporateCategoryResponse.h"
#import "HKTypeAdvertising.h"
@interface HKAdvertisingTypeTableViewCell()<HKTypeAdvertisingDelegate>
@property (weak, nonatomic) IBOutlet HKTypeAdvertising *typesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeViewH;
@property (weak, nonatomic) IBOutlet UIButton *openbtn;

@end

@implementation HKAdvertisingTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typesView.delegate = self;
}
-(void)clickCategory:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(selectCategory:index:)]) {
        [self.delegate selectCategory:[self.model.data[tag]ID]index:tag];
    }
}
-(void)setModel:(CorporateCategoryResponse *)model{
    _model = model;
    self.typesView.currentIndex = self.currentIndex;
    self.typesView.respone = model;
    if (model.isOpen) {
        int row = 0;
        if (model.data.count%4 == 0) {
            row =(int)model.data.count/4;
        }else{
            row =(int)model.data.count/4+1;
        }
        self.typeViewH.constant = row*30+(row-1)*15+30;
    }else{
        self.typeViewH.constant = 64;
    }
}
- (IBAction)open:(id)sender {
    self.model.isOpen = !self.model.isOpen;
    if ([self.delegate respondsToSelector:@selector(tableViewRefresh)]) {
        [self.delegate tableViewRefresh];
    }
    if (self.model.isOpen) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        
        [ self.openbtn setTransform:transform];
    }else{
        
        [ self.openbtn setTransform:CGAffineTransformIdentity];
    }
    
    
}
@end
