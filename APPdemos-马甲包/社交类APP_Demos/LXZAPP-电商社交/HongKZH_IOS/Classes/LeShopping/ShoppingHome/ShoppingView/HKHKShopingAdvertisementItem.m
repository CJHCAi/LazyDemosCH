//
//  HKHKShopingAdvertisementItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKShopingAdvertisementItem.h"
@interface HKHKShopingAdvertisementItem()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation HKHKShopingAdvertisementItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.iconView.layer.masksToBounds = YES;
//    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.item == 0) {
        self.iconView.image = [UIImage imageNamed:@"sy_xrzx"];
    }else{
         self.iconView.image = [UIImage imageNamed:@"sy_ptqq"];
    }
}
@end
