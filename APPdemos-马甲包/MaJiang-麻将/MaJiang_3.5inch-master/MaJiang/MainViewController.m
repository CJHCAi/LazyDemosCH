//
//  MainViewController.m
//  MaJiang
//
//  Created by yu_hao on 1/6/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import "MainViewController.h"
#import "Player.h"
#import "CustomCell.h"
#import "sqlite3.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h> 

@implementation MainViewController
{
    NSString *databasePath;
    sqlite3 *database;
    
    int onlineNumber;
    int gameID;
    int eventNumber;
    int step;
    int actionType;//按照action需要几步完成来分类，暂时有两~四步
    //NSString *actionName;
    NSMutableArray *factorArray;
    
    Player *player1;
    Player *player2;
    Player *player3;
    Player *player4;
    NSMutableArray *playerArray;
    
    int pointsToSub;
    NSMutableString *eventString;
    NSMutableArray *eventStringArray;
    
    BOOL newGameFlag;
    
    AVSpeechSynthesizer *synthesizer;
    AVSpeechSynthesisVoice *voice;
    
    NSUserDefaults *defaults;
    BOOL diangangjiayu;
    BOOL zimojiayu;
    BOOL bujiaotuiyu;
    BOOL tishiyin;
    
    int chajiao;
    
    SystemSoundID sound;
}

//代理method
- (void)SettingControllerDidDisapear:(SettingController *)controller
{
    //NSLog(@"调用代理method");
    [self checkSettings];
}

- (void)deleteAllData:(SettingController *)controller;
{
    [self reset];
    [self newGame];
    gameID = 1;
    [self collectFactor];
    [self.tableView reloadData];
    [self showPoints];
}

