//
//  baoViewController.m
//  SuperDriver
//
//  Created by 王俊钢 on 2017/2/23.
//  Copyright © 2017年 C. All rights reserved.
//

#import "baoViewController.h"
#import "baomingCell0.h"
#import "baomingCell1.h"
@interface baoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *baomingtableview;
@property (nonatomic,strong) UIButton *baomingbtn;
@end
static NSString *baomingcell0 = @"baomingcell0";
static NSString *baomingcell1 = @"baomingcell1";


@implementation baoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.baomingtableview];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.baomingtableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.baomingbtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - getters

-(UITableView *)baomingtableview
{
    if(!_baomingtableview)
    {
        _baomingtableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        _baomingtableview.dataSource = self;
        _baomingtableview.delegate = self;
        _baomingtableview.userInteractionEnabled = YES;//打开用户交互
        
    }
    return _baomingtableview;
}

-(UIButton *)baomingbtn
{
    if(!_baomingbtn)
    {
        _baomingbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-60, DEVICE_WIDTH, 60)];
        [_baomingbtn setTitle:@"报名驾校" forState:normal];
        [_baomingbtn addTarget:self action:@selector(baomingbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _baomingbtn.backgroundColor = [UIColor wjColorFloat:@"008CCF"];
    }
    return _baomingbtn;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        baomingCell0 *cell = [tableView dequeueReusableCellWithIdentifier:baomingcell0];
        if (!cell) {
            cell = [[baomingCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baomingcell0];
        }
        if (indexPath.row==0) {
            cell.leftlabel.text = @"姓名";
            cell.baomingtext.placeholder = @"输入姓名";
            cell.baomingtext.delegate = self;
            cell.baomingtext.tag = 100;
        }
        if (indexPath.row==1) {
            cell.leftlabel.text = @"手机号";
            cell.baomingtext.placeholder = @"输入手机号";
            cell.baomingtext.delegate = self;
            cell.baomingtext.tag = 101;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1) {
        baomingCell1 *cell = [tableView dequeueReusableCellWithIdentifier:baomingcell1];
        if (!cell) {
            cell = [[baomingCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baomingcell1];
        }
        [cell.setbtn setTitle:@"获取验证码" forState:normal];
        cell.settext.delegate = self;
        cell.settext.tag = 102;
        cell.setbtn.tag = 103;
        [cell.setbtn addTarget:self action:@selector(daojis) forControlEvents:UIControlEventTouchUpInside];
        cell.setbtn.backgroundColor = [UIColor wjColorFloat:@"008CCF"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*HEIGHT_SCALE;
}

#pragma mark - 实现方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    UITextField *text1 = [self.baomingtableview viewWithTag:100];
    UITextField *text2 = [self.baomingtableview viewWithTag:101];
    UITextField *text3 = [self.baomingtableview viewWithTag:102];
    [text1 resignFirstResponder];
    [text2 resignFirstResponder];
    [text3 resignFirstResponder];
}

-(void)baomingbtnclick
{
    NSLog(@"报名驾校");
}


-(void)daojis
{
    NSLog(@"倒计时");
    [self startTime];
}

-(void)startTime{
    
    //    [self getvalid];
    UIButton *btn = [self.baomingtableview viewWithTag:103];
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
                
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



@end
