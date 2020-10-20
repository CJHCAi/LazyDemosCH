//
//  SDFilterImageCollectionViewCell.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/24.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseEditImageCollectionViewCell.h"

@class SDFilterFunctionModel;

@interface SDFilterImageCollectionViewCell : SDBaseEditImageCollectionViewCell

@property (nonatomic, weak) UIView * theFilterBgContentView;

@property (nonatomic, weak) UIImageView * theFilterImageView;

@property (nonatomic, weak) UILabel * theFilterTitleLabel;


@property (nonatomic, strong) SDFilterFunctionModel * filterModel;


- (void)loadFilterModel:(SDFilterFunctionModel * )model;

@end
