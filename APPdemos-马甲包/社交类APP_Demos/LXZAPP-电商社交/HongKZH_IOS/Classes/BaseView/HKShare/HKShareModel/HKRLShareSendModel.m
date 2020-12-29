//
//  HKRLShareSendModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRLShareSendModel.h"
#import "NSArray+Extension.h"
@implementation HKRLShareSendModel
///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}





///将消息内容编码成json
- (NSData *)encode {
    NSArray*array = [NSArray getPropertiesAndSuper:[self class]];
    NSMutableDictionary*dictM = [NSMutableDictionary dictionary];
    for (NSString *keys in array) {
        if (([[self valueForKey:keys] isKindOfClass:[NSString class]]||[[self valueForKey:keys] isKindOfClass:[NSDictionary class]])&&(![[self valueForKey:keys] isKindOfClass:[NSNull class]])&&([self valueForKey:keys] != nil) && (![keys isEqualToString:@"msgText"])) {
            [dictM setValue:[self valueForKey:keys] forKey:keys];
        }
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:&parseError];
    return jsonData;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [[self class] dictionaryWithJsonString: jsonStr];
        
        [self setValuesForKeysWithDictionary:dict];
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return self.title;
}


+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString

{
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err)
        
    {
        
        DLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
-(NSDictionary *)extra{
    if (!_extra) {
        _extra = @{@"uid":HKUSERLOGINID,@"sex":[[LoginUserDataModel getUserInfoItems]sex]?[[LoginUserDataModel getUserInfoItems]sex]:@"1",@"level":[[LoginUserDataModel getUserInfoItems]sex]?[[LoginUserDataModel getUserInfoItems]level]:@"0"};
    
        
    }
    return _extra;
}
-(void)setShareType:(SHARE_Type)shareType{
    _shareType = shareType;
    self.type = [NSString stringWithFormat:@"%d",shareType];
}
@end
