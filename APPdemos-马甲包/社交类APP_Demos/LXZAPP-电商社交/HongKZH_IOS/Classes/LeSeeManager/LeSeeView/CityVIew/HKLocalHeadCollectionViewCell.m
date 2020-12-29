//
//  HKLocalHeadCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLocalHeadCollectionViewCell.h"
@interface HKLocalHeadCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *palyBtn;

@end

@implementation HKLocalHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)paly:(id)sender {
    if ([self.delegate respondsToSelector:@selector(palyWithIndexPath:)]) {
        [self.delegate palyWithIndexPath:self.indexPath];
    }
}
-(void)setStaue:(HKPalyStaue)staue{
    _staue = staue;
    switch (staue) {
        case HKPalyStaue_play:
            case HKPalyStaue_resume:
            self.palyBtn.hidden = YES;
            break;
            
        default:
            self.palyBtn.hidden = NO;
            break;
    }
}
@end
