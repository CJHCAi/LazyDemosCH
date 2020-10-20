//
//  AppFileComment.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppFileComment : NSObject

+ (NSString * )imagePathStringWithImagename:(NSString * )imageName;

+ (NSString * )imagePathStringWithImagename:(NSString *)imageName imageType:(NSString *)imageType;

@end
