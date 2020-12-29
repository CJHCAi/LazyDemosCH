//
//  MeViewController.m
//  StepUp
//
//  Created by syfll on 15/6/13.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "MeViewController.h"
#import "ShowPicCell.h"
#import "FollowerCell.h"
#import "MeAccessoryDetailDisclosuerCell.h"



#define FontSize 23.0f
@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    #pragma mark 设置标题栏(最顶上那一条有信号什么的东西)&标题为白色
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    //初始化导航栏
    [self initMyNaviItem];
    
    //注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowPicCell" bundle:nil] forCellReuseIdentifier:@"ShowPicCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FollowerCell" bundle:nil] forCellReuseIdentifier:@"FollowerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MeAccessoryDetailDisclosuerCell" bundle:nil] forCellReuseIdentifier:@"MeAccessoryDetailDisclosuerCell"];

    //这句话可以隐藏下面没有的分割线
    self.tableView.tableFooterView = [[UIView alloc]init];
    


}
#pragma mark - 初始化NaviItem
-(void)initMyNaviItem{
    //找导航栏背景请转DSNavigationBar
    //导航栏在StoryBoard->navigationController->navigationBar
    
    //自定义标题
    UIButton * title = [UIButton buttonWithType:UIButtonTypeSystem];
    title.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [title setTitle:@"账号" forState:UIControlStateNormal];
    [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [title setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = title;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section == 0)
        return 2;
    else{
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0 &indexPath.row == 0 ) {
        //背景图片和头像的Cell
        ShowPicCell *s_cell = [tableView dequeueReusableCellWithIdentifier:@"ShowPicCell" forIndexPath:indexPath];
        [s_cell.headImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:s_cell.headImage
                                                                                      action:@selector(headImageClick)]];
        cell = s_cell;
        
    }else if (indexPath.section == 0 &indexPath.row == 1 ){
        //关注、粉丝的Cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerCell" forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 2, 3, 4);
    }else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"MeAccessoryDetailDisclosuerCell" forIndexPath:indexPath];
                cell.textLabel.text = @"日程收藏";
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"MeAccessoryDetailDisclosuerCell" forIndexPath:indexPath];
                cell.textLabel.text = @"消息";
                break;
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:@"MeAccessoryDetailDisclosuerCell" forIndexPath:indexPath];
                cell.textLabel.text = @"设置";
                break;
                
            default:
                break;
        }
    }
    
    
    // Configure the cell...
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
-(void)headImageClick{
    NSLog(@"headImageClick");
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
