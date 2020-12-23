//
//  LCMainViewController.m
//  LoanCaculator
//
//  Created by lingyi xu on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LCMainViewController.h"
#import "LCOptionsViewController.h"

#define sectionOfRepayTypeAndLoanTypeNum 0
#define sectionOfCaculateTypeNum 1
#define sectionOfUnitPriceAndAreaAndMortgagepercentNum 2
#define sectionOfTotalPriceNum 3
#define sectionOfBizTotalAndFoundTotalNum 4
#define sectionOfMortgageyearsAndRateNum 5

@interface LCMainViewController (Private)

- (BOOL)isPureInt:(NSString *)string;
- (void)textFieldInput:(UITextField *)textField;
- (void)caculateAction:(UIBarButtonItem *)button;
- (float)getSumMonthRepay:(float)rate putTotal:(int)total putMonth:(int)month putCurMonth:(int)curMonth;
- (float)getRateMonthRepay:(float)rate putTotal:(int)total putMonth:(int)month;

@end

@implementation LCMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"房屋贷款计算器";
    
    UIBarButtonItem *caculateButton = [[UIBarButtonItem alloc] initWithTitle:@"计算" style:UIBarButtonItemStyleBordered target:self action:@selector(caculateAction:)];
    self.navigationItem.rightBarButtonItem = caculateButton;
    [caculateButton release];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        isIphone5 = true;
    }else{
        isIphone5 = false;
    }
    
    _caculatorModel = [LCCaculatorModel instance];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 504) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    
    [_scrollView addSubview:_tableView];
    
    [_tableView release];
}