//很关键，用代码声明类的代理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepare for segue");
    if ([segue.identifier isEqualToString:@"SettingController"]) {
        SettingController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //UI部分
    self.title = @"麻子";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG.png"]];
    UIColor *textColor = [UIColor colorWithRed:(255/255.0f) green:(148/255.0f) blue:0 alpha:1];
    self.pointsLabel1.textColor = textColor;
    self.pointsLabel2.textColor = textColor;
    self.pointsLabel3.textColor = textColor;
    self.pointsLabel4.textColor = textColor;
    
    [self.userButton1 setTitleColor:textColor forState:UIControlStateNormal];
    [self.userButton1 setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
    [self.userButton1 setBackgroundImage:[UIImage imageNamed:@"button1H.png"] forState:UIControlStateHighlighted];
    [self.userButton2 setTitleColor:textColor forState:UIControlStateNormal];
    [self.userButton2 setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
    [self.userButton2 setBackgroundImage:[UIImage imageNamed:@"button1H.png"] forState:UIControlStateHighlighted];
    [self.userButton3 setTitleColor:textColor forState:UIControlStateNormal];
    [self.userButton3 setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
    [self.userButton3 setBackgroundImage:[UIImage imageNamed:@"button1H.png"] forState:UIControlStateHighlighted];
    [self.userButton4 setTitleColor:textColor forState:UIControlStateNormal];
    [self.userButton4 setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
    [self.userButton4 setBackgroundImage:[UIImage imageNamed:@"button1H.png"] forState:UIControlStateHighlighted];
    
    //[self.angangButton setTitleColor:textColor forState:UIControlStateNormal];
    
    NSMutableArray *buttonArray1 = [[NSMutableArray alloc] initWithObjects:self.angangButton, self.diangangButton, self.gouerButton, self.qingheButton, self.liangganButton, self.manheButton, self.jipinButton, self.chaojiButton, self.chaochaoButton, nil];
    for (UIButton *tmpButton in buttonArray1) {
        [tmpButton setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
        [tmpButton setBackgroundImage:[UIImage imageNamed:@"button2H.png"] forState:UIControlStateHighlighted];
    }
    
    NSMutableArray *buttonArray2 = [[NSMutableArray alloc] initWithObjects:self.zimoButton, self.jiepaoButton, self.buheButton, self.bujiaoButton, nil];
    for (UIButton *tmpButton in buttonArray2) {
        [tmpButton setBackgroundImage:[UIImage imageNamed:@"button3.png"] forState:UIControlStateNormal];
        [tmpButton setBackgroundImage:[UIImage imageNamed:@"button3H.png"] forState:UIControlStateHighlighted];
        [tmpButton setTitleColor:[UIColor colorWithRed:(246/255.0f) green:(31/255.0f) blue:(13/255.0f) alpha:1] forState:UIControlStateNormal];
    }
    

    
    // Get user preference
    [self checkSettings];
    
    //发声部分
//    synthesizer = [[AVSpeechSynthesizer alloc] init];
//    voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh_CN"];
//    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"huan ying shi yong ma zi"];
//    utterance.voice = voice;
//    utterance.rate = 0.1;
//    [synthesizer speakUtterance:utterance];
    
    //初始化全局变量
    onlineNumber = 4;
    gameID = 1;
    eventNumber = 1;
    pointsToSub = 0;
    chajiao = 0;
    //newGameFlag = false;
    self.hintLabel.text = @" ";
    //重置指令缓冲器
    [self reset];
    
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
                    gameID = DBgameid + 1;
                }
            }
            sqlite3_close(database);
        }
    }
    
    //创建用户
    player1 = [[Player alloc] init];
    player1.name = @"对家";
    player1.displayName = [NSString stringWithFormat:@"%@", self.userButton1.currentTitle];
    player2 = [[Player alloc] init];
    player2.name = @"下家";
    player2.displayName = [NSString stringWithFormat:@"%@", self.userButton2.currentTitle];
    player3 = [[Player alloc] init];
    player3.name = @"本家";
    player3.displayName = [NSString stringWithFormat:@"%@", self.userButton3.currentTitle];
    player4 = [[Player alloc] init];
    player4.name = @"上家";
    player4.displayName = [NSString stringWithFormat:@"%@", self.userButton4.currentTitle];
    factorArray = [[NSMutableArray alloc] init];
    playerArray = [[NSMutableArray alloc] init];
    [playerArray addObject:player1];
    [playerArray addObject:player2];
    [playerArray addObject:player3];
    [playerArray addObject:player4];
    
    eventString = [NSMutableString stringWithFormat:@"事件%d:", eventNumber];
    eventStringArray = [[NSMutableArray alloc] initWithObjects:@" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", nil];
    [self collectFactor];
    
    //提示用户这是第几局
    //self.hintLabel.text = [NSString stringWithFormat:@"第 %d 局", gameID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) collectFactor
{
    if (step == 0) {
        eventString = [NSMutableString stringWithFormat:@"事件%d:", eventNumber];
    }
    //if (step != 0) {
        for (int i = 0; i < step; i++) {
            NSLog(@"%d", i);
            if (i == 0) {
                eventString = [NSMutableString stringWithFormat:@"事件%d:", eventNumber];
            }
            if ([[factorArray objectAtIndex:i] isKindOfClass:[Player class]]) {
                Player *tmpPlayer = [factorArray objectAtIndex:i];
                [eventString appendString:tmpPlayer.displayName];
            }
            else
            {
                //首先加入动作
                [eventString appendString:[factorArray objectAtIndex:i]];
                //再判断是不是暗杠和勾儿，是的话便加上第三个参数
                if ([[factorArray objectAtIndex:1] isEqualToString:@"暗杠"] || [[factorArray objectAtIndex:1] isEqualToString:@"勾儿"]) {
                    NSMutableString *tmpEventString = [factorArray objectAtIndex:2];
                    if ([tmpEventString rangeOfString:@"对"].location != NSNotFound) {
                        Player *tmpPlayer = [playerArray objectAtIndex:0];
                        [eventString appendString:[NSString stringWithFormat:@" %@", tmpPlayer.displayName]];
                    }
                    if ([tmpEventString rangeOfString:@"下"].location != NSNotFound) {
                        Player *tmpPlayer = [playerArray objectAtIndex:1];
                        [eventString appendString:[NSString stringWithFormat:@" %@", tmpPlayer.displayName]];
                    }
                    if ([tmpEventString rangeOfString:@"本"].location != NSNotFound) {
                        Player *tmpPlayer = [playerArray objectAtIndex:2];
                        [eventString appendString:[NSString stringWithFormat:@" %@", tmpPlayer.displayName]];
                    }
                    if ([tmpEventString rangeOfString:@"上"].location != NSNotFound) {
                        Player *tmpPlayer = [playerArray objectAtIndex:3];
                        [eventString appendString:[NSString stringWithFormat:@" %@", tmpPlayer.displayName]];
                    }
                }
            }
        }
    //}
    [eventStringArray replaceObjectAtIndex:eventNumber-1 withObject:eventString];
    //需要排除掉自摸和点炮等的情况
    if (step == actionType && 0 != step && ![[factorArray objectAtIndex:1] isEqualToString:@"自摸"] && ![[factorArray objectAtIndex:1] isEqualToString:@"接炮"] && ![[factorArray objectAtIndex:1] isEqualToString:@"不和"] && ![[factorArray objectAtIndex:1] isEqualToString:@"不叫"]) {
        [self writeData];
    }
}

- (void) writeData
{
    NSLog(@"Writing to database");
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *insertSQL1 = [NSString stringWithFormat:
                               @"INSERT INTO POINTS (GAMEID, ACTIONNUM, PLAYER1, PLAYER2, PLAYER3, PLAYER4) VALUES (\"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\")", gameID, eventNumber, player1.pointsForAction, player2.pointsForAction, player3.pointsForAction, player4.pointsForAction];
        
        const char *insert_stmt1 = [insertSQL1 UTF8String];
        sqlite3_prepare_v2(database, insert_stmt1,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Points added");
        } else {
            NSLog(@"Failed to add Points");
        }
        sqlite3_finalize(statement);
        
        NSMutableArray *actionTmpArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            if (i < step) {
                if ([[factorArray objectAtIndex:i] isKindOfClass:[Player class]]) {
                    Player *tmpPlayer = [factorArray objectAtIndex:i];
                    [actionTmpArray addObject:tmpPlayer.name];
                }
                else
                    [actionTmpArray addObject:[factorArray objectAtIndex:i]];
            } else if ([[factorArray objectAtIndex:1] isEqualToString:@"暗杠"] || [[factorArray objectAtIndex:1] isEqualToString:@"勾儿"])
            {
                if (i == 2) {
                    [actionTmpArray addObject:[factorArray objectAtIndex:2]];
                } else
                {
                    [actionTmpArray addObject:@"nil"];
                }
            } else
            {
                [actionTmpArray addObject:@"nil"];
            }
            
        }
        NSString *insertSQL2 = [NSString stringWithFormat:
                                @"INSERT INTO ACTIONS (GAMEID, ACTIONNUM, FACTOR1, FACTOR2, FACTOR3, FACTOR4) VALUES (\"%d\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\")", gameID, eventNumber, actionTmpArray[0], actionTmpArray[1], actionTmpArray[2], actionTmpArray[3]];
        
        const char *insert_stmt2 = [insertSQL2 UTF8String];
        sqlite3_prepare_v2(database, insert_stmt2,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Action added");
        } else {
            NSLog(@"Failed to add Points");
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    } else
    {
        NSLog(@"Can not open the database");
    }
}

- (void) checkSettings
{
    defaults = [NSUserDefaults standardUserDefaults];
    diangangjiayu = [defaults boolForKey:@"diangangjiayu"];
    zimojiayu = [defaults boolForKey:@"zimojiayu"];
    bujiaotuiyu = [defaults boolForKey:@"bujiaotuiyu"];
    tishiyin = [defaults boolForKey:@"tishiyin"];
    
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:@"name1"];
    if (value == nil)
    {
        NSLog(@"nil");
        [self.userButton1 setTitle:@"对家" forState:UIControlStateNormal];
    } else
    {
        NSLog(@"not nil");
        [self.userButton1 setTitle:value forState:UIControlStateNormal];
    }
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"name2"]) {
        NSLog(@"nil");
        [self.userButton2 setTitle:@"下家" forState:UIControlStateNormal];
    } else
    {
        NSLog(@"not nil");
        [self.userButton2 setTitle:[[NSUserDefaults standardUserDefaults] stringForKey:@"name2"] forState:UIControlStateNormal] ;
    }
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"name3"]) {
        NSLog(@"nil");
        [self.userButton3 setTitle:@"本家" forState:UIControlStateNormal];
    } else
    {
        NSLog(@"not nil");
        [self.userButton3 setTitle:[[NSUserDefaults standardUserDefaults] stringForKey:@"name3"] forState:UIControlStateNormal] ;
    }
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"name4"]) {
        NSLog(@"nil");
        [self.userButton4 setTitle:@"上家" forState:UIControlStateNormal];
    } else
    {
        NSLog(@"not nil");
        [self.userButton4 setTitle:[[NSUserDefaults standardUserDefaults] stringForKey:@"name4"] forState:UIControlStateNormal] ;
    }
    
    player1.displayName = [NSString stringWithFormat:@"%@", self.userButton1.currentTitle];
    player2.displayName = [NSString stringWithFormat:@"%@", self.userButton2.currentTitle];
    player3.displayName = [NSString stringWithFormat:@"%@", self.userButton3.currentTitle];
    player4.displayName = [NSString stringWithFormat:@"%@", self.userButton4.currentTitle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eventNumber + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"调用tableview delegate");
    static NSString *simpleTableIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSLog(@"nib is nil");
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row == 0) {
        cell.CellLabel.text = [NSString stringWithFormat:@"第 %d 局", gameID];
    } else
    {
        cell.CellLabel.text = [eventStringArray objectAtIndex:indexPath.row - 1];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [indexPath row] * 20;
    return 30;
}

