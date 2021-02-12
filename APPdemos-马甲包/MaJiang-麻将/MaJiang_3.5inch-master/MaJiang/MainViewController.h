//
//  MainViewController.h
//  MaJiang
//
//  Created by yu_hao on 1/6/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingController.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, SettingControllerDelegate>

//@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)playerWho:(id)sender;
- (IBAction)actionWhich:(id)sender;
- (IBAction)typeWhich:(id)sender;
- (IBAction)undo:(id)sender;

- (void) showPoints;
- (void) reset;
- (void) newGame;
- (void) collectFactor;
- (void) writeData;
- (void) checkSettings;
//- (void) calculateOne:(int)one;
//- (void) calculateTwo:(int)Two;
//- (void) calculateThree:(int)Three;
- (void) checkType;
- (void) zimo;
- (void) jiepao;
- (void) buhe;
- (void) bujiao;

@property (weak, nonatomic) IBOutlet UIButton *userButton1;
@property (weak, nonatomic) IBOutlet UIButton *userButton2;
@property (weak, nonatomic) IBOutlet UIButton *userButton3;
@property (weak, nonatomic) IBOutlet UIButton *userButton4;

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel1;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel2;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel3;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel4;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet UIButton *angangButton;
@property (weak, nonatomic) IBOutlet UIButton *diangangButton;
@property (weak, nonatomic) IBOutlet UIButton *gouerButton;
@property (weak, nonatomic) IBOutlet UIButton *zimoButton;
@property (weak, nonatomic) IBOutlet UIButton *jiepaoButton;
@property (weak, nonatomic) IBOutlet UIButton *buheButton;
@property (weak, nonatomic) IBOutlet UIButton *bujiaoButton;
@property (weak, nonatomic) IBOutlet UIButton *qingheButton;
@property (weak, nonatomic) IBOutlet UIButton *liangganButton;
@property (weak, nonatomic) IBOutlet UIButton *manheButton;
@property (weak, nonatomic) IBOutlet UIButton *jipinButton;
@property (weak, nonatomic) IBOutlet UIButton *chaojiButton;
@property (weak, nonatomic) IBOutlet UIButton *chaochaoButton;

@end
