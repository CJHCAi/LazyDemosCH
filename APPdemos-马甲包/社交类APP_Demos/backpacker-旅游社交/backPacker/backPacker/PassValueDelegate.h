//
//  PassValueDelegate.h
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-6.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PassValueDelegate <NSObject>
@optional
-(void)setvalue:(NSString *)value senderTag:(NSString *)senderTag;
@end
