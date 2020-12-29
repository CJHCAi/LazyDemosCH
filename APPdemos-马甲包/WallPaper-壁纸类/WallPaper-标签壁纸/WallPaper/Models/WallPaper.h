//
//  WallPaper.h
//  WallPaper
//
//  Created by Never on 2017/2/10.
//  Copyright © 2017年 Never. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WallPaper : NSObject

@property (nonatomic, strong) NSURL *detail;
@property (nonatomic, strong) NSURL *thumbnail;
@property (nonatomic, strong) NSURL *fullSize;

@end
