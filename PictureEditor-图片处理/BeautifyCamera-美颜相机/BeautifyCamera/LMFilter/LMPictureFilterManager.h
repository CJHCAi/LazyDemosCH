//
//  LMPictureFilterManager.h
//  BeautifyCamera
//
//  Created by sky on 2017/1/25.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMPictureFilterManager : NSObject
+(instancetype)pictureManager;

@property (nonatomic, readonly)NSArray *filters;
@end
