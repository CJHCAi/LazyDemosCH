//
//  WaterfallColectionLayout.h
//  WaterfallCollectionLayout
//
//  Created by ci123 on 16/1/26.
//  Copyright © 2016年 tanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  CGFloat(^itemHeightBlock)(NSIndexPath* index);
@interface WaterfallColectionLayout : UICollectionViewLayout
@property(nonatomic,strong )itemHeightBlock heightBlock ;

-(instancetype)initWithItemsHeightBlock:(itemHeightBlock)block;
@end
