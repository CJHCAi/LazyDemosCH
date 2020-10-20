//
//  SDDecorateEditItemsCollectionViewCell.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDBaseEditImageCollectionViewCell.h"

@class SDDecorateFunctionModel;

@interface SDDecorateEditItemsCollectionViewCell : SDBaseEditImageCollectionViewCell

@property (nonatomic, strong) SDDecorateFunctionModel * decorateModel;

@property (nonatomic, weak) UILabel * theResetLabel;

@property (nonatomic, weak) UIView * theLabelBgView;

@property (nonatomic, weak) UIView * theBgContentView;

@property (nonatomic, weak) UIImageView * theShowImageView;

- (void)loadDecorateModel:(SDDecorateFunctionModel * )model;

@end
