//
//  logupViewController.m
//  SuperDirvers
//
//  Created by 王俊钢 on 2017/2/20.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "logupViewController.h"
#import "logupCell.h"
#import "logupCell2.h"
@interface logupViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *loguptableview;
@property (nonatomic,strong) UIButton *logupbtn;
@property (nonatomic,strong) UIView *topview;

@end
static NSString *logupidentfid0 = @"logupidentfid0";
static NSString *logupidentfid1 = @"logupidentfid1";
@implementation logupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.loguptableview];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:self.topview];
    self.loguptableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.logupbtn];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - getters

-(UITableView *)loguptableview
{
    if(!_loguptableview)
    {
        _loguptableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _loguptableview.dataSource = self;
        _loguptableview.delegate = self;
        _loguptableview.scrollEnabled = NO;
    }
    return _loguptableview;
}

-(UIView *)topview
{
    if(!_topview)
    {
        _topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
        _topview.backgroundColor = [UIColor wjColorFloat:@"008CCF"];
    }
    return _topview;
}

-(UIButton *)logupbtn
{
    if(!_logupbtn)
    {
        _logupbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-60, DEVICE_WIDTH, 60)];
        [_logupbtn setTitle:@"注册" forState:normal];
        [_logupbtn addTarget:self action:@selector(zucebtnclick) forControlEvents:UIControlEventTouchUpInside];
        _logupbtn.backgroundColor = [UIColor wjColorFloat:@"008CCF"];
    }
    return _logupbtn;
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
        logupCell *cell = [tableView dequeueReusableCellWithIdentifier:logupidentfid0];
        if (!cell) {
            cell = [[logupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logupidentfid0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            cell.leftlab.text = @"手机号";
            cell.logtext.placeholder = @"请输入手机号";
            cell.logtext.delegate = self;
            cell.logtext.tag = 100;
        }
        if (indexPath.row==1) {
            cell.leftlab.text = @"密码";
            cell.logtext.placeholder = @"请输入密码";
            cell.logtext.delegate = self;
            cell.logtext.tag = 101;
        }
        return cell;
    }
    else
    {
        logupCell2 *cell = [tableView dequeueReusableCellWithIdentifier:logupidentfid1];
        if (!cell) {
            cell = [[logupCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logupidentfid1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.loguptext.placeholder = @"请输入验证码";
        cell.loguptext.delegate = self;
        cell.loguptext.tag = 102;
        cell.yanzhengmabtn.tag = 103;
        [cell.yanzhengmabtn addTarget:self action:@selector(yanzhengma) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50*HEIGHT_SCALE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)yanzhengma
{
    [self startTime];
}

-(void)startTime{
    
    //    [self getvalid];
    UIButton *btn = [self.loguptableview viewWithTag:103];
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
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    UITextField *text1 = [self.loguptableview viewWithTag:100];
    UITextField *text2 = [self.loguptableview viewWithTag:101];
    UITextField *text3 = [self.loguptableview viewWithTag:102];
    [text1 resignFirstResponder];
    [text2 resignFirstResponder];
    [text3 resignFirstResponder];
}

-(void)zucebtnclick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
