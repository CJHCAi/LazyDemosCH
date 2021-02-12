//
//  HistoryViewController.m
//  MaJiang
//
//  Created by yu_hao on 1/18/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import "HistoryViewController.h"
#import "sqlite3.h"

@interface HistoryViewController ()
{
    NSString *databasePath;
    sqlite3 *database;
    
    int gameCount;
    NSMutableArray *pointsArray;
    NSMutableArray *eventArray;;
}

@end

@implementation HistoryViewController

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
    
    pointsArray = [[NSMutableArray alloc] init];
    eventArray = [[NSMutableArray alloc] init];
    
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
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS POINTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, GAMEID INTEGER, ACTIONNUM INTEGER, PLAYER1 INTEGER, PLAYER2 INTEGER, PLAYER3 INTEGER, PLAYER4 INTEGER)";
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table: POINTS");
            } else
            {
                NSLog(@"Secceed to create table: POINTS");
            }
            
            const char *sql_stmt_2 =
            "CREATE TABLE IF NOT EXISTS ACTIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, GAMEID INTEGER, ACTIONNUM INTEGER, FACTOR1 TEXT, FACTOR2 TEXT, FACTOR3 TEXT, FACTOR4 TEXT)";
            
            if (sqlite3_exec(database, sql_stmt_2, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table: ACTIONS");
            } else
            {
                NSLog(@"Succeed to create table: ACTIONS");
            }
            sqlite3_close(database);
        } else {
            NSLog(@"Failed to open/create database");
        }
    } else
    {
        NSLog(@"数据库已存在");
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            //获取数据库书数据以更新初始变量
            NSString *sqlQuery = @"SELECT MAX(GAMEID), MAX(ACTIONNUM), MAX(PLAYER1), MAX(PLAYER2), MAX(PLAYER3), MAX(PLAYER4) FROM POINTS";
            sqlite3_stmt * statement;
            
            if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    //                    char *gameid = (char*)sqlite3_column_text(statement, 0);
                    //                    NSString *nsgameid = [[NSString alloc]initWithUTF8String:gameid];
                    int DBgameid = sqlite3_column_int(statement, 0);
                    int DBactionnum = sqlite3_column_int(statement, 1);
                    int DBplayer1 = sqlite3_column_int(statement, 2);
                    int DBplayer2 = sqlite3_column_int(statement, 3);
                    int DBplayer3 = sqlite3_column_int(statement, 4);
                    int DBplayer4 = sqlite3_column_int(statement, 5);
                    
                    NSLog(@"gameid:%d  actionnum:%d  player1:%d  player2:%d  player3:%d  player4:%d", DBgameid, DBactionnum, DBplayer1, DBplayer2, DBplayer3, DBplayer4);
                    //暂时只需要用gameid吧，相当于软件重启后是重新开启新的一局，不管之前一局有没有结束（未完成的局的event还是在）
                    gameCount = DBgameid;
                }
            }
            sqlite3_close(database);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return gameCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryCell";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    cell.gameid.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [pointsArray removeAllObjects];
    [eventArray removeAllObjects];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //获取数据库书数据以更新初始变量
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT PLAYER1, PLAYER2, PLAYER3, PLAYER4 FROM POINTS WHERE GAMEID = %d", indexPath.row + 1];
        sqlite3_stmt * statement;
        
        if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //                    char *gameid = (char*)sqlite3_column_text(statement, 0);
                //                    NSString *nsgameid = [[NSString alloc]initWithUTF8String:gameid];
                int DBgameid = sqlite3_column_int(statement, 0);
                int DBactionnum = sqlite3_column_int(statement, 1);
                int DBplayer1 = sqlite3_column_int(statement, 2);
                int DBplayer2 = sqlite3_column_int(statement, 3);
                
                //NSLog(@"用户一:%d 用户二:%d 用户三:%d 用户四:%d", DBgameid, DBactionnum, DBplayer1, DBplayer2);
                [pointsArray addObject:[NSString stringWithFormat:@"对家:%+d 下家:%+d 本家:%+d 上家:%+d", DBgameid, DBactionnum, DBplayer1, DBplayer2]];
            }
        }
        sqlite3_finalize(statement);
        
        NSString *sqlQuery2 = [NSString stringWithFormat:@"SELECT FACTOR1, FACTOR2, FACTOR3, FACTOR4 FROM ACTIONS WHERE GAMEID = %d", indexPath.row + 1];
        
        if (sqlite3_prepare_v2(database, [sqlQuery2 UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *factor1 = (char*)sqlite3_column_text(statement, 0);
                NSString *nsfactor1 = [[NSString alloc]initWithUTF8String:factor1];
                char *factor2 = (char*)sqlite3_column_text(statement, 1);
                NSString *nsfactor2 = [[NSString alloc]initWithUTF8String:factor2];
                char *factor3 = (char*)sqlite3_column_text(statement, 2);
                NSString *nsfactor3 = [[NSString alloc]initWithUTF8String:factor3];
                char *factor4 = (char*)sqlite3_column_text(statement, 3);
                NSString *nsfactor4 = [[NSString alloc]initWithUTF8String:factor4];
                
                //NSLog(@"用户一:%d  用户二:%d  用户三:%d  用户四:%d", DBgameid, DBactionnum, DBplayer1, DBplayer2);
                [eventArray addObject:[NSString stringWithFormat:@"%@ %@ %@ %@", nsfactor1, nsfactor2, [nsfactor3 isEqualToString:@"nil"] ? @" " : nsfactor3, [nsfactor4 isEqualToString:@"nil"] ? @" " : nsfactor4]];
            }
        } else
        {
            NSLog(@"数据库读取出错");
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepare for segue");
    if ([segue.identifier isEqualToString:@"HistoryDetailViewController"]) {
        HistoryDetailViewController *controller = segue.destinationViewController;
        controller.pointsArray = pointsArray;
        controller.eventArray = eventArray;
    } else
    {
        NSLog(@"没有找到segue");
    }
}

@end
