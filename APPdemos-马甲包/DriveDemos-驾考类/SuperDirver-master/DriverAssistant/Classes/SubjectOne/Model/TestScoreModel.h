//
//  TestScoreModel.h
//  DriverAssistant
//
//  Created by C on 16/4/3.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestScoreModel : NSObject
@property (nonatomic, copy) NSString *testTitle;
@property (nonatomic, copy) NSString *testScore;
@property (nonatomic, copy) NSString *correctNum;
@property (nonatomic, copy) NSString *wrongNum;
@property (nonatomic, copy) NSString *undoNum;

@end
