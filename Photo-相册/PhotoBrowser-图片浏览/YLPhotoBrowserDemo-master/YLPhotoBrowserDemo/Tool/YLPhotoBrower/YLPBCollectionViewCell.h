//
//  YLPBCollectionViewCell.h
//  SportChina
//
//  Created by 杨磊 on 2018/3/20.
//  Copyright © 2018年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^voidBlock)(void);

@class WaterfallModel;

@interface YLPBCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSString *model;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;//双击
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;//单击
@property (nonatomic,  copy) voidBlock click;
@end