- (void) showPoints
{
    NSLog(@"%d %d %d %d", player1.points, player2.points, player3.points, player4.points);
    self.pointsLabel1.text = [NSString stringWithFormat:@"%d", player1.points];
    self.pointsLabel2.text = [NSString stringWithFormat:@"%d", player2.points];
    self.pointsLabel3.text = [NSString stringWithFormat:@"%d", player3.points];
    self.pointsLabel4.text = [NSString stringWithFormat:@"%d", player4.points];
    
    for (Player *tmpPlayer in playerArray) {
        if (tmpPlayer.online == false) {
            if ([tmpPlayer.name hasPrefix:@"对"] == true) {
                [self.userButton1 setEnabled:NO];
            }
            if ([tmpPlayer.name hasPrefix:@"下"] == true) {
                [self.userButton2 setEnabled:NO];
            }
            if ([tmpPlayer.name hasPrefix:@"本"] == true) {
                [self.userButton3 setEnabled:NO];
            }
            if ([tmpPlayer.name hasPrefix:@"上"] == true) {
                [self.userButton4 setEnabled:NO];
            }
        } else
        {
            if ([tmpPlayer.name hasPrefix:@"对"] == true) {
                [self.userButton1 setEnabled:YES];
            }
            if ([tmpPlayer.name hasPrefix:@"下"] == true) {
                [self.userButton2 setEnabled:YES];
            }
            if ([tmpPlayer.name hasPrefix:@"本"] == true) {
                [self.userButton3 setEnabled:YES];
            }
            if ([tmpPlayer.name hasPrefix:@"上"] == true) {
                [self.userButton4 setEnabled:YES];
            }
        }
    }
    if (1 == onlineNumber && chajiao == 0) {
        NSLog(@"Game over!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息" message:@"这一轮已结束" delegate:self cancelButtonTitle:nil otherButtonTitles:@"开始新一轮", nil];
        [alert show];
    }
    if (0 == onlineNumber && chajiao >= 1) {
        NSLog(@"Game over!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息" message:@"这一轮已结束" delegate:self cancelButtonTitle:nil otherButtonTitles:@"开始新一轮", nil];
        [alert show];
    }
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"开始新一轮");
        [self newGame];
    }
}

