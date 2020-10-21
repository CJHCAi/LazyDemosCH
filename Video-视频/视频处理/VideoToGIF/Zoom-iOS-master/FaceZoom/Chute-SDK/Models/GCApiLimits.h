//
//  GCApiLimits.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 12/24/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCApiLimits : NSObject

@property (strong, nonatomic) NSNumber *availableMonthlyCalls;
@property (strong, nonatomic) NSNumber *availableHourlyCalls;
@property (strong, nonatomic) NSNumber *maxMonthlyCalls;
@property (strong, nonatomic) NSNumber *maxHourlyCalls;

@end
