//
//  TBAuthParam.h
//  TBAppLinkSDK
//
//  Created by muhuai on 15/9/3.
//  Copyright (c) 2015年 MuHuai. All rights reserved.
//

#import "TBBasicParam.h"

@interface TBAuthParam : TBBasicParam

/**
 *  H5授权页的回调地址
 */
@property (nonatomic, strong)NSString *redirectURI;

- (instancetype)initWithRedirectURI:(NSString *)redirectURI;

@end
