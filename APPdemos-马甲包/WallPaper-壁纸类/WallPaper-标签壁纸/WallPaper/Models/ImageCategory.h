//
//  ImageCategory.h
//  WallPaper
//
//  Created by Never on 2017/2/9.
//  Copyright © 2017年 Never. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCategory : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSURL *data;
@property(nonatomic,strong) NSURL *thumbnail;

+ (instancetype)categoryWithName:(NSString *)name thumbnail:(NSURL *)thumbnail;

@end
