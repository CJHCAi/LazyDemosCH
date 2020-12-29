//
//  VideoView.h
//  XMPP
//
//  Created by 纪洪波 on 15/11/21.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoView : UIView
@property (strong, nonatomic) UIButton *changeViewButton;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIImageView *backImage;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UILabel *like;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UILabel *title;

- (void)setValueWithVideoModel:(VideoModel *)model;
@end
