//
//  XMShareWeiboUtil.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareWeiboUtil.h"

@implementation XMShareWeiboUtil

- (void)shareToWeibo
{
    
    [self shareToWeiboBase];
    
}

- (void)shareToWeiboBase
{
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = APP_KEY_WEIBO_RedirectURL;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:nil];
    
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    //一个消息结构由三部分组成：文字、图片和多媒体数据。三部分内容中至少有一项不为空，图片和多媒体数据不能共存。
    WBMessageObject *message = [WBMessageObject message];
    //判断是否安装了微博客户端
    BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]];
    
    if(hadInstalledWeibo){
        //消息的多媒体内容
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = self.shareTitle;
        webpage.description = self.shareText;
        //  可改为自定义图片
//        webpage.thumbnailData = UIImageJPEGRepresentation(SHARE_IMG, SHARE_IMG_COMPRESSION_QUALITY);
        webpage.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImgUrl]];
        webpage.webpageUrl = self.shareUrl;
//        message.mediaObject = webpage;
        
        /** 消息多媒体与消息图片不能共存 */
        //消息图片内容
        WBImageObject *imageObj = [WBImageObject object];
        imageObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImgUrl]];
        message.imageObject = imageObj;

    }
    
    message.text = [NSString stringWithFormat:@"#%@#\n%@\n%@", self.shareTitle, self.shareText, self.shareUrl];
    
    return message;
    
}


+ (instancetype)sharedInstance
{
    
    static XMShareWeiboUtil* util;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        util = [[XMShareWeiboUtil alloc] init];
        
    });
    return util;
    
}

- (instancetype)init
{
    
    static id obj=nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        obj = [super init];
        if (obj) {
            
        }
        
    });
    self=obj;
    return self;
    
}

@end
