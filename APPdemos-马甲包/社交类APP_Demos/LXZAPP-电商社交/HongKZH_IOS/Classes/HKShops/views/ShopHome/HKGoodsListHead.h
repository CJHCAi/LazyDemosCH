//
//  HKGoodsListHead.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeekMoreGoodsBlock)(void);

@interface HKGoodsListHead : UIView

@property (nonatomic, strong)UILabel *tagLabel;
@property (nonatomic, strong)UIButton * moreBtn;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, copy) SeekMoreGoodsBlock block;
@end
