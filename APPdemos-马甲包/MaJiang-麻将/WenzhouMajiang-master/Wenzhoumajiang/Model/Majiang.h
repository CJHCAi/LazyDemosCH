//
//  Majiang.h
//  Wenzhoumajiang
//
//  Created by Leixiang Wu on 4/4/14.
//  Copyright (c) 2014 WildCoders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Majiang : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;

- (BOOL)match:(NSArray *)otherMajiangs;






@end

