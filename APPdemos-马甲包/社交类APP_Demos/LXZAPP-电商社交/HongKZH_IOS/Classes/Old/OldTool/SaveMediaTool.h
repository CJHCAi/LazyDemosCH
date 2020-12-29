//
//  SaveMediaTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveMediaTool : NSObject

//保存图片
+ (BOOL)saveImgSrcWithImageName:(NSString *)imgName image:(UIImage *)image;

+ (UIImage *)getImgWithImageName:(NSString *)imgName;

@end
