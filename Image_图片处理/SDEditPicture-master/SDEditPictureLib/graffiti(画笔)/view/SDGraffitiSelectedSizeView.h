//
//  SDGraffitiSelectedSizeView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCustomControl.h"
@class SDGraffitiSizeModel;
@interface SDGraffitiSelectedSizeView : SDCustomControl

@property (nonatomic, weak) UIView * theSizeView;

@property (nonatomic, strong) SDGraffitiSizeModel * graffitiSizeModel;

@property (nonatomic, strong) UIColor * graffitiColor;

// 是不是橡皮擦
@property (nonatomic, assign) BOOL isErearseModel;

- (instancetype)initWithSizeModel:(SDGraffitiSizeModel *)sizeModel;

@end
