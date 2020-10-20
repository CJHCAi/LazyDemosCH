//
//  SDGraffitiColorModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDBaseEditPhotoEunmModel.h"

@interface SDGraffitiColorModel : SDBaseEditPhotoEunmModel

@property (nonatomic, strong) UIColor * graffitiColor;

- (instancetype)initWithColor:(UIColor *)graffitiColor;

@end