- (void) reset
{
    step = 0;
    actionType = 0;
    //actionName = @"Undefined";
    [factorArray removeAllObjects];
    eventString = [NSMutableString stringWithFormat:@"事件%d:", eventNumber];
    
    for (Player *tmpPlayer in playerArray) {
        tmpPlayer.pointsForAction = 0;
        //tmpPlayer.jiao = 1;
    }
}

- (void) newGame
{
    gameID++;
    eventNumber = 1;//因为之后又有一个eventNumber++，，，我擦，为什么checkType后面的函数没有被调用！！！
    for (Player *tmpPlayer in playerArray) {
        tmpPlayer.online = 1;
    }
    onlineNumber = 4;
    [self.userButton1 setEnabled:YES];
    [self.userButton2 setEnabled:YES];
    [self.userButton3 setEnabled:YES];
    [self.userButton4 setEnabled:YES];
    //newGameFlag = true;
    for (Player *tmpPlayer in playerArray) {
        tmpPlayer.points = 0;
        tmpPlayer.jiao = 1;
    }
    //[self showPoints];
    chajiao = 0;
}

- (void) checkType
{
    //判断是不是自摸
    if ([factorArray[1] isEqualToString:@"自摸"]) {
        [self zimo];
        //打印最终暗杠结果
        [self showPoints];
        //重置指令缓冲器
        [self reset];
        //指令序列数加一
        eventNumber++;
        return;
    }
    //判断是不是接炮
    if ([factorArray[1] isEqualToString:@"接炮"]) {
        [self jiepao];
        //打印最终暗杠结果
        [self showPoints];
        //重置指令缓冲器
        [self reset];
        //指令序列数加一
        eventNumber++;
        return;
    }
    //判断是不是不和
    if ([factorArray[1] isEqualToString:@"不和"]) {
        [self buhe];
        //打印最终暗杠结果
        [self showPoints];
        //重置指令缓冲器
        [self reset];
        //指令序列数加一
        eventNumber++;
        return;
    }
    //判断是不是不叫
    if ([factorArray[1] isEqualToString:@"不叫"]) {
        [self bujiao];
        //打印最终暗杠结果
        [self showPoints];
        //重置指令缓冲器
        [self reset];
        //指令序列数加一
        eventNumber++;
        return;
    }
}

