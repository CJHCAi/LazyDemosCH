//
//  XMGNewFeatureCell.h
//  小码哥彩票
//
//  Created by xiaomage on 15/6/30.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGNewFeatureCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;

/**判断是否是最后一个Item*/
- (void)setUpIndexPath:(NSIndexPath *)indexPath count:(NSInteger)pagesCount;

@end
