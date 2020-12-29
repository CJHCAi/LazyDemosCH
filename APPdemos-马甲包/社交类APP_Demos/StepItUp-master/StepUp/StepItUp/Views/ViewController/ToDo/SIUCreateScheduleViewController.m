//
//  SIUCreateScheduleViewController.m
//  Step it up
//
//  Created by syfll on 15/4/3.
//  Copyright (c) 2015年 syfll. All rights reserved.
//

#import "SIUCreateScheduleViewController.h"

#import "SIUCreateScheduleTextCell.h"
#import "SIURightDetailCell.h"
#import "SIURightDetailDisclosureCell.h"
#import "SIUBasicBlueCell.h"
#import "SIUBasicSwitchCell.h"
#import "SIUCreateScheduleDatePickerCell.h"

#import "LKAlarmMamager.h"

#define SIUCreateScheduleIsDateCellIdentifier @"SIUBasicSwitchCell"
#define SIUCreateScheduleDateCellIdentifier @"SIUBasicBlueCell"
#define SIUCreateScheduleIsDateRepeateCellIdentifier @"SIURightDetailDisclosureCell"
#define SIUCreateScheduleIsPlaceCellIdentifier @"SIUBasicSwitchCell"
#define SIUCreateSchedulePlaceCellIdentifier @"SIURightDetailDisclosureCell.h"
#define SIUCreateScheduleDatePickerCellIdentifier @"SIUCreateScheduleDatePickerCell"
#define SIUCreateScheduleTextCellIdentifier @"SIUCreateScheduleTextCell"
@interface SIUCreateScheduleViewController ()

@property (nonatomic, strong) NSMutableArray *cells;
@end

@implementation SIUCreateScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if(_cells == nil){
//        _cells = [[NSMutableArray alloc]initWithCapacity:3];
//        NSMutableArray * cellForSection1 = [[NSMutableArray alloc]initWithCapacity:1];
//        NSMutableArray * cellForSection2 = [[NSMutableArray alloc]initWithCapacity:4];
//        NSMutableArray * cellForSection3 = [[NSMutableArray alloc]initWithCapacity:2];
//        [_cells addObject:cellForSection1];
//        [_cells addObject:cellForSection2];
//        [_cells addObject:cellForSection3];
//        
//        cellForSection1 addObject:<#(id)#>
//    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 4;
    }
    if (section == 2) {
        return 2;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                SIUCreateScheduleTextCell *scheduleTextCell = [tableView dequeueReusableCellWithIdentifier:SIUCreateScheduleTextCellIdentifier];
                if (scheduleTextCell == nil) {
                    scheduleTextCell = [SIUCreateScheduleTextCell CreateCell];
                }
                cell = scheduleTextCell;
            }
                break;
            
            default:{
            
            }
                break;
        }
    }
    if (indexPath.section ==1) {
        switch (indexPath.row) {
            case 0:{
                SIUBasicSwitchCell *DateCell = [tableView dequeueReusableCellWithIdentifier:SIUCreateScheduleIsDateCellIdentifier];
                if (DateCell == nil) {
                    DateCell = [SIUBasicSwitchCell CreateCell];
                    [DateCell.SSwitch addTarget:self action:@selector(isDate:) forControlEvents:UIControlEventValueChanged];
                }
                cell = DateCell;
            }break;
            case 1:{
                SIURightDetailCell *DateCell = [tableView dequeueReusableCellWithIdentifier:SIUCreateScheduleDateCellIdentifier];
                if (DateCell == nil) {
                    DateCell = [SIURightDetailCell CreateCell];
                }
                cell = DateCell;
            }break;
            case 2:{
                SIUCreateScheduleDatePickerCell *DatePickerCell = [tableView dequeueReusableCellWithIdentifier:SIUCreateScheduleDatePickerCellIdentifier];
                if (DatePickerCell == nil) {
                    DatePickerCell = [SIUCreateScheduleDatePickerCell CreateCell];
                }
                cell = DatePickerCell;
            }
                break;
            case 3:{
                SIURightDetailDisclosureCell *DatePickerCell = [tableView dequeueReusableCellWithIdentifier:SIUCreateScheduleIsDateRepeateCellIdentifier];
                if (DatePickerCell == nil) {
                    DatePickerCell = [SIURightDetailDisclosureCell CreateCell];
                }
                cell = DatePickerCell;
            }break;
            default:{
                return nil;
            }break;
                //case 1:
        }
    }
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:{
                SIUBasicSwitchCell *DatePickerCell = [tableView dequeueReusableCellWithIdentifier:SIUCreateScheduleIsPlaceCellIdentifier];
                if (DatePickerCell == nil) {
                    DatePickerCell = [SIUBasicSwitchCell CreateCell];
                }
                cell = DatePickerCell;

            }
                break;
            case 1:{
                SIURightDetailDisclosureCell *DatePickerCell = [tableView dequeueReusableCellWithIdentifier:SIUCreateSchedulePlaceCellIdentifier];
                if (DatePickerCell == nil) {
                    DatePickerCell = [SIURightDetailDisclosureCell CreateCell];
                }
                cell = DatePickerCell;
            }break;
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - Action

-(void)isDate:(UISwitch*)sender{
    NSArray *indexPaths = [[NSArray alloc]initWithObjects:[NSIndexPath indexPathForRow:1 inSection:1],[NSIndexPath indexPathForRow:2 inSection:1], nil];
    if (sender.on) {
        printf("时间打开\n");
        //[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            }else{
        printf("时间关闭\n");
        //[self.tableView remo:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (IBAction)CancelAction:(id)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)AddAction:(id)sender {
    [self createReminder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)createReminder{
    LKAlarmEvent* event = [LKAlarmEvent new];
    event.title = @"参试加入日历事件中";
    event.content = @"只有加入到日历当中才有用，是日历中的备注";
    ///工作日提醒
    event.repeatType = LKAlarmRepeatTypeWork;
    ///??秒后提醒我
    event.startDate = [NSDate dateWithTimeIntervalSinceNow:3];
    
    NSLog(@"Date:%@ ",event.startDate);
    ///也可以强制加入到本地提醒中
    //event.isNeedJoinLocalNotify = YES;
    
    ///会先尝试加入日历  如果日历没权限 会加入到本地提醒中
    [[LKAlarmMamager shareManager] addAlarmEvent:event callback:^(LKAlarmEvent *alarmEvent) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //UILabel* label = ((ViewController*)_window.rootViewController).lb_haha;
            if(alarmEvent.isJoinedCalendar)
            {
                //label.text = @"已加入日历";
                printf("已加入日历\n");
            }
            else if(alarmEvent.isJoinedLocalNotify)
            {
                //label.text = @"已加入本地通知";
                printf("已加入本地通知\n");
            }
            else
            {
                //label.text = @"加入通知失败";
                printf("加入通知失败\n");
            }
            
        });
        
    }];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
