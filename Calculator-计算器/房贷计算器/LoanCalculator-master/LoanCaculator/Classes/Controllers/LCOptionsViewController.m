//
//  LCOptionsViewController.m
//  LoanCaculator
//
//  Created by lingyi xu on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LCOptionsViewController.h"

@interface LCOptionsViewController (Private)

- (void)backAction;
- (void)changeRateByLoanType:(NSString *)loanType andYears:(NSString *)mortgageyears;

@end

@implementation LCOptionsViewController

@synthesize whichOption = _whichOption;
@synthesize currentSelect = _currentSelect;

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
    // Do any additional setup after loading the view from its nib.
    
    _caculatorModel = [LCCaculatorModel instance];
    
    switch (_whichOption) {
        case 0:
            self.navigationItem.title = @"还款方式";
            _currentData = [[NSArray alloc] initWithArray:_caculatorModel.optionsRepayType];
            break;
        case 1:
            self.navigationItem.title = @"贷款类别";
            _currentData = [[NSArray alloc] initWithArray:_caculatorModel.optionsLoanType];
            break;
        case 2:
            self.navigationItem.title = @"计算方式";
            _currentData = [[NSArray alloc] initWithArray:_caculatorModel.optionsCaculateType];
            break;
        case 3:
            self.navigationItem.title = @"按揭成数";
            _currentData = [[NSArray alloc] initWithArray:_caculatorModel.optionsMortgagepercent];
            break;
        case 4:
            self.navigationItem.title = @"按揭年数";
            _currentData = [[NSArray alloc] initWithArray:_caculatorModel.optionsMortgageyears];
            break;
        default:
            break;
    }
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backButton;  
    [backButton release];  
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 504) style:UITableViewStyleGrouped];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = true;
    
    [self.view addSubview:_tableView];
    [_tableView release];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[_currentData objectAtIndex:indexPath.row] objectAtIndex:0];
    
    if([[[_currentData objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:_currentSelect]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_whichOption) {
        case 0:
            [[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:0] replaceObjectAtIndex:1 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:0]];
            [[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:0] replaceObjectAtIndex:2 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:1]];
            break;
        case 1:
            [[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:0]];
            [[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:1]];
            if([[[_currentData objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"2"]){
                _caculatorModel.showSectionOfCaculateType = NO;
                _caculatorModel.showSectionOfUnitPriceAndAreaAndMortgagepercent = NO;
                _caculatorModel.showSectionOfTotalPrice = NO;
                _caculatorModel.showSectionOfBizTotalAndFoundTotal = YES;
            }else{
                if([[[_caculatorModel.sectionOfCaculateType objectAtIndex:0] objectAtIndex:2] isEqualToString:@"0"]){
                    _caculatorModel.showSectionOfUnitPriceAndAreaAndMortgagepercent = YES;
                    _caculatorModel.showSectionOfTotalPrice = NO;
                }else {
                    _caculatorModel.showSectionOfUnitPriceAndAreaAndMortgagepercent = NO;
                    _caculatorModel.showSectionOfTotalPrice = YES;
                }
                _caculatorModel.showSectionOfCaculateType = YES;
                _caculatorModel.showSectionOfBizTotalAndFoundTotal = NO;
            }
            break;
        case 2:
            [[_caculatorModel.sectionOfCaculateType objectAtIndex:0] replaceObjectAtIndex:1 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:0]];
            [[_caculatorModel.sectionOfCaculateType objectAtIndex:0] replaceObjectAtIndex:2 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:1]];
            if([[[_currentData objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"0"]){
                _caculatorModel.showSectionOfUnitPriceAndAreaAndMortgagepercent = YES;
                _caculatorModel.showSectionOfTotalPrice = NO;
            }else{
                _caculatorModel.showSectionOfUnitPriceAndAreaAndMortgagepercent = NO;
                _caculatorModel.showSectionOfTotalPrice = YES;
            }
            break;
        case 3:
            [[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:2] replaceObjectAtIndex:1 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:0]];
            [[_caculatorModel.sectionOfUnitPriceAndAreaAndMortgagepercent objectAtIndex:2] replaceObjectAtIndex:2 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:1]];
            break;
        case 4:
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:0] replaceObjectAtIndex:1 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:0]];
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:0] replaceObjectAtIndex:2 withObject:[[_currentData objectAtIndex:indexPath.row] objectAtIndex:1]];
            break;
        default:
            break;
    }
    
    [self changeRateByLoanType:[[_caculatorModel.sectionOfRepayTypeAndLoanType objectAtIndex:1] objectAtIndex:2] andYears:[[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:0] objectAtIndex:2]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Methods

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeRateByLoanType:(NSString *)loanType andYears:(NSString *)mortgageyears{
    if([loanType isEqualToString:@"0"]){
        if([mortgageyears intValue] > 5){
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:0] objectAtIndex:0]];
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:0] objectAtIndex:1]];
        }else{
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:1] objectAtIndex:0]];
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:1] objectAtIndex:1]];
        }
    }else if([loanType isEqualToString:@"1"]){
        if([mortgageyears intValue] > 5){
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:2] objectAtIndex:0]];
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:2] objectAtIndex:1]];
        }else{
            if([mortgageyears intValue] > 3){
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:3] objectAtIndex:0]];
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:3] objectAtIndex:1]];
            }else if([mortgageyears intValue] > 1){
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:4] objectAtIndex:0]];
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:4] objectAtIndex:1]];
            }else if([mortgageyears intValue] == 1){
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:5] objectAtIndex:0]];
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:5] objectAtIndex:1]];
            }
            
        }
    }else if([loanType isEqualToString:@"2"]){
        if([mortgageyears intValue] > 5){
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:6] objectAtIndex:0]];
            [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:6] objectAtIndex:1]];
        }else{
            if([mortgageyears intValue] > 3){
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:7] objectAtIndex:0]];
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:7] objectAtIndex:1]];
            }else if([mortgageyears intValue] > 1){
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:8] objectAtIndex:0]];
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:8] objectAtIndex:1]];
            }else if([mortgageyears intValue] == 1){
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:1 withObject:[[_caculatorModel.optionsRate objectAtIndex:9] objectAtIndex:0]];
                [[_caculatorModel.sectionOfMortgageyearsAndRate objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[_caculatorModel.optionsRate objectAtIndex:9] objectAtIndex:1]];
            }
        }
    }
}

#pragma mark - Memory management methods

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_currentData release];
    self.currentSelect = nil;
    [super dealloc];
}

@end
