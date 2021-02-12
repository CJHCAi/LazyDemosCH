//
//  AnalysePlayer3ViewController.m
//  MaJiang
//
//  Created by yu_hao on 1/19/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import "AnalysePlayer3ViewController.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"

#import "sqlite3.h"

@interface AnalysePlayer3ViewController ()
{
    NSString *databasePath;
    sqlite3 *database;
    
    NSArray *linedata;
    NSArray *bardata;
    
    int shengju;
    int baiju;
    int zimo;
    int jiepao;
    int dianpao;
    int yingyu;
    int shuyu;
}

@end

@implementation AnalysePlayer3ViewController

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
    
    linedata = [[NSArray alloc] init];
    
    //数据库部分
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc]
                    initWithString: [docsDir stringByAppendingPathComponent:
                                     @"database.db"]];
    NSLog(@"%@", databasePath);
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //获取数据库书数据以更新初始变量
        int DBgameid = 0;
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT MAX(GAMEID) FROM POINTS"];
        sqlite3_stmt * statement;
        
        if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                DBgameid = sqlite3_column_int(statement, 0);
            }
        }
        sqlite3_finalize(statement);
        
        NSMutableArray *tmpLineData = [[NSMutableArray alloc] init];
        for (int i=0; i<DBgameid; i++) {
            NSString *sqlQuery2 = [NSString stringWithFormat:@"SELECT SUM(PLAYER3) FROM POINTS WHERE GAMEID = %d", i + 1];
            
            if (sqlite3_prepare_v2(database, [sqlQuery2 UTF8String], -1, &statement, nil) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int tmpSum = sqlite3_column_int(statement, 0);
                    if (tmpSum >= 0) {
                        shengju++;
                    } else
                    {
                        baiju++;
                    }
                    if (i != 0) {
                        tmpSum += [[tmpLineData objectAtIndex:i-1] integerValue];
                    }
                    [tmpLineData addObject:[NSString stringWithFormat:@"%d", tmpSum]];
                }
            } else
            {
                NSLog(@"数据库读取出错");
            }
            sqlite3_finalize(statement);
        }
        
        NSString *sqlQuery3 = [NSString stringWithFormat:@"SELECT FACTOR1, FACTOR2, FACTOR3 FROM ACTIONS"];
        
        if (sqlite3_prepare_v2(database, [sqlQuery3 UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *factor1 = (char*)sqlite3_column_text(statement, 0);
                NSString *nsfactor1 = [[NSString alloc]initWithUTF8String:factor1];
                char *factor2 = (char*)sqlite3_column_text(statement, 1);
                NSString *nsfactor2 = [[NSString alloc]initWithUTF8String:factor2];
                char *factor3 = (char*)sqlite3_column_text(statement, 2);
                NSString *nsfactor3 = [[NSString alloc]initWithUTF8String:factor3];
                //NSLog(@"%@", nsfactor3);
                if ([nsfactor1 isEqualToString:@"本家"]) {
                    if ([nsfactor2 isEqualToString:@"自摸"]) {
                        zimo++;
                    }
                    if ([nsfactor2 isEqualToString:@"接炮"]) {
                        jiepao++;
                    }
                    if ([nsfactor2 isEqualToString:@"暗杠"]) {
                        if ([nsfactor3 rangeOfString:@"对"].location != NSNotFound) {
                            yingyu += 2;
                        }
                        if ([nsfactor3 rangeOfString:@"下"].location != NSNotFound) {
                            yingyu += 2;
                        }
                        if ([nsfactor3 rangeOfString:@"上"].location != NSNotFound) {
                            yingyu += 2;
                        }
                    }
                    if ([nsfactor2 isEqualToString:@"点杠"]) {
                        //还有点不完善
                        yingyu += 2;
                    }
                    if ([nsfactor2 isEqualToString:@"勾儿"]) {
                        if ([nsfactor3 rangeOfString:@"对"].location != NSNotFound) {
                            yingyu++;
                        }
                        if ([nsfactor3 rangeOfString:@"下"].location != NSNotFound) {
                            yingyu++;
                        }
                        if ([nsfactor3 rangeOfString:@"上"].location != NSNotFound) {
                            yingyu++;
                        }
                    }
                }
                if ([nsfactor3 isEqualToString:@"本家"]) {
                    //NSLog(@"%@", nsfactor3);
                    if ([nsfactor2 isEqualToString:@"接炮"]) {
                        dianpao++;
                    }
                    if ([nsfactor2 isEqualToString:@"点杠"]) {
                        shuyu += 2;
                    }
                }
                if ([nsfactor2 isEqualToString:@"暗杠"]) {
                    if ([nsfactor3 rangeOfString:@"本"].location != NSNotFound) {
                        shuyu += 2;
                    }
                }
                if ([nsfactor2 isEqualToString:@"勾儿"]) {
                    if ([nsfactor3 rangeOfString:@"本"].location != NSNotFound) {
                        shuyu++;
                    }
                }
            }
        }
        sqlite3_finalize(statement);
        
        linedata = tmpLineData;
        
        sqlite3_close(database);
    }
    
    bardata = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:shengju], [NSNumber numberWithInt:baiju], [NSNumber numberWithInt:zimo], [NSNumber numberWithInt:jiepao], [NSNumber numberWithInt:dianpao], [NSNumber numberWithInt:yingyu], [NSNumber numberWithInt:shuyu], nil ];
    //Add BarChart
    UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
    barChartLabel.text = @" ";
    barChartLabel.textColor = PNFreshGreen;
    barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    barChartLabel.textAlignment = NSTextAlignmentCenter;
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 200.0)];
    barChart.backgroundColor = [UIColor clearColor];
    [barChart setXLabels:@[@"胜局",@"败局",@"自摸",@"接炮",@"点炮",@"赢雨",@"输雨"]];
    [barChart setYValues:bardata];
    [barChart setStrokeColors:@[PNTwitterColor,PNRed,PNGreen,PNGreen,PNRed,PNGreen,PNYellow]];
    [barChart strokeChart];
    
    //[self.view addSubview:barChartLabel];
    [self.view addSubview:barChart];
    
    //Add LineChart
    UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
    lineChartLabel.text = @" ";
    lineChartLabel.textColor = PNFreshGreen;
    lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    lineChartLabel.textAlignment = NSTextAlignmentCenter;
    
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 200.0)];
    lineChart.backgroundColor = [UIColor clearColor];
    [lineChart setXLabels:[[NSArray alloc] initWithArray:linedata]];
    
    // Line Chart Nr.2
    NSArray * data02Array = [[NSArray alloc] initWithArray:linedata];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data02Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data02];
    [lineChart strokeChart];
    
    lineChart.delegate = self;
    
    //[self.view addSubview:lineChartLabel];
    [self.view addSubview:lineChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

@end