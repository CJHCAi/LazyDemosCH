//
//  RemoteImgListOperator.m
//  RemoteImgListOperatorDemo
//
//  Created by jimple on 14-1-7.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "RemoteImgListOperator.h"
#import "RemoteImgOperator.h"

#define STR_ListElementURL                  @"ImgURL"
#define STR_ListElementRequest              @"HTTPRequest"
#define INT_DefaultListSize                 10


@interface RemoteImgListOperator ()
<
    RemoteImgOperatorDelegate
>

@property (nonatomic, readonly) dispatch_queue_t m_queueRemoteImgOper;
@property (nonatomic, readonly) NSMutableArray *m_arrRemoteImgOper;
@property (nonatomic, readonly) NSInteger m_iListSize;

@end

@implementation RemoteImgListOperator
@synthesize m_strSuccNotificationName = _strSuccNotificationName;
@synthesize m_strFailedNotificationName = _strFailedNotificationName;
@synthesize m_queueRemoteImgOper = _queueRemoteImgOper;
@synthesize m_arrRemoteImgOper = _arrRemoteImgOper;
@synthesize m_iListSize = _iListSize;

- (id)init
{
    self = [super init];
    if (self)
    {
        static int s_iOjbTag = 0;
        s_iOjbTag++;
        
        _queueRemoteImgOper = dispatch_queue_create("com.company.app.remoteImgOperList", NULL);
        _arrRemoteImgOper = [[NSMutableArray alloc] init];
        
        _strSuccNotificationName = [NSString stringWithFormat:@"RemoteImgOperListSucc%d", s_iOjbTag];
        _strFailedNotificationName = [NSString stringWithFormat:@"RemoteImgOperListFailed%d", s_iOjbTag];
        
        _iListSize = INT_DefaultListSize;
    }else{}
    return self;
}

- (void)dealloc
{
    dispatch_sync(_queueRemoteImgOper, ^{
        for (NSDictionary *dicItem in _arrRemoteImgOper)
        {
            RemoteImgOperator *objOper = [dicItem objectForKey:STR_ListElementRequest];
            if (objOper)
            {
                [objOper setProgressDelegate:nil];
                [objOper cancelRequest];
            }else{}
        }
        
        [_arrRemoteImgOper removeAllObjects];
    });
    
    _queueRemoteImgOper = nil;
}

// 设置列表最大长度
- (void)resetListSize:(NSInteger)iSize
{
    dispatch_sync(_queueRemoteImgOper, ^{
        _iListSize = (iSize > 0) ? iSize : INT_DefaultListSize;
    });
}

// 从网路下载图片
- (void)getRemoteImgByURL:(NSString *)strURL
{
    [self getRemoteImgByURL:strURL withProgress:nil];
}

// 从网络下载图片，带进度条delegate
// 进度条delegate方法： - (void)setProgress:(float)newProgress;
- (void)getRemoteImgByURL:(NSString *)strURL withProgress:(id)progress
{
    if (strURL && strURL.length > 0)
    {
        __block NSString *strBlockURL = [strURL copy];
        __weak id progressBlock = progress;
        
        dispatch_sync(_queueRemoteImgOper, ^{
            BOOL bIsRequesting = NO;
            for (NSDictionary *dicItem in _arrRemoteImgOper)
            {
                NSString *strElementURL = [dicItem objectForKey:STR_ListElementURL];
                if (strElementURL && [strElementURL isEqualToString:strBlockURL])
                {
                    RemoteImgOperator *objImgOper = [dicItem objectForKey:STR_ListElementRequest];
                    
                    if (progressBlock)
                    {
                        [objImgOper setProgressDelegate:progressBlock];
                    }else{}
                    
                    bIsRequesting = YES;
                    break;          // break loop
                }else{}
            }
            
            if (!bIsRequesting)
            {
                RemoteImgOperator *objImgOper = [[RemoteImgOperator alloc] init];
                [objImgOper setDelegate:self];
                NSMutableDictionary *dicElement = [[NSMutableDictionary alloc] init];
                [dicElement setObject:[strBlockURL copy] forKey:STR_ListElementURL];
                [dicElement setObject:objImgOper forKey:STR_ListElementRequest];
                [_arrRemoteImgOper addObject:dicElement];
                
                [objImgOper getRemoteImgFromURL:strBlockURL progressDelegate:progressBlock];
                
                if (_arrRemoteImgOper && _arrRemoteImgOper.count > _iListSize)
                {// 列表满，取消第一个的下载并推出。
                    NSDictionary *dicFirst = [_arrRemoteImgOper objectAtIndex:0];
                    if (dicFirst)
                    {
                        RemoteImgOperator *objOper = [dicFirst objectForKey:STR_ListElementRequest];
                        if (objOper)
                        {
                            [objOper cancelRequest];
                            objOper = nil;
                        }else{}
                    }else{}
                    [_arrRemoteImgOper removeObjectAtIndex:0];
                }else{}
            }else{}
        });
    }else{}
}

