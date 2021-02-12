//
//  ViewController.m
//  CJCalendar
//
//  Created by chjsun on 16/5/23.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import "ViewController.h"

#import "CJCalendarViewController.h"

@interface ViewController ()<CalendarViewControllerDelegate>

/** 按钮 */
@property (nonatomic, weak) UIButton *CJButton;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)btnClick:(UIButton *)sender {
    self.CJButton = sender;
    CJCalendarViewController *calendarController = [[CJCalendarViewController alloc] init];
    calendarController.view.frame = self.view.frame;
    calendarController.delegate = self;
    
    NSArray *arr = [sender.titleLabel.text componentsSeparatedByString:@"-"];
    if (arr.count > 1) {
        [calendarController setYear:arr[0] month:arr[1] day:arr[2]];
    }
    [self presentViewController:calendarController animated:YES completion:nil];

}

-(void)CalendarViewController:(CJCalendarViewController *)controller didSelectActionYear:(NSString *)year month:(NSString *)month day:(NSString *)day{

    [self.CJButton setTitle:[NSString stringWithFormat:@"%@-%@-%@", year, month, day] forState:UIControlStateNormal];

}

@end
