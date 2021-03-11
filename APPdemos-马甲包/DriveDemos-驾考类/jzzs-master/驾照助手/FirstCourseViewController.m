//
//  FirstCourseViewController.m
//  驾照助手
//
//  Created by 淡定独行 on 16/5/5.
//  Copyright © 2016年 肖辉良. All rights reserved.
//

#import "FirstCourseViewController.h"
#import "FirstCourseTableViewCell.h"
#import "PractiseSelectViewController.h"
#import "fmdb/FMDB.h"
#import "FirstLevel.h"
#import "PractiseViewController.h"
#import "LeafLevel.h"



@interface FirstCourseViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FirstCourseViewController
{
    FirstCourseTableViewCell *cell;
    NSDictionary *practiceDic;
    NSMutableArray *dataArray;
    FMDatabase *dataBase;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setScrollEnabled:NO];
    
    
    practiceDic = [NSDictionary dictionaryWithObjectsAndKeys:@"章节练习",@"7",@"顺序练习",@"8",@"随机练习",@"9",@"专项练习",@"10",@"仿真模拟考试",@"11",nil];
    dataArray = [[NSMutableArray alloc]init];
    
    [self createDateBase];
    
    [self setExtraCellLineHidden:self.tableView];
    
}

#pragma 打开数据库
-(BOOL)createDateBase
{
    NSString *sqlitePath = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"sqlite"];
    dataBase = [FMDatabase databaseWithPath:sqlitePath];
    
    if (![dataBase open]) {
        NSLog(@"create dataBase fail...");
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  practiceDic.count;
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"firstCourse"];
    if(cell == nil){
        //向数据源注册 cell
        [self.tableView registerNib:[UINib nibWithNibName:@"FirstCourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"firstCourse"];
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"firstCourse"];
    }
    NSArray *keysArray = [practiceDic allKeys];//获取所有键存到数组
    NSArray *sortedArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];//由于allKeys返回的是无序数组，这里我们要排列它们的顺序
    NSString *key = sortedArray[indexPath.row];
    
    [cell.imageBtn setBackgroundImage:[UIImage imageNamed:key] forState:UIControlStateNormal];
    cell.IntroduceLabel.text = [practiceDic objectForKey:key];
    
    
    return cell;
    
}

#pragma 行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"practiseSelect" sender:indexPath];
    }else if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"practise" sender:indexPath];
    
    }
    
    
    
}

#pragma 跳转页面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PractiseSelectViewController *practiseSelectView = [segue destinationViewController];
    
    PractiseViewController *practiseView = [segue destinationViewController];
    
    NSIndexPath *index = sender;
    if (index.row == 0) {
        dataArray = [self queryPractiseSelectSql:@"select * from firstlevel"];
        [practiseSelectView setValue:dataArray forKey:@"dataArray"];
        [practiseSelectView setValue:@"章节练习" forKey:@"courseTitle"];
    }else if (index.row == 1){
        dataArray = [self queryPractiseSql:@"select * from leafLevel"];
        [practiseView setValue:dataArray forKey:@"practiseArray"];
        [practiseView setValue:@"顺序练习" forKey:@"courseTitle"];
    }
    
    
}


#pragma 获取数据
-(NSMutableArray *)queryPractiseSelectSql:(NSString *)sql
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if ([dataBase open]) {
        
        FMResultSet *rs = [dataBase executeQuery:sql];
        
        while([rs next]){
            FirstLevel *firstLevel = [[FirstLevel alloc]init];
            firstLevel.pId = [rs intForColumn:@"pid"];
            firstLevel.pName = [rs stringForColumn:@"pname"];
            firstLevel.pCount = [rs intForColumn:@"pcount"];
            [arr addObject:firstLevel];
        }
    }
    [dataBase close];
    return arr;
}

-(NSMutableArray *)queryPractiseSql:(NSString *)sql
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if ([dataBase open]) {
        
        FMResultSet *rs = [dataBase executeQuery:sql];
        
        while([rs next]){
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
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
