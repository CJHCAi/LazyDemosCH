//
//  HomeResult.h
//
//  Created by   on 16/9/22
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeWork.h"

@interface HomeResult : NSObject 
@property (nonatomic, strong) HomeWork *work;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, assign) double feedid;
@property (nonatomic, assign) double type;



@end