- (void)removeRemoteOperFromListByURL:(NSString *)strURL
{
    dispatch_sync(_queueRemoteImgOper, ^{
        for (NSDictionary *dicItem in _arrRemoteImgOper)
        {
            NSString *strElementURL = [dicItem objectForKey:STR_ListElementURL];
            if (strElementURL && [strElementURL isEqualToString:strURL])
            {
                RemoteImgOperator *objImgOper = [dicItem objectForKey:STR_ListElementRequest];
                [objImgOper setProgressDelegate:nil];
                [objImgOper cancelRequest];
                [_arrRemoteImgOper removeObject:dicItem];
                break;          // break loop
            }else{}
        }
    });
}

- (void)removeAllProgressDelegate
{
    dispatch_sync(_queueRemoteImgOper, ^{
        for (NSDictionary *dicItem in _arrRemoteImgOper)
        {
            RemoteImgOperator *objOper = [dicItem objectForKey:STR_ListElementRequest];
            if (objOper)
            {
                [objOper setProgressDelegate:nil];
            }else{}
        }
    });
}

// 移除正在使用的进度条delegate
- (void)removeProgressDelegate:(id)progress
{
    if (progress)
    {
        dispatch_sync(_queueRemoteImgOper, ^{
            for (NSDictionary *dicItem in _arrRemoteImgOper)
            {
                RemoteImgOperator *objOper = [dicItem objectForKey:STR_ListElementRequest];
                if (objOper && (progress == [objOper getProgressDelegate]))
                {
                    [objOper setProgressDelegate:nil];
                }else{}
            }
        });
    }else{}
}

#pragma mark - RemoteImgOperator delegate
- (void)remoteImgOper:(RemoteImgOperator *)oper getImgSucc:(NSData *)dataImg fromURL:(NSString *)strURL
{
    @try
    {
        if (dataImg && strURL)
        {
            NSDictionary *dicImg2Data = [NSDictionary dictionaryWithObjectsAndKeys:dataImg, strURL, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:_strSuccNotificationName object:nil userInfo:dicImg2Data];
            
//// 将图片数据保存到文件或本地缓存中
//            __block NSString *strBlockURL = [strURL copy];
//            __block NSData *dataBlockImg = dataImg;
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    
//                    // ...
//                });
//            });
        }else{}
        
        [self removeRemoteOperFromListByURL:strURL];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
    }
}

- (void)remoteImgOper:(RemoteImgOperator *)oper getImgFailedFromURL:(NSString *)strURL
{
    // 先从队列里删除，再发notifi，因为有可能外部收到通知后立即重新入栈再获取一次。
    [self removeRemoteOperFromListByURL:strURL];
    
    NSDictionary *dicImg2Data = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], strURL, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:_strFailedNotificationName object:nil userInfo:dicImg2Data];
    
}
















@end
