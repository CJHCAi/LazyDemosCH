//
//  DFTextVideoLineItem.m
//  DFTimelineView
//
//  Created by CaptainTong on 15/11/13.
//  Copyright © 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextVideoLineItem.h"

@implementation DFTextVideoLineItem

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.itemType = LineItemTypeTextVideo;
        _videoUrl=@"";
        _text = @"";
        
    }
    return self;
}

@end
