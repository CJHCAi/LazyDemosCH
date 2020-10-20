//
//  AppFileComment.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "AppFileComment.h"

@implementation AppFileComment
+ (NSString * )imagePathStringWithImagename:(NSString * )imageName
{
    NSString * bundle_path_string = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"bundle"];
    NSString * image_path_string = [[NSBundle bundleWithPath:bundle_path_string] pathForResource:imageName ofType:@"png"];
    return image_path_string;
}

+ (NSString * )imagePathStringWithImagename:(NSString *)imageName imageType:(NSString *)imageType
{
    NSString * bundle_path_string = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"bundle"];
    NSString * image_path_string = [[NSBundle bundleWithPath:bundle_path_string] pathForResource:imageName ofType:imageType];
    return image_path_string;
}

@end
