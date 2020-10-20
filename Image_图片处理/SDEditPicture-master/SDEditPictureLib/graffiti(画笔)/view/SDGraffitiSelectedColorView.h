//
//  SDGraffitiSelectedColorView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDCustomControl.h"


@class SDGraffitiColorModel;
@interface SDGraffitiSelectedColorView : SDCustomControl

@property (nonatomic, strong)SDGraffitiColorModel * graffitiColorModel;

- (instancetype)initWithGraffitiColor:(SDGraffitiColorModel *)colorModel;

@end
