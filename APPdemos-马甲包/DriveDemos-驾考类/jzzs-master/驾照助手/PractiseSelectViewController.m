//
//  practiseSelectViewController.m
//  驾照助手
//
//  Created by 淡定独行 on 16/5/5.
//  Copyright © 2016年 肖辉良. All rights reserved.
//

#import "practiseSelectViewController.h"
#import "PractiseSelectTableViewCell.h"
#import "FirstLevel.h"
#import "PractiseViewController.h"
#import "fmdb/FMDB.h"
#import "LeafLevel.h"


@interface PractiseSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *courseTitle;
@end

@implementation PractiseSelectViewController
{
    PractiseSelectTableViewCell *cell;
    FMDatabase *dataBase;
    NSString *documentPath;
    NSMutableArray *practiseArray;
    
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title =  self.courseTitle;
    
    [self createDataBase];
    
    
    
    NSLog(@"%@",documentPath);
    
    
    //[self.tableView setScrollEnabled:NO];
    
    [self setExtraCellLineHidden:self.tableView];
}


#pragma 打开数据库
-(Boolean)createDataBase
{
    NSString *sqlitePath = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"sqlite"];
    dataBase = [FMDatabase databaseWithPath:sqlitePath];
    
    if (![dataBase open]) {
        NSLog(@"open dataBase fail...");
        return NO;
    }
    
    return YES;
}





-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"practiseSelectCell"];
    if (cell == nil) {
        [self.tableView registerNib:[UINib nibWithNibName:@"PractiseSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"practiseSelectCell"];
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"practiseSelectCell"];
    }
    
    
    
    //    [cell.imageBtn setTitle:@"1" forState:UIControlStateNormal];
    //    cell.IntroduceLabel.text = @"啥阿达撒的撒打算的asdadsadadaasdasdddada撒打算打算打算的撒收到的";
    
    FirstLevel *firstLevel = [[FirstLevel alloc] init];
    firstLevel = [_dataArray objectAtIndex:indexPath.row];
    
    [cell.imageBtn setTitle:[NSString stringWithFormat:@"%d",firstLevel.pId] forState:UIControlStateNormal];
    cell.IntroduceLabel.text = firstLevel.pName;
    cell.IntroduceLabel.textColor = [UIColor blackColor];
    
    return cell;
}

#pragma  行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"practise" sender:indexPath];

}

#pragma 跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PractiseViewController *practiseView = [segue destinationViewController];
    
    NSIndexPath *index = sender;
    
    if (index.row == 0) {
        practiseArray = [self querySql:@"select * from leaflevel where pid = 1"];
        
    }else if(index.row == 1){
        practiseArray = [self querySql:@"select * from leaflevel where pid = 2"];
    }else if(index.row == 2){
        practiseArray = [self querySql:@"select * from leaflevel where pid = 3"];
    }else if(index.row == 3){
        practiseArray = [self querySql:@"select * from leaflevel where pid = 4"];
    }else if(index.row == 4){
        practiseArray = [self querySql:@"select * from leaflevel where pid = 5"];
    }else if(index.row == 5){
        practiseArray = [self querySql:@"select * from leaflevel where pid = 6"];
    }else if(index.row == 6){
        practiseArray = [self querySql:@"select * from leaflevel where pid = 7"];
    }
    [practiseView setValue:practiseArray forKey:@"practiseArray"];

}


#pragma 获取数据
-(NSMutableArray *)querySql:(NSString *)sql
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:sql];
        while ([rs next]) {
            LeafLevel *leafLevel = [[LeafLevel alloc]init];
            leafLevel.mQuestion = [rs stringForColumn:@"mquestion"];
            leafLevel.mDesc = [rs stringForColumn:@"mdesc"];
            leafLevel.mId = [rs intForColumn:@"mid"];
            leafLevel.mAnswer = [rs stringForColumn:@"manswer"];
            leafLevel.mImage = [rs stringForColumn:@"mimage"];
            leafLevel.pId = [rs intForColumn:@"pid"];
            leafLevel.pName = [rs stringForColumn:@"pname"];
            leafLevel.sId = [rs intForColumn:@"sid"];
            leafLevel.sName = [rs stringForColumn:@"sname"];
            leafLevel.mStatus = [rs intForColumn:@"mstatus"];
            leafLevel.mArea = [rs stringForColumn:@"marea"];
            leafLevel.mType = [rs intForColumn:@"mtype"];
            leafLevel.mUnknow = [rs stringForColumn:@"munknow"];
            leafLevel.mYear = [rs intForColumn:@"myear"];
            leafLevel.eCount = [rs intForColumn:@"ecount"];
            [arr addObject:leafLevel];
        }
    }
    [dataBase close];
    return arr;


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

