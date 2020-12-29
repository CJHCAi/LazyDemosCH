//
//  TRVoiceView.m
//  ITSNS
//
//  Created by tarena on 16/7/6.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRVoiceView.h"

@implementation TRVoiceView

-(void)awakeFromNib{
    
    self.imageView.animationImages = @[[UIImage imageNamed:@"chat_receiver_audio_playing000"],[UIImage imageNamed:@"chat_receiver_audio_playing001"],[UIImage imageNamed:@"chat_receiver_audio_playing002"],[UIImage imageNamed:@"chat_receiver_audio_playing003"],[UIImage imageNamed:@"chat_receiver_audio_playing_full"],];
    
}

-(void)beginAnimation{
    //动画持续时间
    self.imageView.animationDuration = 1;
    
    //设置重复次数
    self.imageView.animationRepeatCount = self.timeLabel.text.intValue;
    
    
    [self.imageView startAnimating];
    
}

-(void)changeLocation:(BOOL)isSelf{
 
    if (isSelf) {
        //让图片
        self.imageView.transform = CGAffineTransformMakeTranslation(20, 0);
         self.timeLabel.transform = CGAffineTransformMakeTranslation(-20, 0);
        
        //让图片旋转180
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
       
    }else{
        
        //还原
        self.imageView.transform = CGAffineTransformIdentity;
        self.timeLabel.transform = CGAffineTransformIdentity;
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
