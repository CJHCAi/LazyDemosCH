//
//  LeftMenuModel.h
//  shoppingcentre
//
//  Created by Wondergirl on 16/6/19.
//  Copyright © 2016年 Wondergirl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftMenuModel : NSObject
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *name;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)leftmenuWithDict:(NSDictionary *)dict;


@end
