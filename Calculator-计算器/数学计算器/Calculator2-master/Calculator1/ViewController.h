//
//  ViewController.h
//  Calculator1
//
//  Created by ruru on 16/4/12.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "savehistoryData.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *mathLabel;

- (IBAction)settingBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (strong, nonatomic) IBOutlet UIView *keyboardView;

@property (weak, nonatomic) IBOutlet UIView *keyboardView2;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIView *subKeyboardView;
@property (weak, nonatomic) IBOutlet UIView *subKeyboardView2;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@end

