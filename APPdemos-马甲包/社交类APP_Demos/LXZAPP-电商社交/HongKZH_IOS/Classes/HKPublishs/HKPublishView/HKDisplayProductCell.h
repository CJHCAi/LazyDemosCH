//
//  HKDisplayProductCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BuyBoothBlock)(void);
typedef void(^GotoUserProductBlock)(void);

@interface HKDisplayProductCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *selectedItems;

@property (nonatomic, assign) NSInteger boothCount; //展位个数

@property (nonatomic, copy) BuyBoothBlock buyBoothBlock;

@property (nonatomic, copy) GotoUserProductBlock gotoUserProductBlock;

@end


@interface HKDisplayProductInnerCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *productImageView;

@end
