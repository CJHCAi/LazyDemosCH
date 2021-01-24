//
//  SettingController.h
//  MaJiang
//
//  Created by yu_hao on 1/14/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingController;

@protocol SettingControllerDelegate <NSObject>

- (void)SettingControllerDidDisapear:(SettingController *)controller;
- (void)deleteAllData:(SettingController *)controller;

@end

@interface SettingController : UITableViewController <UITableViewDelegate>

@property (weak, nonatomic) id <SettingControllerDelegate> delegate;

- (IBAction)clearAllData:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *diangangjiayu;
@property (weak, nonatomic) IBOutlet UISwitch *zimojiayu;
@property (weak, nonatomic) IBOutlet UISwitch *bujiaotuiyu;
@property (weak, nonatomic) IBOutlet UISwitch *tishiyin;
- (IBAction)setdiangangjiayu:(id)sender;
- (IBAction)setzimojiayu:(id)sender;
- (IBAction)setbujiaotuiyu:(id)sender;
- (IBAction)settishiyin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *name1;
@property (weak, nonatomic) IBOutlet UITextField *name2;
@property (weak, nonatomic) IBOutlet UITextField *name3;
@property (weak, nonatomic) IBOutlet UITextField *name4;
- (IBAction)setname1:(id)sender;
- (IBAction)setname2:(id)sender;
- (IBAction)setname3:(id)sender;
- (IBAction)setname4:(id)sender;

- (void)delegateDelete;

@end