- (void) zimo
{
    NSLog(@"开始计算自摸!");
    Player *keyPlayer = [factorArray objectAtIndex:0];
    //利用Fast Enumeration来对剩下的用户进行扣分
    for (Player *tmpPlayer in playerArray) {
        if (true == tmpPlayer.online && false == [tmpPlayer isEqual:keyPlayer])
        {
            if (zimojiayu) {
                NSLog(@"自摸加雨");
                tmpPlayer.pointsForAction = -pointsToSub - 1;
                keyPlayer.pointsForAction += pointsToSub + 1;
                
                tmpPlayer.points -= pointsToSub + 1;
                keyPlayer.points += pointsToSub + 1;
            } else
            {
                NSLog(@"自摸不加雨");
                tmpPlayer.pointsForAction = -pointsToSub;
                keyPlayer.pointsForAction += pointsToSub;
                
                tmpPlayer.points -= pointsToSub;
                keyPlayer.points += pointsToSub;
            }
        }
    }
    [self writeData];
    keyPlayer.online = false;
    onlineNumber--;
}

- (void) jiepao
{
    NSLog(@"开始计算接炮!");
    Player *keyPlayer = [factorArray objectAtIndex:0];
    Player *losePlayer = [factorArray objectAtIndex:2];
    losePlayer.pointsForAction = -pointsToSub;
    keyPlayer.pointsForAction = pointsToSub;
    
    losePlayer.points -= pointsToSub;
    keyPlayer.points += pointsToSub;
    [self writeData];
    keyPlayer.online = false;
    onlineNumber--;
}

- (void) buhe
{
    NSLog(@"开始计算不和!");
    chajiao++;
    Player *keyPlayer = [factorArray objectAtIndex:0];
    for (Player *losePlayer in playerArray) {
        if (losePlayer.jiao == 0) {
            losePlayer.pointsForAction = -pointsToSub;
            keyPlayer.pointsForAction += pointsToSub;
            
            losePlayer.points -= pointsToSub;
            keyPlayer.points += pointsToSub;
        }
    }
    [self writeData];
    keyPlayer.online = false;
    onlineNumber--;
}

- (void) bujiao
{
    NSLog(@"开始计算不叫!");
    chajiao++;
    Player *keyPlayer = [factorArray objectAtIndex:0];
    keyPlayer.jiao = 0;
    
    [self writeData];
    keyPlayer.online = false;
    onlineNumber--;
}

