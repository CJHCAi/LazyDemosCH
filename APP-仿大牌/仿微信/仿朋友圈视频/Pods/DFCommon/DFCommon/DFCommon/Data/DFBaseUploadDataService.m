//
//  DFBaseUploadDataService.m
//  coder
//
//  Created by Allen Zhong on 15/5/22.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseUploadDataService.h"

@implementation DFBaseUploadDataService


-(void)executeRequest
{
    
}


-(void) upload:(NSData *) data success:(RequestSuccess) success
{
    if (data == nil) {
        return;
    }
    
    [self execute];
    
    [self.manager POST:[self getRequestUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"test.%@",[self getFileType]] mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (responseObject) {
            DFBaseResponse *response =  [[DFBaseResponse alloc] initWithData:responseObject];
            
            if (response.status == 1) {
                
                [self parseResponse:response];
                
                success(response);
                
            }else{
                if (self.delegate && [self.delegate conformsToProtocol:@protocol(DFDataServiceDelegate)] && [self.delegate respondsToSelector:@selector(onStatusError:)]) {
                    
                    if (response.errorMsg == nil) {
                        response.errorMsg = @"出错啦!";
                    }
                    
                    [self.delegate onStatusError:response];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onError:error];
    }];
    
}

-(NSString *)getFileType
{
    return @"";
}
@end
