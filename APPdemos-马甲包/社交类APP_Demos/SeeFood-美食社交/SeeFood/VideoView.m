//
//  VideoView.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/21.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "VideoView.h"
#import <UIImageView+WebCache.h>
#import "PrefixHeader.pch"
#import "UIView+UIView_Frame.h"

@interface VideoView ()
@property (strong, nonatomic) UIImageView *poster;
@property (strong, nonatomic) UIView *whiteback;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *difficulty;
@property (strong, nonatomic) NSString *videoURL;
@property (strong, nonatomic) NSString *posterURL;
@end

@implementation VideoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
//    self.backgroundColor = [UIColor whiteColor];
    _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _backImage.userInteractionEnabled = YES;
    [self addSubview:_backImage];
    
    _poster = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 50, KScreenHeight - 250)];
    _poster.contentMode = UIViewContentModeScaleAspectFill;
    _poster.center = CGPointMake(KScreenWidth / 2, _poster.height / 2 + 70);
    _poster.userInteractionEnabled = YES;
    [self addSubview:_poster];
    
    //添加四个边阴影
    _poster.layer.shadowColor = [UIColor blackColor].CGColor;
    _poster.layer.shadowOffset = CGSizeMake(0, 0);
    _poster.layer.shadowOpacity = 0.5;
    _poster.layer.shadowRadius = 10.0;
    
    _date = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, 50)];
    _date.text = @"NOV 12";
    _date.textAlignment = NSTextAlignmentCenter;
    _date.font = [UIFont systemFontOfSize:22];
    _date.textColor = [UIColor whiteColor];
    [_backImage addSubview:_date];
    
    UIImageView *black = [[UIImageView alloc]initWithFrame:CGRectMake(0, _poster.height - 70, _poster.width, 70)];
    black.image = [UIImage imageNamed:@"Black"];
    [_poster addSubview:black];
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(0, black.height - 50, black.width, 50)];
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:20];
    [black addSubview:_title];
    
    _whiteback = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 50, KScreenHeight / 7)];
    _whiteback.center = CGPointMake(KScreenWidth / 2, _poster.y + _poster.height + KScreenHeight / 7 / 2);
    _whiteback.userInteractionEnabled = YES;
    _whiteback.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteback];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, _whiteback.height - 6)];
    view1.center = CGPointMake(_whiteback.width / 3, _whiteback.height / 2);
    view1.backgroundColor = [UIColor grayColor];
    [_whiteback addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, _whiteback.height - 6)];
    view2.center = CGPointMake(_whiteback.width / 3 * 2, _whiteback.height / 2);
    view2.backgroundColor = [UIColor grayColor];
    [_whiteback addSubview:view2];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(0, 0, KScreenWidth / 6.4, KScreenWidth / 6.4);
    _playButton.center = CGPointMake(_poster.width / 2, _poster.height / 2);
    [_playButton setBackgroundImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    [_poster addSubview:_playButton];
    
    CGFloat dis = (_whiteback.width - (_whiteback.height - 10) * 3) / 6;
    UIView *square1 = [[UIView alloc]initWithFrame:CGRectMake(dis, 10 / 2, _whiteback.height - 10, _whiteback.height - 10)];
    [_whiteback addSubview:square1];
    
    UILabel *timeTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, square1.width, _whiteback.height / 4)];
    timeTitle.text = @"Time";
    timeTitle.font = [UIFont systemFontOfSize:timeTitle.height / 1.2];
    timeTitle.textAlignment = NSTextAlignmentCenter;
    [square1 addSubview:timeTitle];
    
    _time = [[UILabel alloc]initWithFrame:CGRectMake(0, timeTitle.height, square1.width, square1.height - timeTitle.height * 2)];
    _time.text = @"45";
    _time.font = [UIFont systemFontOfSize:_time.height / 1.2];
    _time.textAlignment = NSTextAlignmentCenter;
    [square1 addSubview:_time];
    
    UILabel *timeUnit = [[UILabel alloc]initWithFrame:CGRectMake(0, square1.height - timeTitle.height, square1.width, timeTitle.height)];
    timeUnit.text = @"Minutes";
    timeUnit.font = [UIFont systemFontOfSize:timeUnit.height / 1.2];
    timeUnit.textAlignment = NSTextAlignmentCenter;
    [square1 addSubview:timeUnit];
    
    UIView *square2 = [[UIView alloc]initWithFrame:CGRectMake(dis * 3 + _whiteback.height - 10, 10 / 2, _whiteback.height - 10, _whiteback.height - 10)];
    [_whiteback addSubview:square2];
    
    UILabel *dificoultyTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, square1.width, timeTitle.height)];
    dificoultyTitle.text = @"Dificoulty";
    dificoultyTitle.font = [UIFont systemFontOfSize:dificoultyTitle.height / 1.3];
    dificoultyTitle.textAlignment = NSTextAlignmentCenter;
    [square2 addSubview:dificoultyTitle];
    
    UILabel *dificoulty = [[UILabel alloc]initWithFrame:CGRectMake(0, dificoultyTitle.height, square1.width, square1.height - dificoultyTitle.height * 2)];
    dificoulty.text = @"8";
    dificoulty.font = [UIFont systemFontOfSize:dificoulty.height / 1.2];
    dificoulty.textAlignment = NSTextAlignmentCenter;
    [square2 addSubview:dificoulty];
    
    UILabel *dificoultyUnit = [[UILabel alloc]initWithFrame:CGRectMake(0, square1.height - dificoultyTitle.height, square1.width, dificoultyTitle.height)];
    dificoultyUnit.text = @"Degree";
    dificoultyUnit.font = [UIFont systemFontOfSize:dificoultyUnit.height / 1.2];
    dificoultyUnit.textAlignment = NSTextAlignmentCenter;
    [square2 addSubview:dificoultyUnit];
    
    UIView *square3 = [[UIView alloc]initWithFrame:CGRectMake(dis * 5 + (_whiteback.height - 10) * 2, 10 / 2, _whiteback.height - 10, _whiteback.height - 10)];
    square3.userInteractionEnabled = YES;
    [_whiteback addSubview:square3];
    
    UILabel *likeTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, square1.width, timeTitle.height)];
    likeTitle.text = @"Like";
    likeTitle.font = [UIFont systemFontOfSize:likeTitle.height / 1.2];
    likeTitle.textAlignment = NSTextAlignmentCenter;
    [square3 addSubview:likeTitle];
    
    _like = [[UILabel alloc]initWithFrame:CGRectMake(0, likeTitle.height, square1.width, square1.height - likeTitle.height * 2)];
    _like.font = [UIFont systemFontOfSize:_like.height / 1.2];
    _like.textAlignment = NSTextAlignmentCenter;
    [square3 addSubview:_like];
    
    UILabel *likeUnit = [[UILabel alloc]initWithFrame:CGRectMake(0, square1.height - likeTitle.height, square1.width, likeTitle.height)];
    likeUnit.text = @"Degree";
    likeUnit.font = [UIFont systemFontOfSize:likeUnit.height / 1.2];
    likeUnit.textAlignment = NSTextAlignmentCenter;
    [square3 addSubview:likeUnit];
    
    UIView *hideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _poster.width, 8)];
    hideView.center = CGPointMake(KScreenWidth / 2, _whiteback.y);
    hideView.backgroundColor = [UIColor whiteColor];
    [self addSubview:hideView];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.frame = CGRectMake(0, 0, square3.width, square3.height);
    [_likeButton setTitle:@"" forState:UIControlStateNormal];
    [square3 addSubview:_likeButton];
    
    _changeViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeViewButton.frame = CGRectMake(0, 0, 30, 30);
    _changeViewButton.center = CGPointMake(KScreenWidth - 25 - 15, 45);
    [_changeViewButton setImage:[UIImage imageNamed:@"List"] forState:UIControlStateNormal];
    [_backImage addSubview:_changeViewButton];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(0, 0, 30, 30);
    _shareButton.center = CGPointMake(25 + 15, 45);
    [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [_backImage addSubview:_shareButton];
    
    
    _poster.layer.masksToBounds = YES;
    _poster.layer.cornerRadius = 5;
    
    _whiteback.layer.masksToBounds = YES;
    _whiteback.layer.cornerRadius = 5;
    
}

- (void)setValueWithVideoModel:(VideoModel *)model {
    NSURL *url1 = [NSURL URLWithString:model.coverBlurred];
    [self.backImage sd_setImageWithURL:url1 placeholderImage:nil];
    
    NSURL *url2 = [NSURL URLWithString:model.coverForDetail];
    [self.poster sd_setImageWithURL:url2 placeholderImage:nil];
    self.title.text = model.title;
//    _time.text = [NSString stringWithFormat:@"%d", arc4random()%100 + 30];

    
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"MMM  dd"];
    NSString *datestr = [formate stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.date/1000]];
    _date.text = [NSString stringWithFormat:@"%@", datestr];
    
//    self.time.text = @"45";
    self.like.text = [NSString stringWithFormat:@"%ld", model.collectionCount];
}

@end
