//
//  HomeCollectionViewCell.m
//  RabbitWallpaper
//
//  Created by MacBook on 16/4/27.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

-(void)homeCollectionWithData:(NSDictionary *)data isType:(int)isType{
    if (isType==0) {
        NSString *imageStr = [data objectForKey:@"url"];
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }else{
        NSString *imageStr = [data objectForKey:@"smallImageUrl"];
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }

}
-(void)TwoHomeCollectionWithData:(NSDictionary *)data{
    NSLog(@"data:%@",data);
    NSString *imageStr = [data objectForKey:@"smallImageUrl"];
    [_titleImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
}
@end
