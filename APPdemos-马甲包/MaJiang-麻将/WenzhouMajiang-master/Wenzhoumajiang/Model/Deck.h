//
//  Deck.h
//  Wenzhoumajiang
//
//  Created by Leixiang Wu on 4/4/14.
//  Copyright (c) 2014 WildCoders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Majiang.h"


@interface Deck : NSObject

- (void)addMajiang:(Majiang *)majiang atTop:(BOOL)atTop;
- (void)addMajiang:(Majiang *)majiang;

- (Majiang *)drawRandomMajiang;

@end
