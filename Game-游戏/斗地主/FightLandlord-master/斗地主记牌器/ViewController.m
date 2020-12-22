//
//  ViewController.m
//  斗地主记牌器
//
//  Created by huGb on 16/6/13.
//  Copyright © 2016年 iyd. All rights reserved.
//

#import "ViewController.h"
#import "MyMusicHelper.h"
@interface ViewController ()
{
    BOOL  hasMusic;
}
@property(nonatomic,strong)  AVAudioPlayer *  clickPlayer;
@property(nonatomic,strong)  AVAudioPlayer *  player;
@property (weak, nonatomic) IBOutlet UILabel *daWang;
@property (weak, nonatomic) IBOutlet UILabel *xiaoWang;
@property (weak, nonatomic) IBOutlet UILabel *cardA;
@property (weak, nonatomic) IBOutlet UILabel *card2;
@property (weak, nonatomic) IBOutlet UILabel *card3;
@property (weak, nonatomic) IBOutlet UILabel *card4;
@property (weak, nonatomic) IBOutlet UILabel *card5;
@property (weak, nonatomic) IBOutlet UILabel *card6;
@property (weak, nonatomic) IBOutlet UILabel *card7;
@property (weak, nonatomic) IBOutlet UILabel *card8;
@property (weak, nonatomic) IBOutlet UILabel *card9;
@property (weak, nonatomic) IBOutlet UILabel *card10;
@property (weak, nonatomic) IBOutlet UILabel *cardJ;
@property (weak, nonatomic) IBOutlet UILabel *cardQ;
@property (weak, nonatomic) IBOutlet UILabel *cardK;


@property (weak, nonatomic) IBOutlet UIButton *musicBtn;

- (IBAction)music:(UIButton *)sender;


- (IBAction)calculate:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    hasMusic=NO;
    // 播放背景音乐
}


-(void)playMusicWithName:(NSString *)musicName
{
    if (hasMusic) {
        [self.clickPlayer stop];
        self.clickPlayer=nil;
        self.clickPlayer=[MyMusicHelper loadMusicPlayer:musicName];
        [_clickPlayer setVolume:0.5];
        [_clickPlayer play];
    }
}

- (IBAction)gestureRespon:(UITapGestureRecognizer *)sender
{
    UIImageView * imageView=(UIImageView *)sender.view;
    switch (imageView.tag) {
        case 100:
        {//大王
            
            NSInteger num= [self.daWang.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.daWang.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_15.mp3"];
        }
            break;
        case 101:
        {//小王
            NSInteger num= [self.xiaoWang.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.xiaoWang.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_14.mp3"];
        }
            break;
        case 102:
        {//A
            NSInteger num= [self.cardA.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.cardA.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_1.mp3"];
        }
            break;
        case 103:
        {//2
            NSInteger num= [self.card2.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.card2.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_2.mp3"];
        }
            break;
        case 104:
        {//3
            NSInteger num= [self.card3.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.card3.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_3.mp3"];
        }
            break;
        case 105:
        {//4
            NSInteger num= [self.card4.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.card4.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_4.mp3"];
        }
            break;
        case 106:
        {//5
            NSInteger num= [self.card5.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.card5.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_5.mp3"];
        }
            break;
        case 107:
        {//6
            NSInteger num= [self.card6.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.card6.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_6.mp3"];
        }
            break;
        case 108:
        {//7
            NSInteger num= [self.card7.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.card7.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_7.mp3"];
        }
            break;
        case 109:
        {//8
            NSInteger num= [self.card8.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.card8.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_8.mp3"];
        }
            break;
        case 110:
        {//9
            NSInteger num= [self.card9.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.card9.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_9.mp3"];
        }
            break;
        case 111:
        {//10
            NSInteger num= [self.card10.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.card10.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_10.mp3"];
        }
            break;
        case 112:
        {//J
            NSInteger num= [self.cardJ.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.cardJ.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_11.mp3"];
        }
            break;
        case 113:
        {//Q
            NSInteger num= [self.cardQ.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.cardQ.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_12.mp3"];
        }
            break;
        case 114:
        {//K
            NSInteger num= [self.cardK.text integerValue];
            num=num-1;
            if (num<0) {
                num=0;
            }
            self.cardK.text=[NSString stringWithFormat:@"%ld",(long)num];
            [self playMusicWithName:@"Man_13.mp3"];
        }
            break;
        default:
            break;
    }
}

- (IBAction)music:(UIButton *)sender {
    
    hasMusic=!hasMusic;
    sender.selected=hasMusic;
    if (hasMusic) {
        [self.player stop];
        self.player=nil;
        self.player = [MyMusicHelper loadMusicPlayer:@"MusicEx_Normal2.mp3"];
        [_player setNumberOfLoops:-1];
        [_player setVolume:0.5];
        [_player play];
    }else{
        [self.player stop];
        self.player=nil;
    }
}

- (IBAction)calculate:(id)sender
{
    [self playMusicWithName:@"10150000-gexing.mp3"];
    self.daWang.text=@"1";
    self.xiaoWang.text=@"1";
    self.cardA.text=@"4";
    self.card2.text=@"4";
    self.card3.text=@"4";
    self.card4.text=@"4";
    self.card5.text=@"4";
    self.card6.text=@"4";
    self.card7.text=@"4";
    self.card8.text=@"4";
    self.card9.text=@"4";
    self.card10.text=@"4";
    self.cardJ.text=@"4";
    self.cardQ.text=@"4";
    self.cardK.text=@"4";
}
@end