- (IBAction)playerWho:(id)sender {
    Player *tmpPlayer = [[Player alloc] init];
    tmpPlayer = [playerArray objectAtIndex:[sender tag] - 1];
    //容错判断
//    //所按用户是否已经出局
//    if (tmpPlayer.online == false) {
//        self.hintLabel.text = @"这位牌友已经结束牌局了";
//        return;
//    }
    //是否重复输入
    if (step != 0) {
        for (int i = 0; i < step; i++) {
            if ([factorArray objectAtIndex:i] == tmpPlayer) {
                self.hintLabel.text = @"输入重复";
                return;
            }
        }
    }
    //检测按键顺序是否有误
    if (step == 1 || step == 3) {
        self.hintLabel.text = @"输入顺序有误";
        return;
    }
    //是否之前是“自摸”
    if (step != 0) {
        if ([[factorArray objectAtIndex:1] isEqualToString:@"自摸"]) {
            self.hintLabel.text = @"输入有误";
            return;
        }
    }
    //是否之前是“不和”
    if (step != 0) {
        if ([[factorArray objectAtIndex:1] isEqualToString:@"不和"]) {
            self.hintLabel.text = @"输入有误";
            return;
        }
    }
    
    //清除提示消息
    self.hintLabel.text = @" ";
    //将按键次序数变量增一
    step++;
    //将对象插入记录器里
    [factorArray addObject:tmpPlayer];
    NSLog(@"%@", tmpPlayer.displayName);
    if (tishiyin) {
        if ([tmpPlayer.name isEqualToString:@"对家"]) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"对家" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
        }
        if ([tmpPlayer.name isEqualToString:@"下家"]) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"下家" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
        }
        if ([tmpPlayer.name isEqualToString:@"本家"]) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"本家" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
        }
        if ([tmpPlayer.name isEqualToString:@"上家"]) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"上家" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
        }
    }
    
    //判断actionType指定的人数够不够，若够，执行相应的计算
    if (step == actionType) {
        //NSLog(@"Going to calculate!");
        if (3 == actionType) {
            //判断是不是点杠
            if ([factorArray[1] isEqualToString:@"点杠"]) {
                NSLog(@"开始计算点杠!");
                Player *keyPlayer = [factorArray objectAtIndex:0];
                Player *losePlayer = [factorArray objectAtIndex:2];
                //先对点炮的用户直接扣分
                losePlayer.pointsForAction = -2;
                keyPlayer.pointsForAction = 2;
                
                losePlayer.points -= 2;
                keyPlayer.points += 2;
                
                //这里进行点杠加雨规则判断
                if (diangangjiayu) {
                    //利用Fast Enumeration来对剩下的用户进行扣分，在菜单中可以设置
                    for (Player *tmpPlayer in playerArray) {
                        if (true == tmpPlayer.online && false == [tmpPlayer isEqual:keyPlayer] && false == [tmpPlayer isEqual:losePlayer])
                        {
                            tmpPlayer.pointsForAction = -1;
                            keyPlayer.pointsForAction += 1;
                            
                            tmpPlayer.points -= 1;
                            keyPlayer.points += 1;
                        }
                    }
                }
                [self collectFactor];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:eventNumber inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                //打印最终暗杠结果
                [self showPoints];
                //重置指令缓冲器
                [self reset];
                //指令序列数加一
                eventNumber++;
                //必须return，不然还会执行一次collectFactor等
                return;
            }
        }
    }
    NSLog(@"检查点杠时候是否执行!");
    [self collectFactor];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:eventNumber inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction)actionWhich:(id)sender {
    //要是不是第二个键或者第三个键
    if (step != 1 && step != 2) {
        self.hintLabel.text = @"输入顺序有误";
        return;
    }
    //这样可以使用户按错action之后可以很方便的替换action
    if (step == 2) {
        step = 1;
        [factorArray removeObjectAtIndex:1];
    }
    
    //清除提示消息
    self.hintLabel.text = @" ";
    //将按键次序数变量增一
    step++;
    //判断按键
    NSString *tmpName = [NSString stringWithFormat:@"actionWhich"];
    switch ([sender tag]) {
        case 5:
        {
            //声明变量要用括号括起来
            NSLog(@"暗杠！");
            if (tishiyin) {
                NSString *pewPewPath = [[NSBundle mainBundle]
                                        pathForResource:@"暗杠" ofType:@"caf"];
                NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
                AudioServicesPlaySystemSound(sound);
            }
            //设置动作类型
            actionType = 2;
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"暗杠"];
            [factorArray addObject:tmpName];
            //开始计算暗杠
            Player *keyPlayer = [factorArray objectAtIndex:0];
            //利用Fast Enumeration来扣分和加分
            NSMutableString *tmpPlayersString = [NSMutableString stringWithFormat:@" "];
            for (Player *tmpPlayer in playerArray) {
                if (true == tmpPlayer.online && false == [tmpPlayer isEqual:keyPlayer])
                {
                    tmpPlayer.pointsForAction = -2;
                    keyPlayer.pointsForAction += 2;
                    
                    tmpPlayer.points -= 2;
                    keyPlayer.points += 2;
                    
                    [tmpPlayersString appendString:tmpPlayer.name];
                }
            }
            NSLog(@"！！！%@", tmpPlayersString);
            [factorArray addObject:tmpPlayersString];
            [self collectFactor];
            [self.tableView reloadData];
            //打印最终暗杠结果
            [self showPoints];
            //重置指令缓冲器
            [self reset];
            //指令序列数加一
            eventNumber++;
        }
            break;
        case 6:
        {
            NSLog(@"点杠！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"接杠" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作类型
            actionType = 3;
            tmpName = [NSString stringWithFormat:@"点杠"];
            [factorArray addObject:tmpName];
            [self collectFactor];
            [self.tableView reloadData];
        }
            break;
        case 7:
        {
            NSLog(@"勾儿！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"勾儿" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作类型
            actionType = 2;
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"勾儿"];
            [factorArray addObject:tmpName];
            //开始计算暗杠
            Player *keyPlayer = [factorArray objectAtIndex:0];
            //利用Fast Enumeration来扣分和加分
            NSMutableString *tmpPlayersString = [NSMutableString stringWithFormat:@" "];
            for (Player *tmpPlayer in playerArray) {
                if (true == tmpPlayer.online && false == [tmpPlayer isEqual:keyPlayer])
                {
                    tmpPlayer.pointsForAction = -1;
                    keyPlayer.pointsForAction += 1;
                    
                    tmpPlayer.points -= 1;
                    keyPlayer.points += 1;
                    
                    [tmpPlayersString appendString:tmpPlayer.name];
                }
            }
            NSLog(@"！！！%@", tmpPlayersString);
            [factorArray addObject:tmpPlayersString];
            [self collectFactor];
            [self.tableView reloadData];
            //打印最终暗杠结果
            [self showPoints];
            //重置指令缓冲器
            [self reset];
            //指令序列数加一
            eventNumber++;
        }
            break;
        case 8:
        {
            NSLog(@"自摸！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"自摸" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作类型
            actionType = 3;
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"自摸"];
            [factorArray addObject:tmpName];
            [self collectFactor];
            [self.tableView reloadData];
        }
            break;
        case 9:
        {
            NSLog(@"接炮！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"接炮" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作类型
            actionType = 4;
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"接炮"];
            [factorArray addObject:tmpName];
            [self collectFactor];
            [self.tableView reloadData];
        }
            break;
        case 10:
        {
            NSLog(@"不和！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"不和" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            if (chajiao == 0) {
                self.hintLabel.text = @"一定要先输入完所有不叫的牌友哟！";
            }
            //设置动作类型
            actionType = 3;
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"不和"];
            [factorArray addObject:tmpName];
            [self collectFactor];
            [self.tableView reloadData];
        }
            break;
        case 11:
        {
            NSLog(@"不叫！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"不叫" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作类型
            actionType = 2;
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"不叫"];
            [factorArray addObject:tmpName];
            [self collectFactor];
            [self.tableView reloadData];
            
            //这里要特殊一点，需要手动调用checkType
            [self checkType];
        }
            break;
        default:
            break;
    }
}

