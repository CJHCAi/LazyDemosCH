//
//  RecommendCollectionViewCell.m
//  RabbitWallpaper
//
//  Created by MacBook on 16/4/29.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "RecommendCollectionViewCell.h"

@implementation RecommendCollectionViewCell



-(void)RecommendCollectionWithData:(NSDictionary *)data{
    NSString *imageStr = [data objectForKey:@"url"];
    [_oneImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
//    surl
    
    NSString *imageStr2 = [data objectForKey:@"surl"];
    [_twoImageView sd_setImageWithURL:[NSURL URLWithString:imageStr2]];
//    turl
    NSString *imageStr3 = [data objectForKey:@"turl"];
    [_threeImageView sd_setImageWithURL:[NSURL URLWithString:imageStr3]];
    
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"name"]];
}
@end
