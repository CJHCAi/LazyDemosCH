//
//  setViewController.m
//  Calculator1
//
//  Created by ruru on 16/4/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "setViewController.h"
#import "themeViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface setViewController ()



@end

@implementation setViewController{
    NSMutableArray *clickMusic;
    int musicState;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    clickMusic=[[NSMutableArray alloc]init];
    [clickMusic addObject:@"0"];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 音效实现函数
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    SystemSoundID soundID=0;//获得系统声音ID
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesPlaySystemSound(soundID);//播放音效
}

- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];//返回主界面
}
- (IBAction)gotoTheme:(id)sender {
    themeViewController *gotoThemePage=[[themeViewController alloc]init];
    [self.navigationController pushViewController:gotoThemePage animated:YES];
}
- (IBAction)musicState:(id)sender {
    UISwitch * swit= (UISwitch *)sender;
    NSString * ON =[NSString stringWithFormat:@"%d",swit.on];
    [Common configSet:@"key_music_on" value:ON];
    musicState=swit.on;
}
- (IBAction)OponBlurEffect:(id)sender{
    UISwitch *swit1=(UISwitch *)sender;
    NSString *bgEffectOn=[NSString stringWithFormat:@"%d",swit1.on];
    [Common configSet:@"key_bg_lurEffect_on" value:bgEffectOn];
    NSLog( @"blurEffect%@",[Common configGet:@"key_bg_lurEffect_on"]);

}
-(void)viewWillAppear:(BOOL)animated{
    musicState=[[Common configGet:@"key_music_on"]intValue];
    int i;
    NSArray *array=[Common configGetClcikMusic:@"MusicKey"];
    NSString *Str=[array objectAtIndex:0];
    if ([Str isEqualToString:@"Music1"]) {
        i=1;
    }else if ([Str isEqualToString:@"Music2"]) {
        i=2;
    }else if ([Str isEqualToString:@"Music3"]) {
        i=3;
    }else if ([Str isEqualToString:@"Music4"]) {
        i=4;
    }
    switch (i) {
        case 1 :self.selectImage1.hidden=NO;break;
        case 2:self.selectImage2.hidden=NO;break;
        case 3:self.selectImage3.hidden=NO;break;
        case 4:self.selectImage4.hidden=NO;break;
        default:break;
    }
    if (musicState) {
        self.MusicswitchSate.on=YES;
    }else{
        self.MusicswitchSate.on=NO;
    }
    if ([[Common configGet:@"key_bg_lurEffect_on"]intValue]) {
        self.blurEffectSatae.on=YES;
    }else{
        self.blurEffectSatae.on=NO;
    }
 }
- (IBAction)clickMuisc1:(id)sender {
    [clickMusic replaceObjectAtIndex:0 withObject:@"Music1"];
    [self setSelectImageHidden];
    self.selectImage1.hidden=NO;
    if (musicState) {
        [self playSoundEffect:@"click.wav"];
    }
    [Common configSet:@"MusicKey" value:clickMusic];
}
- (IBAction)clickMuisc2:(id)sender {
    [clickMusic replaceObjectAtIndex:0 withObject:@"Music2"];
    [Common configSet:@"MusicKey" value:clickMusic];
    if (musicState) {
        [self playSoundEffect:@"click1.wav"];
    }
    [self setSelectImageHidden];
    self.selectImage2.hidden=NO;
}
- (IBAction)clickMuisc3:(id)sender {
    [clickMusic replaceObjectAtIndex:0 withObject:@"Music3"];
    [Common configSet:@"MusicKey" value:clickMusic];
    if (musicState) {
        [self playSoundEffect:@"click2.wav"];
    }
    [self setSelectImageHidden];
    self.selectImage3.hidden=NO;
    }
- (IBAction)clickMuisc4:(id)sender {
    [clickMusic replaceObjectAtIndex:0 withObject:@"Music4"];
    [Common configSet:@"MusicKey" value:clickMusic];
    if (musicState) {
        [self playSoundEffect:@"click3.wav"];
    }
    [self setSelectImageHidden];
    self.selectImage4.hidden=NO;
}
-(void)setSelectImageHidden{
    self.selectImage1.hidden=YES;
    self.selectImage2.hidden=YES;
    self.selectImage3.hidden=YES;
    self.selectImage4.hidden=YES;

}

@end
