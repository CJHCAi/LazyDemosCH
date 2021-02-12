//
//  Player.h
//  MaJiang
//
//  Created by yu_hao on 1/7/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property BOOL online;
@property BOOL jiao;
@property int pointsForAction;
@property int points;
@property NSString *name;
@property NSString *displayName;

@end
