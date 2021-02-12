//
//  WenzhouMajiang.h
//  Wenzhoumajiang
//
//  Created by Leixiang Wu on 4/5/14.
//  Copyright (c) 2014 WildCoders. All rights reserved.
//

#import "Majiang.h"

@interface WenzhouMajiang : Majiang

@property (nonatomic, strong) NSString *suit;
@property (nonatomic, strong) NSString *rank;

+ (NSArray *)validSuits;
+ (NSArray *)validWindRank;
+ (NSArray *)validDragonRank;
+ (NSArray *)validCircleRank;
+ (NSArray *)validCharacterRank;
+ (NSArray *)validBambooRank;


@end
