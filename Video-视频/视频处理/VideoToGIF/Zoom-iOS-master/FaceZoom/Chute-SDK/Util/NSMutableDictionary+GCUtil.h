//
//  NSDictionary+GCUtil.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 12/27/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (GCUtil)

- (void)setObjectIfExists:(id)obj forKey:(id)key;

@end
