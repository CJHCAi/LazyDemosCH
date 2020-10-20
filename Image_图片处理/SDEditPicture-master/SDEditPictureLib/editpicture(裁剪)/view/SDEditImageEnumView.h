//
//  SDEditImageEnumView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDEditImageEnumModel;

@interface SDEditImageEnumView : UIView

@property (nonatomic, strong) SDEditImageEnumModel * editModel;

@property (nonatomic, weak) UIImageView * showIconImageView;

@property (nonatomic, weak) UILabel * showEnumLabel;


- (instancetype)initWithEditEnumModel:(SDEditImageEnumModel *)model withSize:(CGSize)size;
@end
