//
//  VideoCollectionCell.h
//  SeeFood
//
//  Created by 纪洪波 on 15/11/25.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *poster;
@property (nonatomic, strong) UILabel *title;
- (void)setValueWithModel:(VideoModel *)model;
@end
