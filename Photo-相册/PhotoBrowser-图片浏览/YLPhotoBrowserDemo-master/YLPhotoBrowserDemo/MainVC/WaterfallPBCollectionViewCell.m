//
//  WaterfallPBCollectionViewCell.m
//  YLPhotoBrowserDemo
//
//  Created by 杨磊 on 2018/3/22.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "WaterfallPBCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation WaterfallPBCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setPic:(NSString *)pic
{
    _pic = pic;
    NSString *s = [pic stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:s];
    [self.mainPicView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defImage"]];
}
@end
