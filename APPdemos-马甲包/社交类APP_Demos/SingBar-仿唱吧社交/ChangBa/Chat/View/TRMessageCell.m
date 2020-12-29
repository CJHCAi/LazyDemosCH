//
//  TRMessageCell.m
//  ITSNS
//
//  Created by tarena on 16/9/5.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRMessageCell.h"
#import "UIViewExt.h"
#import <UIImageView+WebCache.h>
#import "Utils.h"

@implementation TRMessageCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.headIV.layer.cornerRadius = self.headIV.width/2;
    self.headIV.layer.masksToBounds = YES;
    
    self.textView = [[YYTextView alloc]initWithFrame:CGRectMake(10, 9, 250, 0)];
    [self.paopaoIV addSubview:self.textView];
    
    self.messageIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 200, 150)];
    [self.paopaoIV addSubview:self.messageIV];
    
    self.voiceView = [[NSBundle mainBundle]loadNibNamed:@"TRVoiceView" owner:self options:nil][0];
    [self.paopaoIV addSubview:self.voiceView];
}

-(void)setMessage:(EMMessage *)message{
    _message = message;

    self.timeLabel.text = [Utils parseTimeWithTimeStap:message.timestamp];
    
    //判断是自己还是对方
    if ([message.from isEqualToString:self.toUser.username]) {//对方发的
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:[self.toUser objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        self.headIV.left = 10;
        
        
        //设置显示对方的气泡
        UIImage *image = [UIImage imageNamed:@"chat_recive_press_pic"];
        //设置图片的拉伸效果
        self.paopaoIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(19, 23, 31, 36) resizingMode:UIImageResizingModeStretch];
        
        
    }else{//自己
        BmobUser *user = [BmobUser currentUser];
        
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        self.headIV.left = [UIScreen mainScreen].bounds.size.width-self.headIV.width-10;
        
        
        //控制显示右边气泡
        UIImage *image = [UIImage imageNamed:@"chat_send_nor_pic"];
        //设置图片的拉伸效果
        self.paopaoIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(33, 25, 18, 20) resizingMode:UIImageResizingModeStretch];
    }
    
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch ((int)msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            //把图片控件和音频隐藏
            self.messageIV.hidden = YES;
            self.voiceView.hidden = YES;
            //把文本控件显示
            self.textView.hidden = NO;
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            //设置最大宽度不超过250
            self.textView.width = 250;
            self.textView.text = txt;
            self.textView.size = self.textView.textLayout.textBoundingSize;
            [Utils faceMappingWithText:self.textView];
            
            self.paopaoIV.size = CGSizeMake(self.textView.width+20, self.textView.height+18);
            if ([message.to isEqualToString:self.toUser.username]) {//自己的
                //显示到右边
                self.paopaoIV.left = [UIScreen mainScreen].bounds.size.width-self.headIV.width-10-self.paopaoIV.width;
            }else{
                //显示到左边
                self.paopaoIV.left = self.headIV.width+10;
            }
        }
            break;
        case eMessageBodyType_Image:
        {
            //文本和音频隐藏
            self.textView.hidden = YES;
            self.voiceView.hidden = YES;
            //图片显示
            self.messageIV.hidden = NO;
            
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            NSLog(@"大图local路径 -- %@"    ,body.localPath);
            
            //让气泡跟着图片变大
            self.paopaoIV.size = CGSizeMake(self.messageIV.width+30, self.messageIV.height+24);
            if ([message.to isEqualToString:self.toUser.username]) {//自己发送的内容
                //如果自己发送的内容图片从local获取
                self.messageIV.image = [UIImage imageWithContentsOfFile:body.localPath];
                //显示到右边
                self.paopaoIV.left = [UIScreen mainScreen].bounds.size.width-self.headIV.width-10-self.paopaoIV.width;

           
            }else{
                //如果是对方发送的 显示远程图片
                [self.messageIV sd_setImageWithURL:[NSURL URLWithString:body.remotePath] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
                //显示到左边
                self.paopaoIV.left = self.headIV.width+10;
            }
            
        }
            break;
        case eMessageBodyType_Voice:
        {
            self.voiceView.hidden = NO;
            self.textView.hidden = YES;
            self.messageIV.hidden = YES;
            
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"音频local路径 -- %@"       ,body.localPath);
            
            //设置显示时间
            self.voiceView.timeLabel.text = [NSString stringWithFormat:@"%ld\"",body.duration];
            
            //设置音频控件的显示坐标
            self.voiceView.origin  = CGPointMake(15, 12);
            self.paopaoIV.size = CGSizeMake(60+30, 25+24);
            if ([message.to isEqualToString:self.toUser.username]) {//自己发送的内容
                [self.voiceView changeLocation:YES];
                //显示到右边
                self.paopaoIV.left = [UIScreen mainScreen].bounds.size.width-self.headIV.width-10-self.paopaoIV.width;
                
            }else{
                [self.voiceView changeLocation:NO];
                //显示到左边
                self.paopaoIV.left = [UIScreen mainScreen].bounds.size.width-self.headIV.width-10-self.paopaoIV.width;
            }
            
        }
            break;
            
    }

}

@end
