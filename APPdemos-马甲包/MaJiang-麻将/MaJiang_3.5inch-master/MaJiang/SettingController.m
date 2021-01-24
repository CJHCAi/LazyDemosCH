//
//  SettingController.m
//  MaJiang
//
//  Created by yu_hao on 1/14/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import "SettingController.h"

#import "sqlite3.h"

@interface SettingController ()
{
    NSUserDefaults *defaults;
    
    NSString *databasePath;
    sqlite3 *database;
}
@end

@implementation SettingController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    //self.title = @"规则设置";//没有View就没用？？？//不是，是因为这个函数就没有被调用！
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"Setting Controller");
    
    // Get user preference
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:@"name1"];
    if (value == nil)
    {
        NSLog(@"nil");
        self.name1.placeholder = @"对家";
    } else
    {
        NSLog(@"not nil");
        self.name1.placeholder = value;
    }
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"name2"]) {
        NSLog(@"nil");
        self.name2.placeholder = @"下家";
    } else
    {
        NSLog(@"not nil");
        self.name2.placeholder = [[NSUserDefaults standardUserDefaults] stringForKey:@"name2"];
    }
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"name3"]) {
        NSLog(@"nil");
        self.name3.placeholder = @"本家";
    } else
    {
        NSLog(@"not nil");
        self.name3.placeholder = [[NSUserDefaults standardUserDefaults] stringForKey:@"name3"];
    }
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"name4"]) {
        NSLog(@"nil");
        self.name4.placeholder = @"上家";
    } else
    {
        NSLog(@"not nil");
        self.name4.placeholder = [[NSUserDefaults standardUserDefaults] stringForKey:@"name4"];
    }
    
    BOOL diangangjiayu = [defaults boolForKey:@"diangangjiayu"];
    BOOL zimojiayu = [defaults boolForKey:@"zimojiayu"];
    BOOL bujiaotuiyu = [defaults boolForKey:@"bujiaotuiyu"];
    BOOL tishiyin = [defaults boolForKey:@"tishiyin"];
    [self.diangangjiayu setOn:diangangjiayu];
    [self.zimojiayu setOn:zimojiayu];
    [self.bujiaotuiyu setOn:bujiaotuiyu];
    [self.tishiyin setOn:tishiyin];
}

//帅气！！！
- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"setting controller: viewWillDisappear");
    [self.delegate SettingControllerDidDisapear:self];
}

- (void)delegateDelete
{
    NSLog(@"setting controller: deleteAllData");
    [self.delegate deleteAllData:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)setdiangangjiayu:(id)sender {
    BOOL state = [sender isOn];
    if (state) {
        NSLog(@"on");
    } else{
        NSLog(@"off");
    }
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:state ? @"YES" : @"NO"
//                                                            forKey:@"diangangjiayu"];
//    [defaults registerDefaults:appDefaults];
//    if([defaults synchronize])
//    {
//        NSLog(@"synchronize successfully!");
//    }
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:state forKey:@"diangangjiayu"];
    [defaults synchronize];
}

- (IBAction)setzimojiayu:(id)sender {
    BOOL state = [sender isOn];
    if (state) {
        NSLog(@"on");
    } else{
        NSLog(@"off");
    }
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:state forKey:@"zimojiayu"];
    [defaults synchronize];
}

- (IBAction)setbujiaotuiyu:(id)sender {
    BOOL state = [sender isOn];
    if (state) {
        NSLog(@"on");
    } else{
        NSLog(@"off");
    }
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:state forKey:@"bujiaotuiyu"];
    [defaults synchronize];
}

- (IBAction)settishiyin:(id)sender {
    BOOL state = [sender isOn];
    if (state) {
        NSLog(@"on");
    } else{
        NSLog(@"off");
    }
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:state forKey:@"tishiyin"];
    [defaults synchronize];
}

- (IBAction)setname1:(id)sender {
    [defaults setValue:self.name1.text forKey:@"name1"];
    [defaults synchronize];
}

- (IBAction)setname2:(id)sender {
    [defaults setValue:self.name2.text forKey:@"name2"];
    [defaults synchronize];
}

- (IBAction)setname3:(id)sender {
    [defaults setValue:self.name3.text forKey:@"name3"];
    [defaults synchronize];
}

- (IBAction)setname4:(id)sender {
    [defaults setValue:self.name4.text forKey:@"name4"];
    [defaults synchronize];
}

- (IBAction)clearAllData:(id)sender {
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
        char *errMsg;
        const char *sql_stmt1 =
        "DELETE FROM points";
        
        if (sqlite3_exec(database, sql_stmt1, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to delete the last row from table: points");
        } else
        {
            NSLog(@"Secceed to delete the last row from table: points");
        }
        const char *sql_stmt2 =
        "DELETE FROM ACTIONS";
        
        if (sqlite3_exec(database, sql_stmt2, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to delete ALL from table: ACTIONS");
        } else
        {
            NSLog(@"Secceed to delete ALL from table: ACTIONS");
        }
        
        sqlite3_close(database);
    }
    
    //告诉delegate也删除数据
    [self delegateDelete];
}

@end
