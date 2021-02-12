//
//  WenzhouMajiangDeck.m
//  Wenzhoumajiang
//
//  Created by Leixiang Wu on 4/5/14.
//  Copyright (c) 2014 WildCoders. All rights reserved.
//

#import "WenzhouMajiangDeck.h"
#import "WenzhouMajiang.h"


@implementation WenzhouMajiangDeck

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        for (NSString *suit in [WenzhouMajiang validSuits])
        {
            if ([suit isEqualToString:@"bamboo"])
            {
                for (NSString * rank in [WenzhouMajiang validBambooRank])
                {
                    WenzhouMajiang *majiang = [[WenzhouMajiang alloc] init];
                    majiang.rank = rank;
                    majiang.suit = suit;
                }
            }
        }
        
        for (NSString *suit in [WenzhouMajiang validBambooRank])
        {
            
            
        }
        
        for (NSString *suit in [WenzhouMajiang validBambooRank])
        {
            
            
        }
        
        
        for (NSString *suit in [WenzhouMajiang validBambooRank])
        {
            
            
        }
        
        
        for (NSString *suit in [WenzhouMajiang validBambooRank])
        {
            
            
        }
    }

    return self;
}

@end
