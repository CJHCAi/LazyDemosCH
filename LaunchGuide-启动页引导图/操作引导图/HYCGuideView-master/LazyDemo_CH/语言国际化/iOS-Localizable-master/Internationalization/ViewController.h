//
//  ViewController.h
//  Internationalization
//
//  Created by Qiulong-CQ on 16/11/10.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Localizable.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;

- (IBAction)change:(id)sender;
- (IBAction)jump:(id)sender;
@end

