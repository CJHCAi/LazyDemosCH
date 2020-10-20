//
//  SDGraffitiSizeModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDBaseEditPhotoEunmModel.h"

@interface SDGraffitiSizeModel : SDBaseEditPhotoEunmModel

@property (nonatomic, assign)CGFloat graffitiSize;

@property (nonatomic, strong) UIColor * graffitiColor;

@property (nonatomic, assign) BOOL isEraser; // 判断是不是橡皮擦，define false;


- (instancetype)initWithSize:(CGFloat)graffitiSize;


- (void)defineGraffitiColor;


@end
