//
//  LanguageViewController.m
//  多语言切换demo
//
//  Created by 黄坚 on 2018/3/19.
//  Copyright © 2018年 黄坚. All rights reserved.
//

#import "LanguageViewController.h"

@interface LanguageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *languageArray;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end

@implementation LanguageViewController
-(NSArray *)languageArray
{
    if (!_languageArray) {
        _languageArray=@[@"简体中文",@"English"];
    }
    return _languageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:languageStr(@"language_leftitem") style:UIBarButtonItemStylePlain target:self action:@selector(backToPersonal)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:languageStr(@"language_rightitem") style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    [self setDefaultLanguage];
    [self setTableView];
    
}
-(void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle=leftTitle;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(backToPersonal)];
}
-(void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle=rightTitle;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
}

-(void)backToPersonal
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)back
{
    UIActivityIndicatorView *ac=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    ac.center=self.view.center;
    ac.hidesWhenStopped=YES;
    ac.color=[UIColor orangeColor];
    [self.view addSubview:ac];
    [ac startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ac stopAnimating];
        [self.navigationController popViewControllerAnimated:YES];
    });
}
-(void)setDefaultLanguage
{
    // 假装只有两种语言·=-= ·
    if([[LocalizationManager userLanguage] isEqualToString:@"en"])
    {
        self.indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    }
    else
    {
        self.indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
}
-(void)confirm
{
    [[NSUserDefaults standardUserDefaults]setObject:languageStr(@"language_leftitem") forKey:@"back"];
    [[NSUserDefaults standardUserDefaults]setObject:languageStr(@"language_rightitem") forKey:@"save"];
    [[NSUserDefaults standardUserDefaults]setObject:languageStr(@"language_mine") forKey:@"title"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (self.indexPath.row==0) {
        [LocalizationManager setUserlanguage:@"zh-Hans"];
    }else if (self.indexPath.row==1)
    {
        [LocalizationManager setUserlanguage:@"en"];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.languageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"languageCell"];
    cell.textLabel.text=self.languageArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==self.indexPath.row) {
        cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选中"]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath=indexPath;
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(void)setTableView
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.scrollEnabled=NO;
    tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tableView];
    tableView.sectionFooterHeight=0;
    tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, CGFLOAT_MIN)];
    self.tableView=tableView;
}
@end
