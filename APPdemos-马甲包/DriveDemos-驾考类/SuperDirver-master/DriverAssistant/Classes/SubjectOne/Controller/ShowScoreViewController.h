//
//  ShowScoreViewController.h
//  DriverAssistant
//
//  Created by C on 16/4/3.
//  Copyright © 2016年 C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestScoreModel.h"
@interface ShowScoreViewController : UIViewController
@property (nonatomic, strong) TestScoreModel *testScoreModel;
- (instancetype)initWithTestScoreModel:(TestScoreModel *)testScoreModel;
@end
