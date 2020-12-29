//
//  TRMessageCell.h
//  ITSNS
//
//  Created by tarena on 16/9/5.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasemobManager.h"
#import <BmobSDK/Bmob.h>
#import "YYTextView.h"
#import "TRVoiceView.h"

@interface TRMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *messageContentView;
@property (weak, nonatomic) IBOutlet UIImageView *paopaoIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (nonatomic, strong)EMMessage *message;
@property (nonatomic, strong)BmobUser *toUser;

@property (nonatomic, strong)YYTextView *textView;
@property (nonatomic, strong)UIImageView *messageIV;
@property (nonatomic, strong)TRVoiceView *voiceView;

@end
