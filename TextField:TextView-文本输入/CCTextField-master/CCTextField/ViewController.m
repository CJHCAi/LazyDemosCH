//
//  ViewController.m
//  CCTextField
//
//  Created by cyd on 2017/9/11.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import "ViewController.h"
#import "CCTextField.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CCTextFieldDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSArray *dataSource;

@property(nonatomic, strong)CCTextField *mark;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(NSArray *)dataSource
{
    return @[@{@"帐号":@(CCCheckAccount)},
             @{@"密码":@(CCCheckPassword)},
             @{@"强密码":@(CCCheckStrongPassword)},
             @{@"邮箱":@(CCCheckEmail)},
             @{@"邮编":@(CCCheckZipCode)},
             @{@"域名":@(CCCheckDomain)},
             @{@"手机号":@(CCCheckPhone)},
             @{@"身份证":@(CCCheckIDCard)},
             @{@"浮点数":@(CCCheckFloat)},
             @{@"日期":@(CCCheckDate)},
             @{@"金额":@(CCCheckMoney)},
             @{@"座机":@(CCCheckTel)}];
}

#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        CCTextField *textField = [[CCTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        textField.layer.borderColor = [UIColor colorWithRed:100/225.0 green:100/225.0 blue:100/225.0 alpha:1].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.delegate = self;
        textField.isTapEnd = YES;

        cell.accessoryView = textField;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithRed:100/225.0 green:100/225.0 blue:100/225.0 alpha:1];
    }
    
    CCTextField *text = (CCTextField *)cell.accessoryView;
    NSDictionary *data = self.dataSource[indexPath.row];
    text.check = [data.allValues.firstObject integerValue];
    cell.textLabel.text = data.allKeys.firstObject;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CCTextFieldDelegate
// iOS10及以上
-(void)textFieldDidEndEditing:(CCTextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    if (textField.checkState == CCTextStateEmpty) {
        NSLog(@"输入内容为空");
    } else if (textField.checkState == CCTextStateNotInLimit) {
        NSLog(@"输入内容必须在(%zd~%zd)字以内",textField.minLimit, textField.maxLimit);
    } else if (textField.checkState == CCTextStateNotRegular) {
        NSLog(@"输入内容不合法");
    }
}

// iOS10以下
-(void)textFieldDidEndEditing:(CCTextField *)textField
{
    if (textField.checkState == CCTextStateEmpty) {
        NSLog(@"输入内容为空");
    } else if (textField.checkState == CCTextStateNotInLimit) {
        NSLog(@"输入内容必须在(%zd~%zd)字以内",textField.minLimit, textField.maxLimit);
    } else if (textField.checkState == CCTextStateNotRegular) {
        NSLog(@"输入内容不合法");
    }
}


@end
