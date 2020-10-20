//
//  DFLineCellAdapterManager.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFLineCellAdapterManager.h"

@interface DFLineCellAdapterManager()

@property (strong, nonatomic) NSMutableDictionary *dic;

@end



@implementation DFLineCellAdapterManager

static DFLineCellAdapterManager  *_manager=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[DFLineCellAdapterManager alloc] init];
        }
    }
    return _manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dic = [NSMutableDictionary dictionary];
    }
    return self;
}



#pragma mark - Method


-(void) registerAdapter:(LineItemType) itemType adapter:(DFBaseLineCellAdapter *) adapter{
    [_dic setObject:adapter forKey:[NSNumber numberWithInteger:itemType]];
}


-(DFBaseLineCellAdapter *) getAdapter:(LineItemType) itemType
{
    return [_dic objectForKey:[NSNumber numberWithInteger:itemType]];
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com