//
//  setViewController.h
//  Calculator1
//
//  Created by ruru on 16/4/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface setViewController : UIViewController

- (IBAction)gotoBack:(id)sender;

@property (assign,nonatomic) BOOL musicOn;
- (IBAction)gotoTheme:(id)sender;
- (IBAction)musicState:(id)sender;
- (IBAction)clickMuisc1:(id)sender;
- (IBAction)clickMuisc2:(id)sender;

- (IBAction)clickMuisc3:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *MusicswitchSate;

- (IBAction)clickMuisc4:(id)sender;
- (IBAction)OponBlurEffect:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *blurEffectSatae;

@property (weak, nonatomic) IBOutlet UIImageView *selectImage1;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage2;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage3;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage4;
@end
