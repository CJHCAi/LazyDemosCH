//
//  PerformanceUserlevel.h
//
//  Created by   on 16/9/23
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PerformanceUserlevel : NSObject 
@property (nonatomic, assign) double monthPop;
@property (nonatomic, assign) double weekCost;
@property (nonatomic, strong) NSString *richRank;
@property (nonatomic, strong) NSString *starRank;
@property (nonatomic, strong) NSString *starLevel;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *starLevelName;
@property (nonatomic, assign) double nextStarLevel;
@property (nonatomic, strong) NSString *richLevelName;
@property (nonatomic, strong) NSString *richLevel;
@property (nonatomic, assign) double nextRichLevel;
@property (nonatomic, assign) double monthCost;
@property (nonatomic, assign) double pop;
@property (nonatomic, assign) double cost;


@end
