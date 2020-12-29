//
//  RecommendCollectionViewCell.h
//  RabbitWallpaper
//
//  Created by MacBook on 16/4/29.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)RecommendCollectionWithData:(NSDictionary *)data;

@end
