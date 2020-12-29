//
//  HomeCollectionViewCell.h
//  RabbitWallpaper
//
//  Created by MacBook on 16/4/27.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

-(void)homeCollectionWithData:(NSDictionary *)data isType:(int )isType;

-(void)TwoHomeCollectionWithData:(NSDictionary *)data;
@end
