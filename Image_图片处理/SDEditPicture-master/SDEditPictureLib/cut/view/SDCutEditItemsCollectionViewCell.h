//
//  SDCutEditItemsCollectionViewCell.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDBaseEditImageCollectionViewCell.h"
@class SDCutFunctionModel;
@interface SDCutEditItemsCollectionViewCell : SDBaseEditImageCollectionViewCell

@property (nonatomic, weak) SDCutFunctionModel * cutModel;




/**
 加载 剪切 模块数据
 */
- (void)loadCutFunctionModel:(SDCutFunctionModel * )model;


@end
