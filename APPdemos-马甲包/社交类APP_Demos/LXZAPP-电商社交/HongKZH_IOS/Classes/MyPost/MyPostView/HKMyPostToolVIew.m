//
//  HKMyPostToolVIew.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyPostToolVIew.h"
#import "UIView+Xib.h"
@interface HKMyPostToolVIew()
@property (weak, nonatomic) IBOutlet UILabel *Fabulous;

@end

@implementation HKMyPostToolVIew

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
}
-(void)setModel:(HKMyPostModel *)model{
    _model = model;
    self.Fabulous.text = [NSString stringWithFormat:@"%ld",model.commitCount] ;
}
- (IBAction)share:(id)sender {
    if ([self.delegate respondsToSelector:@selector(viewShare)]) {
        [self.delegate viewShare];
    }
}
- (IBAction)commit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(viewcommit)]) {
        [self.delegate viewcommit];
    }
}
- (IBAction)praise:(id)sender {
    if ([self.delegate respondsToSelector:@selector(viewPraise)]) {
        [self.delegate viewPraise];
    }
}
@end
