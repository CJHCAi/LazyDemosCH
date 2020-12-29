//
//  MyVideoViewController.m
//  IStone
//
//  Created by 胡传业 on 14-7-20.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import "MyVideoViewController.h"
#import "MenuViewController.h"
@interface MyVideoViewController ()


@end

@implementation MyVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
<<<<<<< HEAD

    
    
    
    
    
    
=======
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory%@",documentsDirectory);
    NSFileManager *fileManage = [NSFileManager defaultManager];
    filesname = [fileManage subpathsAtPath: documentsDirectory];
    NSLog(@"%@",filesname);
    
    
   
>>>>>>> 刘任驰“分支
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


<<<<<<< HEAD

=======
#pragma mark - UItableviewDelegate
>>>>>>> 刘任驰“分支
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
<<<<<<< HEAD
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MYvideoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    
    
    
    
    
    
    
    
    
    return cell;
}


=======
    return [filesname count]; //返回cell行数
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MYvideoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths objectAtIndex:0];
    NSLog(@"path:%@", path);
    cell.textLabel.text =filesname[indexPath.row];
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   MPMoviePlayerViewController* playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/private%@/%@",path,filesname[indexPath.row] ]]];
    NSLog(@"%@",[NSString stringWithFormat:@"file://localhost/private%@/%@",path,filesname[indexPath.row]]);//测试
    [self presentViewController:playerView animated:YES completion:nil];
}

#pragma mark -
>>>>>>> 刘任驰“分支


















-(IBAction)showMenu {
    [self.frostedViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