- (void) viewWillAppear:(BOOL)animated {
    //用于选中的取消
    //[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:animated];
    [_tableView reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
        case sectionOfRepayTypeAndLoanTypeNum:
            rows = [_caculatorModel.sectionOfRepayTypeAndLoanType count];
            break;
        case sectionOfCaculateTypeNum:
            if(_caculatorModel.showSectionOfCaculateType){
                rows = [_caculatorModel.sectionOfCaculateType count];
            }
            break;
        case sectionOfUnitPriceAndAreaAndMortgagepercentNum:
            if(_caculatorModel.showSectionOfUnitPriceAndAreaAndMortgagepercent){
                rows = [_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent count];
            }
            break;
        case sectionOfTotalPriceNum:
            if(_caculatorModel.showSectionOfTotalPrice){
                rows = [_caculatorModel.sectionOfTotalPrice count];
            }
            break;
        case sectionOfBizTotalAndFoundTotalNum:
            if(_caculatorModel.showSectionOfBizTotalAndFoundTotal){
                rows = [_caculatorModel.sectionOfBizTotalAndFoundTotal count];
            }
            break;
        case sectionOfMortgageyearsAndRateNum:
            rows = [_caculatorModel.sectionOfMortgageyearsAndRate count];
            break;
        default:
            break;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.0f;
    
    switch (section) {
        case sectionOfRepayTypeAndLoanTypeNum:
            height = 5.0f;
            break;
        case sectionOfCaculateTypeNum:
            if(_caculatorModel.showSectionOfCaculateType){
                height = 5.0f;
            }
            break;
        case sectionOfUnitPriceAndAreaAndMortgagepercentNum:
            if(_caculatorModel.showSectionOfUnitPriceAndAreaAndMortgagepercent){
                height = 5.0f;
            }
            break;
        case sectionOfTotalPriceNum:
            if(_caculatorModel.showSectionOfTotalPrice){
                height = 5.0f;
            }
            break;
        case sectionOfBizTotalAndFoundTotalNum:
            if(_caculatorModel.showSectionOfBizTotalAndFoundTotal){
                height = 5.0f;
            }
            break;
        case sectionOfMortgageyearsAndRateNum:
            height = 5.0f;
            break;
        default:
            break;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.0f;
    
    switch (section) {
        case sectionOfRepayTypeAndLoanTypeNum:
            height = 5.0f;
            break;
        case sectionOfCaculateTypeNum:
            if(_caculatorModel.showSectionOfCaculateType){
                height = 5.0f;
            }
            break;
        case sectionOfUnitPriceAndAreaAndMortgagepercentNum:
            if(_caculatorModel.showSectionOfUnitPriceAndAreaAndMortgagepercent){
                height = 5.0f;
            }
            break;
        case sectionOfTotalPriceNum:
            if(_caculatorModel.showSectionOfTotalPrice){
                height = 5.0f;
            }
            break;
        case sectionOfBizTotalAndFoundTotalNum:
            if(_caculatorModel.showSectionOfBizTotalAndFoundTotal){
                height = 5.0f;
            }
            break;
        case sectionOfMortgageyearsAndRateNum:
            height = 5.0f;
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }else{
        cell = nil;
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.section) {
        case sectionOfRepayTypeAndLoanTypeNum:
            cell.textLabel.text = [[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.detailTextLabel.text = [[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:indexPath.row] objectAtIndex:1];
            if([[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            break;
        case sectionOfCaculateTypeNum:
            cell.textLabel.text = [[_caculatorModel.sectionOfCaculateType objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.detailTextLabel.text = [[_caculatorModel.sectionOfCaculateType objectAtIndex:indexPath.row] objectAtIndex:1];
            if([[[_caculatorModel.sectionOfCaculateType objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            break;
        case sectionOfUnitPriceAndAreaAndMortgagepercentNum:
            cell.textLabel.text = [[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.detailTextLabel.text = [[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:indexPath.row] objectAtIndex:1];
            if([[[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(200, 5, 100, 30)];
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.text = [[[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@""]?@"0":[[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:indexPath.row] objectAtIndex:2];
                textField.delegate = self;
                textField.tag = [[[NSString stringWithFormat:@"%d",indexPath.section] stringByAppendingFormat:@"%d",indexPath.row] intValue];
                textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                [textField addTarget:self action:@selector(textFieldInput:) forControlEvents:UIControlEventEditingDidEnd];
                
                [cell addSubview:textField];
                
                [textField release];
            }
            break;
        case sectionOfTotalPriceNum:
            cell.textLabel.text = [[_caculatorModel.sectionOfTotalPrice objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.detailTextLabel.text = [[_caculatorModel.sectionOfTotalPrice objectAtIndex:indexPath.row] objectAtIndex:1];
            if([[[_caculatorModel.sectionOfTotalPrice objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(200, 5, 100, 30)];
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.text = [[[_caculatorModel.sectionOfTotalPrice objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@""]?@"0":[[_caculatorModel.sectionOfTotalPrice objectAtIndex:indexPath.row] objectAtIndex:2];
                textField.delegate = self;
                textField.tag = [[[NSString stringWithFormat:@"%d",indexPath.section] stringByAppendingFormat:@"%d",indexPath.row] intValue];
                textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                [textField addTarget:self action:@selector(textFieldInput:) forControlEvents:UIControlEventEditingDidEnd];
                
                [cell addSubview:textField];
                
                [textField release];
            }
            break;
        case sectionOfBizTotalAndFoundTotalNum:
            cell.textLabel.text = [[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.detailTextLabel.text = [[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:indexPath.row] objectAtIndex:1];
            if([[[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(200, 5, 100, 30)];
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.text = [[[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@""]?@"0":[[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:indexPath.row] objectAtIndex:2];
                textField.delegate = self;
                textField.tag = [[[NSString stringWithFormat:@"%d",indexPath.section] stringByAppendingFormat:@"%d",indexPath.row] intValue];
                textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                [textField addTarget:self action:@selector(textFieldInput:) forControlEvents:UIControlEventEditingDidEnd];
                
                [cell addSubview:textField];
                
                [textField release];
            }
            break;
        case sectionOfMortgageyearsAndRateNum:
            cell.textLabel.text = [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.detailTextLabel.text = [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:indexPath.row] objectAtIndex:1];
            if([[[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    switch (indexPath.section) {
        case sectionOfRepayTypeAndLoanTypeNum:
            if([[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                LCOptionsViewController *optionsViewController = [[LCOptionsViewController alloc] initWithNibName:@"LCOptionsViewController" bundle:nil];
                optionsViewController.whichOption = [[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:indexPath.row] objectAtIndex:4] intValue];
                optionsViewController.currentSelect = [[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:indexPath.row] objectAtIndex:2];
                [self.navigationController pushViewController:optionsViewController animated:YES];
                [optionsViewController release];
            }
            break;
        case sectionOfCaculateTypeNum:
            if([[[_caculatorModel.sectionOfCaculateType objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                LCOptionsViewController *optionsViewController = [[LCOptionsViewController alloc] initWithNibName:@"LCOptionsViewController" bundle:nil];
                optionsViewController.whichOption = [[[_caculatorModel.sectionOfCaculateType objectAtIndex:indexPath.row] objectAtIndex:4] intValue];
                optionsViewController.currentSelect = [[_caculatorModel.sectionOfCaculateType objectAtIndex:indexPath.row] objectAtIndex:2];
                [self.navigationController pushViewController:optionsViewController animated:YES];
                [optionsViewController release];
            }
            break;
        case sectionOfUnitPriceAndAreaAndMortgagepercentNum:
            if([[[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                LCOptionsViewController *optionsViewController = [[LCOptionsViewController alloc] initWithNibName:@"LCOptionsViewController" bundle:nil];
                optionsViewController.whichOption = [[[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:indexPath.row] objectAtIndex:4] intValue];
                optionsViewController.currentSelect = [[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:indexPath.row] objectAtIndex:2];
                [self.navigationController pushViewController:optionsViewController animated:YES];
                [optionsViewController release];
            }
            break;
        case sectionOfTotalPriceNum:
            if([[[_caculatorModel.sectionOfTotalPrice objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                LCOptionsViewController *optionsViewController = [[LCOptionsViewController alloc] initWithNibName:@"LCOptionsViewController" bundle:nil];
                optionsViewController.whichOption = [[[_caculatorModel.sectionOfTotalPrice objectAtIndex:indexPath.row] objectAtIndex:4] intValue];
                optionsViewController.currentSelect = [[_caculatorModel.sectionOfTotalPrice objectAtIndex:indexPath.row] objectAtIndex:2];
                [self.navigationController pushViewController:optionsViewController animated:YES];
                [optionsViewController release];
            }
            break;
        case sectionOfBizTotalAndFoundTotalNum:
            if([[[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                LCOptionsViewController *optionsViewController = [[LCOptionsViewController alloc] initWithNibName:@"LCOptionsViewController" bundle:nil];
                optionsViewController.whichOption = [[[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:indexPath.row] objectAtIndex:4] intValue];
                optionsViewController.currentSelect = [[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:indexPath.row] objectAtIndex:2];
                [self.navigationController pushViewController:optionsViewController animated:YES];
                [optionsViewController release];
            }
            break;
        case sectionOfMortgageyearsAndRateNum:
            if([[[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"1"]){
                LCOptionsViewController *optionsViewController = [[LCOptionsViewController alloc] initWithNibName:@"LCOptionsViewController" bundle:nil];
                optionsViewController.whichOption = [[[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:indexPath.row] objectAtIndex:4] intValue];
                optionsViewController.currentSelect = [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:indexPath.row] objectAtIndex:2];
                [self.navigationController pushViewController:optionsViewController animated:YES];
                [optionsViewController release];
            }
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    
    switch (textField.tag) {
        case 21:
            if (!isIphone5) {
                [_scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
            }
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [textField.text isEqualToString:@""]?@"0":textField.text;
    
    switch (textField.tag) {
        case 21:
            if (!isIphone5) {
                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    switch (textField.tag) {
        case 21:
            if (!isIphone5) {
                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            break;
        default:
            break;
    }
    
    textField.text = [textField.text isEqualToString:@""]?@"0":textField.text;
    
    if([self isPureInt:textField.text]){
        return YES;
    }else {
        textField.text = @"0";
        return NO;
    }
}

#pragma mark - Custom Methods

//判断输入是否是数字
- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    int val; 
    return[scan scanInt:&val] && [scan isAtEnd];
}

//输入保存
- (void)textFieldInput:(UITextField *)textField
{
    switch (textField.tag) {
        case 20:
            [[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:0] replaceObjectAtIndex:2 withObject:textField.text];
            break;
        case 21:
            [[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:1] replaceObjectAtIndex:2 withObject:textField.text];
            break;
        case 30:
            [[_caculatorModel.sectionOfTotalPrice objectAtIndex:0] replaceObjectAtIndex:2 withObject:textField.text];
            break;
        case 40:    
            [[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:0] replaceObjectAtIndex:2 withObject:textField.text];
            break;
        case 41:
            [[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:1] replaceObjectAtIndex:2 withObject:textField.text];
            break;
        default:
            break;
    }
}

#pragma mark - Core caculate Methods
//计算
- (void)caculateAction:(UIBarButtonItem *)button
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //定义局部变量
    int bizVal; //商业贷款
    int foundVal; //公积金
    int totalVal; //总价 (单位*面积 或者 总价 或者 商贷+公积金)
    
    int totalMonth = [[[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:0] objectAtIndex:2] intValue] * 12; //按揭月数
    
    float bizRate = 0.0; //商业贷款利率
    float foundRate = 0.0; //公积金贷款利率
    
    //获取当前选择的汇率
    switch ([[[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] objectAtIndex:2] intValue]) {
        case 0:
            foundRate = 0.047; //6年－30年 公积金
            break;
        case 1:
            foundRate = 0.042; //1年-5年 公积金
            break;
        case 2:
            bizRate = 0.068; // 6年-30年 商贷
            break;
        case 3:
            bizRate = 0.0665; // 4年,5年 商贷
            break;
        case 4:
            bizRate = 0.064; // 2年,3年 商贷
            break;
        case 5:
            bizRate = 0.0631; // 1年 商贷
            break;
        case 6:
            foundRate = 0.047; //6年－30年 组合
            bizRate = 0.068;
            break;
        case 7:
            foundRate = 0.042; //4,5年 组合
            bizRate = 0.0665;
            break;
        case 8:
            foundRate = 0.042; //2,3年 组合
            bizRate = 0.064;
            break;
        case 9:
            foundRate = 0.042; //1年 组合
            bizRate = 0.0631;
            break;
        default:
            break;
    }
    
    float repayMonth; //月均还款 或者 每个月还款金额
    float repayTotal = 0.0; //还款总额
    float repayAccrual; //支付利息
    
    [_caculatorModel.resultTitle removeAllObjects];
    [_caculatorModel.resultPerMonthRepay removeAllObjects];
    
    //组合型
    if([[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:1] objectAtIndex:2] isEqualToString:@"2"]){
        bizVal = [[[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:0] objectAtIndex:2] intValue] * 10000;
        foundVal = [[[_caculatorModel.sectionOfBizTotalAndFoundTotal objectAtIndex:1] objectAtIndex:2] intValue] * 10000;
        
        totalVal = bizVal + foundVal;
        
        //等额本金
        if([[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:0] objectAtIndex:2] isEqualToString:@"1"]){
            for (int i=0; i<totalMonth; i++) {
                repayMonth = [self getSumMonthRepay:foundRate putTotal:foundVal putMonth:totalMonth putCurMonth:i] + [self getSumMonthRepay:bizRate putTotal:bizVal putMonth:totalMonth putCurMonth:i];
                repayTotal += repayMonth;
                
                [_caculatorModel.resultPerMonthRepay addObject:[[[[NSString stringWithFormat:@"%d",(i+1)] stringByAppendingString:@"月 - "] stringByAppendingFormat:@"%.2f",repayMonth] stringByAppendingString:@"元"]];
            }
            
            repayAccrual = repayTotal - totalVal;
            
            [_caculatorModel.resultTitle addObject:@"计算结果(组合型 - 等额本金)"];
            [_caculatorModel.resultTitle addObject:[@"贷款总额:" stringByAppendingFormat:@"%d",totalVal]];
            [_caculatorModel.resultTitle addObject:[@"还款总额:" stringByAppendingFormat:@"%.2f",repayTotal]];
            [_caculatorModel.resultTitle addObject:[@"支付利息:" stringByAppendingFormat:@"%.2f",repayAccrual]];
            [_caculatorModel.resultTitle addObject:[@"贷款月数:" stringByAppendingFormat:@"%d",totalMonth]];
        }
        //等额本息
        else{
            repayMonth = [self getRateMonthRepay:foundRate putTotal:foundVal putMonth:totalMonth] + [self getRateMonthRepay:bizRate putTotal:bizVal putMonth:totalMonth];
            repayTotal = repayMonth * totalMonth;
            repayAccrual = repayTotal - totalVal;
            
            [_caculatorModel.resultTitle addObject:@"计算结果(组合型 - 等额本息)"];
            [_caculatorModel.resultTitle addObject:[@"贷款总额:" stringByAppendingFormat:@"%d",totalVal]];
            [_caculatorModel.resultTitle addObject:[@"支付利息:" stringByAppendingFormat:@"%.2f",repayAccrual]];
            [_caculatorModel.resultTitle addObject:[@"贷款月数:" stringByAppendingFormat:@"%d",totalMonth]];
            [_caculatorModel.resultTitle addObject:[@"月均还款:" stringByAppendingFormat:@"%.2f",repayMonth]];
        }
    }
    //公积金或者商业贷款
    else{
        float currentRate;
        NSString *title;
        
        if([[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:1] objectAtIndex:2] isEqualToString:@"0"]){
            currentRate = foundRate;
            if([[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:0] objectAtIndex:2] isEqualToString:@"1"]){
                title = @"计算结果(公积金 - 等额本金)";
            }else{
                title = @"计算结果(公积金 - 等额本息)";
            }
        }else{
            currentRate = bizRate;
            if([[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:0] objectAtIndex:2] isEqualToString:@"1"]){
                title = @"计算结果(商业贷款 - 等额本金)";
            }else{
                title = @"计算结果(商业贷款 - 等额本息)";
            }
        }
        
        //根据总价
        if([[[_caculatorModel.sectionOfCaculateType objectAtIndex:0] objectAtIndex:2] isEqualToString:@"1"]){
            totalVal = [[[_caculatorModel.sectionOfTotalPrice objectAtIndex:0] objectAtIndex:2] intValue] * 10000;
            
            //等额本金
            if([[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:0] objectAtIndex:2] isEqualToString:@"1"]){
                for (int i=0; i<totalMonth; i++) {
                    repayMonth = [self getSumMonthRepay:currentRate putTotal:totalVal putMonth:totalMonth putCurMonth:i];
                    repayTotal += repayMonth;
                    
                    [_caculatorModel.resultPerMonthRepay addObject:[[[[NSString stringWithFormat:@"%d",(i+1)] stringByAppendingString:@"月 - "] stringByAppendingFormat:@"%.2f",repayMonth] stringByAppendingString:@"元"]];
                }
                
                repayAccrual = repayTotal - totalVal;
                
                [_caculatorModel.resultTitle addObject:title];
                [_caculatorModel.resultTitle addObject:[@"房款总额:" stringByAppendingFormat:@"%d",totalVal]];
                [_caculatorModel.resultTitle addObject:[@"还款总额:" stringByAppendingFormat:@"%.2f",repayTotal]];
                [_caculatorModel.resultTitle addObject:[@"支付利息:" stringByAppendingFormat:@"%.2f",repayAccrual]];
                [_caculatorModel.resultTitle addObject:[@"贷款月数:" stringByAppendingFormat:@"%d",totalMonth]];
            }
            //等额本息
            else{
                repayMonth = [self getRateMonthRepay:currentRate putTotal:totalVal putMonth:totalMonth];
                repayTotal = repayMonth * totalMonth;
                repayAccrual = repayTotal - totalVal;
                
                [_caculatorModel.resultTitle addObject:title];
                [_caculatorModel.resultTitle addObject:[@"房款总额:" stringByAppendingFormat:@"%d",totalVal]];
                [_caculatorModel.resultTitle addObject:[@"还款总额:" stringByAppendingFormat:@"%.2f",repayTotal]];
                [_caculatorModel.resultTitle addObject:[@"支付利息:" stringByAppendingFormat:@"%.2f",repayAccrual]];
                [_caculatorModel.resultTitle addObject:[@"还款月数:" stringByAppendingFormat:@"%d",totalMonth]];
                [_caculatorModel.resultTitle addObject:[@"月均还款:" stringByAppendingFormat:@"%.2f",repayMonth]];
            }
        }
        //根据单位面积
        else{
            totalVal = [[[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:0] objectAtIndex:2] intValue] * [[[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:1] objectAtIndex:2] intValue];
            int totalLoan = (totalVal * [[[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:2] objectAtIndex:2] intValue]) / 10;
            float firstPay = totalVal - totalLoan;
            
            //等额本金
            if([[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:0] objectAtIndex:2] isEqualToString:@"1"]){
                for (int i=0; i<totalMonth; i++) {
                    repayMonth = [self getSumMonthRepay:currentRate putTotal:totalLoan putMonth:totalMonth putCurMonth:i];
                    repayTotal += repayMonth;
                    
                    [_caculatorModel.resultPerMonthRepay addObject:[[[[NSString stringWithFormat:@"%d",(i+1)] stringByAppendingString:@"月 - "] stringByAppendingFormat:@"%.2f",repayMonth] stringByAppendingString:@"元"]];
                }
                
                repayAccrual = repayTotal - totalLoan;
                
                [_caculatorModel.resultTitle addObject:title];
                [_caculatorModel.resultTitle addObject:[@"房贷总额:" stringByAppendingFormat:@"%d",totalVal]];
                [_caculatorModel.resultTitle addObject:[@"贷款总额:" stringByAppendingFormat:@"%d",totalLoan]];
                [_caculatorModel.resultTitle addObject:[@"支付利息:" stringByAppendingFormat:@"%.2f",repayAccrual]];
                [_caculatorModel.resultTitle addObject:[@"首期付款:" stringByAppendingFormat:@"%.2f",firstPay]];
                [_caculatorModel.resultTitle addObject:[@"贷款月数:" stringByAppendingFormat:@"%d",totalMonth]];
                
            }
            //等额本息
            else{
                repayMonth = [self getRateMonthRepay:currentRate putTotal:totalLoan putMonth:totalMonth];
                repayTotal = repayMonth * totalMonth;
                repayAccrual = repayTotal - totalLoan;
                
                [_caculatorModel.resultTitle addObject:title];
                [_caculatorModel.resultTitle addObject:[@"房贷总额:" stringByAppendingFormat:@"%d",totalVal]];
                [_caculatorModel.resultTitle addObject:[@"贷款总额:" stringByAppendingFormat:@"%d",totalLoan]];
                [_caculatorModel.resultTitle addObject:[@"还款总额:" stringByAppendingFormat:@"%.2f",repayTotal]];
                [_caculatorModel.resultTitle addObject:[@"支付利息:" stringByAppendingFormat:@"%.2f",repayAccrual]];
                [_caculatorModel.resultTitle addObject:[@"首期付款:" stringByAppendingFormat:@"%.2f",firstPay]];
                [_caculatorModel.resultTitle addObject:[@"贷款月数:" stringByAppendingFormat:@"%d",totalMonth]];
                [_caculatorModel.resultTitle addObject:[@"月均还款:" stringByAppendingFormat:@"%.2f",repayMonth]];
            }
        }
    }
    LCResultViewController *resultViewController = [[LCResultViewController alloc] initWithNibName:@"LCResultViewController" bundle:nil];
    [self.navigationController pushViewController:resultViewController animated:YES];
    [resultViewController release];
}

//本金还款的月还款额(参数: 年利率 / 贷款总额 / 贷款总月份 / 贷款当前月0～length-1)
- (float)getSumMonthRepay:(float)rate putTotal:(int)total putMonth:(int)month putCurMonth:(int)curMonth
{
    float monthRate = rate / 12;
    float sumMonth = total / month;
    return (total-sumMonth*curMonth)*monthRate+sumMonth;
}

//本息还款的月还款额(参数: 年利率/贷款总额/贷款总月份)
- (float)getRateMonthRepay:(float)rate putTotal:(int)total putMonth:(int)month
{
    float monthRate = rate / 12;
    return total * monthRate * pow((1 + monthRate),month) / (pow((1 + monthRate),month)-1);
}

#pragma mark - Memory Management Methods

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}


@end
