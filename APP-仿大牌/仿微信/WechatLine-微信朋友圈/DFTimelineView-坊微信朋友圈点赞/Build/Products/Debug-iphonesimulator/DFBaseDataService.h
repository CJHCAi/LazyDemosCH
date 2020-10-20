//
//  HCBaseDataService.h
//  Heacha
//
//  Created by Allen Zhong on 15/1/12.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "DFBaseResponse.h"

typedef enum:NSUInteger
{
    DFRequestTypeGet,
    DFRequestTypePost,
    DFRequestTypePostMultipart,
    
}DFRequestType;


typedef void(^ RequestSuccess)(DFBaseResponse *response);

@protocol DFDataServiceDelegate <NSObject>

@optional
-(void) onStatusOk:(DFBaseResponse *)response classType:(Class)classType;
-(void) onStatusError:(DFBaseResponse *)response;
-(void) onRequestError:(NSError *)error;

@end


@interface DFBaseDataService : NSObject

@property (nonatomic,assign) id<DFDataServiceDelegate> delegate;

@property (nonatomic,assign) DFRequestType requestType;

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

-(void) execute;

-(NSString *) getRequestUrl;

-(NSString *) getRequestPath;

-(NSString *) getRequestDomain;


-(void) setRequestParams:(NSMutableDictionary *)params;


-(void) onSuccess:(id)result;
-(void) onError:(NSError *)error;

-(void) parseResponse:(DFBaseResponse *)response;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com