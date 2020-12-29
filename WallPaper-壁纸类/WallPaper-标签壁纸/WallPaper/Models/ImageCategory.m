//
//  ImageCategory.m
//  WallPaper
//
//  Created by Never on 2017/2/9.
//  Copyright © 2017年 Never. All rights reserved.
//

#import "ImageCategory.h"

@implementation ImageCategory

+(instancetype)categoryWithName:(NSString *)name thumbnail:(NSURL *)thumbnail{
    
    ImageCategory *category = [[self alloc] init];
    category.name = name;
//    category.data = data;
    category.thumbnail = thumbnail;
    return category;
    
}

@end
