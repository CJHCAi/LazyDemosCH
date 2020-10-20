//
//  SDGraffitiToChooseColorView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDCustomControl.h"

@class SDGraffitiSelectedColorModel;


@interface SDGraffitiToChooseColorView : SDCustomControl

@property (nonatomic, strong) SDGraffitiSelectedColorModel * graffitiSelectedColorModel;

@property (nonatomic, strong) UIColor * selected_color;

@end
