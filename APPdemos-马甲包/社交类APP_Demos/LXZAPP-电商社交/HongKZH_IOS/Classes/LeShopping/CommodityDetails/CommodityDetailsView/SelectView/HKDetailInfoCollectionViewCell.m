//
//  HKDetailInfoCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDetailInfoCollectionViewCell.h"
#import "CommodityDetailsRespone.h"
#import "UIImageView+HKWeb.h"
@interface HKDetailInfoCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *selectText;
@property (weak, nonatomic) IBOutlet UILabel *stocks;

@end

@implementation HKDetailInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setRespone:(CommodityDetailsRespone *)respone{
    _respone = respone;
    [self.iconView hk_sd_setImageWithURL:respone.data.images.firstObject.imgSrc placeholderImage:kPlaceholderImage];
    self.price.text =[NSString stringWithFormat:@"%.2f",respone.data.integral];
    self.stocks.text = [NSString stringWithFormat:@"库存：%@件",respone.data.stocks.length>0?respone.data.stocks:@""];
    NSMutableString*skusString = [NSMutableString stringWithFormat:@"已选："];
    for (CommodityDetailsesSkus*skusM in respone.data.skus) {
        if ([respone.data.skuId isEqualToString:skusM.skuId]) {
            for (CommodityDetailsesSpecs*specs in respone.data.specs) {
                if ([specs.productSpecId isEqualToString:skusM.productSpecId]) {
                    [skusString appendFormat:@"%@", [NSString stringWithFormat:@"“%@”",specs.name]];
                    break;
                }
            }
            for (CommodityDetailsesColors*colorM in respone.data.colors) {
                if ([colorM.productColorId isEqualToString:skusM.productColorId]) {
                    [skusString appendFormat:@"%@", [NSString stringWithFormat:@"“%@”",colorM.name]];
                    break;
                }
            }
            break;
        }
    }
    self.selectText.text = skusString;
}
- (IBAction)closeClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickClose)]) {
        [self.delegate clickClose];
    }
}
@end
