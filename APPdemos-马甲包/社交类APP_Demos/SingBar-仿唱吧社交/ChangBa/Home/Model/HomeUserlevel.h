//
//  HomeUserlevel.h
//
//  Created by   on 16/9/22
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HomeUserlevel : NSObject 

@property (nonatomic, assign) double monthPop;
@property (nonatomic, assign) double weekCost;
@property (nonatomic, assign) double cost;
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
@property (nonatomic, strong) NSString *richRank;



@end
