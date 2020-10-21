//
//  VideoModel.m
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/17.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.poster forKey:@"poster"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.memorySize forKey:@"memorySize"];
    [aCoder encodeObject:self.path forKey:@"path"];
}
//解档
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]){
        
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.poster = [aDecoder decodeObjectForKey:@"poster"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.duration = [aDecoder decodeObjectForKey:@"duration"];
        self.memorySize = [aDecoder decodeObjectForKey:@"memorySize"];
        self.path = [aDecoder decodeObjectForKey:@"path"];
    }
    return self;
}

@end
