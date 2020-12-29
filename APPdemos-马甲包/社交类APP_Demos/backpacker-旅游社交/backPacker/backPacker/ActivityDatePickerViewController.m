//
//  ActivityDatePickerViewController.m
//  BackPacker
//
//  Created by 聂 亚杰 on 13-5-10.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "ActivityDatePickerViewController.h"

@interface ActivityDatePickerViewController ()

@end

@implementation ActivityDatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSString *nowYear = [NSString stringWithFormat:@"%d",[dateComponent year]];
    NSString *nowMonth = [NSString stringWithFormat:@"%d",[dateComponent month]];
    NSString *nowDay = [NSString stringWithFormat:@"%d",[dateComponent day]];
    
    self.yearArray = [[NSMutableArray alloc]init];
    self.monthArray = [[NSMutableArray alloc]init];
    self.dayArray = [[NSMutableArray alloc]init];
    for (int i = nowYear.intValue; i<nowYear.intValue+6; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    for (int j = 1; j<13; j++) {
        [self.monthArray addObject:[NSString stringWithFormat:@"%d",j]];
        
    }
    
    if (nowMonth.intValue== 2) {
        if ((nowYear.intValue%4 == 0 && nowYear.intValue %100 != 0)|| (nowYear.intValue %100 != 0 && nowYear.intValue %400 ==0)) {
            for (int k = 1; k<30; k++) {
                [self.dayArray addObject:[NSString stringWithFormat:@"%d",k]];
            }
        }else{
            for (int k = 1; k<29; k++) {
                [self.dayArray addObject:[NSString stringWithFormat:@"%d",k]];
            }
        }
    }else if (nowMonth.intValue == 4 ||nowMonth.intValue == 6 || nowMonth.intValue == 9 || nowMonth.intValue == 11)
    {
        for (int k =1; k<31; k++) {
            [self.dayArray addObject:[NSString stringWithFormat:@"%d",k]];
        }
    }else{
        for (int k =1; k<32; k++) {
            [self.dayArray addObject:[NSString stringWithFormat:@"%d",k]];
        }
    }
    NSLog(@"dayArray:%@",self.dayArray);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)OkPressed:(id)sender {
    
    self.passValueDelegate = self.activityVC;   // 这里和B进行交互，下一句代码就是对应的赋值
    NSString *year = [self.yearArray objectAtIndex:[self.datePicker selectedRowInComponent:0]];
    NSString *month = [self.monthArray objectAtIndex:[self.datePicker selectedRowInComponent:1]];
    NSString *day = [self.dayArray objectAtIndex:[self.datePicker selectedRowInComponent:2]];
    NSString *date = [NSString stringWithFormat:@"%@-%@-%@ 12:00:00",year,month,day];
    
    [self.passValueDelegate setvalue:date senderTag:self.launchB];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Picker data source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            return [self.yearArray count];
            break;
        case 1:
            return [self.monthArray count];
            break;
        case 2:
            return [self.dayArray count];
            break;

        default:
            return 0;
            break;
    }
}

//书上介绍说这里面得委托方法是可选得（delegate中用optional修饰），实际上我们至少要实现一个委托方法
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
            break;
        case 1:
            return [NSString stringWithFormat:@"%@月",[self.monthArray objectAtIndex:row]];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@日",[self.dayArray objectAtIndex:row]];
            break;
        default:
            return 0;
            break;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0 || component == 1) {
        int selectedMonth = [[self.monthArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue];
        int selectedYear = [[self.yearArray objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
        [self.dayArray removeAllObjects];
        if (selectedMonth== 2) {
            if ((selectedYear%4 == 0 && selectedYear %100 != 0)|| (selectedYear %100 != 0 && selectedYear %400 ==0)) {
                for (int k = 1; k<30; k++) {
                    [self.dayArray addObject:[NSString stringWithFormat:@"%d",k]];
                }
            }else{
                for (int k = 1; k<29; k++) {
                    [self.dayArray addObject:[NSString stringWithFormat:@"%d",k]];
                }
            }
        }else if (selectedMonth == 4 ||selectedMonth == 6 || selectedMonth == 9 || selectedMonth == 11)
        {
            for (int k =1; k<31; k++) {
                [self.dayArray addObject:[NSString stringWithFormat:@"%d",k]];
            }
        }else{
            
            for (int k =1; k<32; k++) {
                [self.dayArray addObject:[NSString stringWithFormat:@"%d",k]];
            }
        }

        [pickerView reloadComponent:2];
    }
    
}
@end