- (IBAction)typeWhich:(id)sender {
    if (step == 0 || step == 1) {
        self.hintLabel.text = @"输入顺序有误";
        return;
    }
    if (step == 2) {
        if ([[factorArray objectAtIndex:1] isEqualToString:@"接炮"]) {
            self.hintLabel.text = @"输入顺序有误";
            return;
        }
    }
    
    //清除提示消息
    self.hintLabel.text = @" ";
    step++;
    //判断按键
    NSString *tmpName = [NSString stringWithFormat:@"actionWhich"];
    switch ([sender tag]) {
        case 12:
        {
            pointsToSub = 1;
            NSLog(@"清和！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"清和" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"清和"];
        }
            break;
        case 13:
        {
            pointsToSub = 2;
            NSLog(@"两番！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"两番" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"两番"];
        }
            break;
        case 14:
        {
            pointsToSub = 4;
            NSLog(@"满和！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"满和" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"满和"];
        }
            break;
        case 15:
        {
            pointsToSub = 8;
            NSLog(@"极品！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"极品" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"极品"];
        }
            break;
        case 16:
        {
            pointsToSub = 16;
            NSLog(@"超级！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"超级" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"超级"];
        }
            break;
        case 17:
        {
            pointsToSub = 32;
            NSLog(@"超超！");
            if (tishiyin) {
            NSString *pewPewPath = [[NSBundle mainBundle]
                                    pathForResource:@"超超" ofType:@"caf"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
            AudioServicesPlaySystemSound(sound);
            }
            //设置动作名称标记，并加入按键数组
            tmpName = [NSString stringWithFormat:@"超超"];
        }
            break;
        default:
            break;
    }
    [factorArray addObject:tmpName];
    [self collectFactor];
    [self.tableView reloadData];
    
    [self checkType];
}

- (IBAction)undo:(id)sender {
    if (step == 0) {
        //如果一局的事件都被撤销完了
        if (eventNumber == 1) {
            self.hintLabel.text = @"当前暂时不能撤销";
            return;
        }
        if (tishiyin) {
        NSString *pewPewPath = [[NSBundle mainBundle]
                                pathForResource:@"撤销" ofType:@"caf"];
        NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
        AudioServicesPlaySystemSound(sound);
        }
        //先恢复历史表格里的数据
        eventNumber--;
        [eventStringArray replaceObjectAtIndex:eventNumber-1 withObject:@" "];
        [self collectFactor];
        [self.tableView reloadData];
        //查询数据库里的数据
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            //获取数据库书数据以更新初始变量
            //先查询事件，以恢复按钮
            NSString *sqlQuery = @"select factor1, factor2 from actions where ID = (SELECT MAX(ID) FROM actions)";
            sqlite3_stmt * statement;
            
            if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    char *factor1 = (char*)sqlite3_column_text(statement, 0);
                    NSString *nsfactor1 = [[NSString alloc]initWithUTF8String:factor1];
                    char *factor2 = (char*)sqlite3_column_text(statement, 1);
                    NSString *nsfactor2 = [[NSString alloc]initWithUTF8String:factor2];
                    NSLog(@"!!!%@", nsfactor2); NSLog(@"!!!%@", nsfactor1);
                    if ([nsfactor2 isEqualToString:@"自摸"] || [nsfactor2 isEqualToString:@"接炮"] || [nsfactor2 isEqualToString:@"不和"] || [nsfactor2 isEqualToString:@"不叫"]) {
                        if ([nsfactor1 isEqualToString:@"对家"]) {
                            Player *tmpPlayer = [playerArray objectAtIndex:0];
                            tmpPlayer.online = YES;
                            onlineNumber++;
                            if ([nsfactor2 isEqualToString:@"不和"]) {
                                chajiao--;
                            }
                            if ([nsfactor2 isEqualToString:@"不叫"]) {
                                chajiao--;
                                tmpPlayer.jiao = 1;
                            }
                        }
                        if ([nsfactor1 isEqualToString:@"下家"]) {
                            Player *tmpPlayer = [playerArray objectAtIndex:1];
                            tmpPlayer.online = YES;
                            onlineNumber++;
                            if ([nsfactor2 isEqualToString:@"不和"]) {
                                chajiao--;
                            }
                            if ([nsfactor2 isEqualToString:@"不叫"]) {
                                chajiao--;
                                tmpPlayer.jiao = 1;
                            }
                        }
                        if ([nsfactor1 isEqualToString:@"本家"]) {
                            Player *tmpPlayer = [playerArray objectAtIndex:2];
                            tmpPlayer.online = YES;
                            onlineNumber++;
                            if ([nsfactor2 isEqualToString:@"不和"]) {
                                chajiao--;
                            }
                            if ([nsfactor2 isEqualToString:@"不叫"]) {
                                chajiao--;
                                tmpPlayer.jiao = 1;
                            }
                        }
                        if ([nsfactor1 isEqualToString:@"上家"]) {
                            Player *tmpPlayer = [playerArray objectAtIndex:3];
                            tmpPlayer.online = YES;
                            onlineNumber++;
                            if ([nsfactor2 isEqualToString:@"不和"]) {
                                chajiao--;
                            }
                            if ([nsfactor2 isEqualToString:@"不叫"]) {
                                chajiao--;
                                tmpPlayer.jiao = 1;
                            }
                        }
                    } else
                    {
                        NSLog(@"不存在有人离局的情况");
                    }
                }
            }
            
            //删除分数和事件最后一行
            char *errMsg;
            const char *sql_stmt1 =
            "DELETE FROM points WHERE id = (SELECT MAX(id) FROM points)";
            
            if (sqlite3_exec(database, sql_stmt1, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to delete the last row from table: points");
            } else
            {
                NSLog(@"Secceed to delete the last row from table: points");
            }
            
            const char *sql_stmt2 =
            "DELETE FROM actions WHERE id = (SELECT MAX(id) FROM actions)";
            
            if (sqlite3_exec(database, sql_stmt2, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to delete the last row from table: actions");
            } else
            {
                NSLog(@"Secceed to delete the last row from table: actions");
            }
            
            //统计删除后的分数以恢复显示分数
            //首先判断是不是eventNumber是1，如果是的话，执行删除之后再加就加的是上一局的分数了（因为这一局数据库里已经没有数据了）
            if (eventNumber == 1) {
                for (Player *tmpPlayer in playerArray) {
                    tmpPlayer.points = 0;
                }
            } else
            {
                NSString *sqlQuery2 = @"select player1, player2, player3, player4 from Points where GAMEID = (SELECT MAX(GAMEID) FROM points)";
                int pointsForPlayer1 = 0;
                int pointsForPlayer2 = 0;
                int pointsForPlayer3 = 0;
                int pointsForPlayer4 = 0;
                
                if (sqlite3_prepare_v2(database, [sqlQuery2 UTF8String], -1, &statement, nil) == SQLITE_OK) {
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        pointsForPlayer1 += sqlite3_column_int(statement, 0);
                        pointsForPlayer2 += sqlite3_column_int(statement, 1);
                        pointsForPlayer3 += sqlite3_column_int(statement, 2);
                        pointsForPlayer4 += sqlite3_column_int(statement, 3);
                    }
                }
                int i = 0;
                NSArray *pointsForPlayerArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:pointsForPlayer1], [NSNumber numberWithInt:pointsForPlayer2], [NSNumber numberWithInt:pointsForPlayer3], [NSNumber numberWithInt:pointsForPlayer4], nil];
                for (Player *tmpPlayer in playerArray) {
                    NSNumber *tmpNumber = pointsForPlayerArray[i];
                    tmpPlayer.points = tmpNumber.intValue;
                    NSLog(@"%d", tmpPlayer.points);
                    i++;
                }
            }
            sqlite3_close(database);
        } else
        {
            NSLog(@"数据库未打开");
        }
        
        [self showPoints];
        return;
    }
    if (tishiyin) {
    NSString *pewPewPath = [[NSBundle mainBundle]
                            pathForResource:@"撤销" ofType:@"caf"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
    AudioServicesPlaySystemSound(sound);
    }
    [factorArray removeObjectAtIndex:step-1];
    step--;
    [self collectFactor];
    [self.tableView reloadData];
}

@end
