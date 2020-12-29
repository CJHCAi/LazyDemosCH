//
//  LYUserCell.m
//  ITSNS
//
//  Created by Ivan on 16/3/11.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "LYUserCell.h"
#import "UIViewExt.h"
#import <UIImageView+WebCache.h>


@implementation LYUserCell
-(void)awakeFromNib{
    self.unreadCount.layer.cornerRadius = self.unreadCount.width/2;
    self.unreadCount.layer.masksToBounds = YES;
}

-(void)setConversation:(EMConversation *)conversation{
    _conversation = conversation;
    
    //显示未读数量
    if (conversation.unreadMessagesCount>0) {
        self.unreadCount.hidden = NO;
        self.unreadCount.text = @(conversation.unreadMessagesCount).stringValue;
    }else{
        self.unreadCount.hidden = YES;
    }
    
    //查询对方用户的详情
    BmobQuery *query = [BmobQuery queryForUser];
    
    [query whereKey:@"username" equalTo:conversation.chatter];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count>0) {
            BmobUser *user = [array firstObject];
            
            self.nameLabel.text = [user objectForKey:@"nick"];
            
            [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]]];
            
            
            //显示最后一条消息内容
            EMMessage *message =  conversation.latestMessage;
            
            id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
            
            switch ((int)msgBody.messageBodyType) {
                case eMessageBodyType_Text:
                {
                    EMTextMessageBody *msgBody = message.messageBodies.firstObject;
                    
                    self.detailLabel.text = msgBody.text;
                    
                }
                    
                    break;
                    
                case eMessageBodyType_Image:
                {
                    
                    self.detailLabel.text = @"[图片消息]";
                    
                    
                }
                    break;
                case eMessageBodyType_Voice:
                    
                    self.detailLabel.text = @"[语音消息]";
                    break;
            }
            
            
            
        }
        
    }];
    
    
}



-(void)setUser:(BmobUser *)user{
    _user = user;
    self.nameLabel.text = [user objectForKey:@"nick"];
    self.detailLabel.text = user.username;
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]]];
}

@end
