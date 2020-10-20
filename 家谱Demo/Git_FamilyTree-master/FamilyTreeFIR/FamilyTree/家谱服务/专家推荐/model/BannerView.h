//
//  BannerView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/8/9.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

@interface BannerView : UIView
/** 图片数组*/
@property (nonatomic, strong) NSArray<BannerModel *> *modelArr;
/** 图片文字数组*/
@property (nonatomic, strong) NSArray<NSString *> *imageArr;
@end
