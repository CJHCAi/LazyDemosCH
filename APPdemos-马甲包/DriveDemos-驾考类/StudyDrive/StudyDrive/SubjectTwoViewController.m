//
//  SubjectTwoViewController.m
//  StudyDrive
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SubjectTwoViewController.h"
#import "SubjectTwoTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
@interface SubjectTwoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong) NSMutableArray *titleArray;
@end

@implementation SubjectTwoViewController

-(NSMutableArray*)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"方向盘的操作方法",@"刹车和油门的操作方法",@"油门离合器配合的操作方法", nil];
    }
    return _titleArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"SubjectTwoTableViewCell";
    SubjectTwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellId owner:self options:nil]lastObject];
    }
    cell.titleImageView.image=[UIImage imageNamed:@"subject.png"];
    cell.theTitleLabel.text=self.titleArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"shipin0%ld",indexPath.row+1] ofType:@"mp4"];
    NSURL * url = [NSURL fileURLWithPath:path];
    MPMoviePlayerViewController * movie = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    movie.moviePlayer.shouldAutoplay = YES;
    [self.navigationController pushViewController:movie animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
