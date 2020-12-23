//
//  LCCaculatorModel.m
//  LoanCaculator
//
//  Created by lingyi xu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LCCaculatorModel.h"

@implementation LCCaculatorModel

@synthesize sectionOfRepayTypeAndLoanType = _sectionOfRepayTypeAndLoanType;
@synthesize sectionOfCaculateType = _sectionOfCaculateType;
@synthesize sectionOfUnitPriceAndAreaAndMortgagepercent = _sectionOfUnitPriceAndAreaAndMortgagepercent;
@synthesize sectionOfTotalPrice = _sectionOfTotalPrice;
@synthesize sectionOfBizTotalAndFoundTotal = _sectionOfBizTotalAndFoundTotal;
@synthesize sectionOfMortgageyearsAndRate = _sectionOfMortgageyearsAndRate;

@synthesize showSectionOfCaculateType = _showSectionOfCaculateType;
@synthesize showSectionOfUnitPriceAndAreaAndMortgagepercent = _showSectionOfUnitPriceAndAreaAndMortgagepercent;
@synthesize showSectionOfTotalPrice = _showSectionOfTotalPrice;
@synthesize showSectionOfBizTotalAndFoundTotal = _showSectionOfBizTotalAndFoundTotal;


@synthesize optionsRepayType = _optionsRepayType;
@synthesize optionsLoanType = _optionsLoanType;
@synthesize optionsCaculateType = _optionsCaculateType;
@synthesize optionsMortgagepercent = _optionsMortgagepercent;
@synthesize optionsMortgageyears = _optionsMortgageyears;

@synthesize optionsRate = _optionsRate;

@synthesize resultTitle = _resultTitle;
@synthesize resultPerMonthRepay = _resultPerMonthRepay;

+(LCCaculatorModel *)instance
{
    static LCCaculatorModel *instance;
    @synchronized(instance){
        if(!instance){
            instance = [[LCCaculatorModel alloc] init];
        }
    }
    
    return instance;
}

-(id)init
{
    if(!(self = [super init]))
        return self;
    
    _sectionOfRepayTypeAndLoanType = [[NSMutableArray alloc] initWithObjects:
                                      [NSMutableArray arrayWithObjects:@"还款方式:", @"等额本息", @"0", @"1", @"0", nil],
                                      [NSMutableArray arrayWithObjects:@"贷款类别:", @"公积金", @"0", @"1", @"1",nil],
                                      nil];
    
    _sectionOfCaculateType = [[NSMutableArray alloc] initWithObjects:
                              [NSMutableArray arrayWithObjects:@"计算方式:", @"根据面积单价计算", @"0", @"1", @"2", nil], nil];
    
    _sectionOfUnitPriceAndAreaAndMortgagepercent = [[NSMutableArray alloc] initWithObjects:
                                                    [NSMutableArray arrayWithObjects:@"单价(元/平方米):", @"", @"0", @"0", nil],
                                                    [NSMutableArray arrayWithObjects:@"面积(平方米)", @"", @"0", @"0", nil],
                                                    [NSMutableArray arrayWithObjects:@"按揭成数", @"6成", @"6", @"1", @"3", nil],
                                                    nil];
    
    _sectionOfTotalPrice = [[NSMutableArray alloc] initWithObjects:
                            [NSMutableArray arrayWithObjects:@"贷款总额(万元)", @"", @"0", @"0", nil], nil];
    
    _sectionOfBizTotalAndFoundTotal = [[NSMutableArray alloc] initWithObjects:
                                       [NSMutableArray arrayWithObjects:@"商业贷款(万元)", @"", @"0", @"0", nil],
                                       [NSMutableArray arrayWithObjects:@"公积金贷款(万元)", @"", @"0", @"0", nil],
                                       nil];
    
   
    _sectionOfMortgageyearsAndRate = [[NSMutableArray alloc] initWithObjects:
                                      [NSMutableArray arrayWithObjects:@"按揭年数", @"20年(240期)", @"20", @"1", @"4", nil], 
                                      [NSMutableArray arrayWithObjects:@"利率", @"公积金 4.7", @"0", @"0", nil],
                                      nil];
    
    _showSectionOfCaculateType = YES;
    _showSectionOfUnitPriceAndAreaAndMortgagepercent = YES;
    _showSectionOfTotalPrice = NO;
    _showSectionOfBizTotalAndFoundTotal = NO;
    
    _optionsRepayType = [[NSArray alloc] initWithObjects:
                        [NSArray arrayWithObjects:@"等额本息", @"0", nil],
                        [NSArray arrayWithObjects:@"等额本金", @"1", nil],
                         nil];
    
    _optionsLoanType = [[NSArray alloc] initWithObjects:
                        [NSArray arrayWithObjects:@"公积金", @"0", nil],
                        [NSArray arrayWithObjects:@"商业贷款", @"1", nil],
                        [NSArray arrayWithObjects:@"组合型", @"2", nil],
                        nil];
    
    _optionsCaculateType = [[NSArray alloc] initWithObjects:
                            [NSArray arrayWithObjects:@"根据面积，单价计算", @"0", nil],
                            [NSArray arrayWithObjects:@"根据贷款总额", @"1", nil],
                            nil];
    
    _optionsMortgagepercent = [[NSArray alloc] initWithObjects:
                               [NSArray arrayWithObjects:@"2成", @"2", nil],
                               [NSArray arrayWithObjects:@"3成", @"3", nil],
                               [NSArray arrayWithObjects:@"4成", @"4", nil],
                               [NSArray arrayWithObjects:@"5成", @"5", nil],
                               [NSArray arrayWithObjects:@"6成", @"6", nil],
                               [NSArray arrayWithObjects:@"7成", @"7", nil],
                               [NSArray arrayWithObjects:@"8成", @"8", nil],
                               [NSArray arrayWithObjects:@"9成", @"9", nil],
                               nil];
    
    _optionsMortgageyears = [[NSArray alloc] initWithObjects:
                             [NSArray arrayWithObjects:@"1年(12期)", @"1", nil],
                             [NSArray arrayWithObjects:@"2年(24期)", @"2", nil],
                             [NSArray arrayWithObjects:@"3年(36期)", @"3", nil],
                             [NSArray arrayWithObjects:@"4年(48期)", @"4", nil],
                             [NSArray arrayWithObjects:@"5年(60期)", @"5", nil],
                             [NSArray arrayWithObjects:@"6年(72期)", @"6", nil],
                             [NSArray arrayWithObjects:@"7年(84期)", @"7", nil],
                             [NSArray arrayWithObjects:@"8年(96期)", @"8", nil],
                             [NSArray arrayWithObjects:@"9年(108期)", @"9", nil],
                             [NSArray arrayWithObjects:@"10年(120期)", @"10", nil],
                             [NSArray arrayWithObjects:@"11年(132期)", @"11", nil],
                             [NSArray arrayWithObjects:@"12年(144期)", @"12", nil],
                             [NSArray arrayWithObjects:@"13年(156期)", @"13", nil],
                             [NSArray arrayWithObjects:@"14年(168期)", @"14", nil],
                             [NSArray arrayWithObjects:@"15年(180期)", @"15", nil],
                             [NSArray arrayWithObjects:@"16年(192期)", @"16", nil],
                             [NSArray arrayWithObjects:@"17年(204期)", @"17", nil],
                             [NSArray arrayWithObjects:@"18年(216期)", @"18", nil],
                             [NSArray arrayWithObjects:@"19年(228期)", @"19", nil],
                             [NSArray arrayWithObjects:@"20年(240期)", @"20", nil],
                             [NSArray arrayWithObjects:@"25年(300期)", @"25", nil],
                             [NSArray arrayWithObjects:@"30年(360期)", @"30", nil],
                             nil];
    
    _optionsRate = [[NSArray alloc] initWithObjects:
                    [NSArray arrayWithObjects:@"公积金 4.7", @"0", nil], //6－30年 公积金
                    [NSArray arrayWithObjects:@"公积金 4.2", @"1", nil], //1-5年 公积金
                    [NSArray arrayWithObjects:@"商业贷款 6.8", @"2", nil], //6-30年 商业贷款
                    [NSArray arrayWithObjects:@"商业贷款 6.65", @"3", nil], //4,5年 商业贷款
                    [NSArray arrayWithObjects:@"商业贷款 6.4", @"4", nil], //2,3年 商业贷款
                    [NSArray arrayWithObjects:@"商业贷款 6.31", @"5", nil], //1年 商业贷款
                    [NSArray arrayWithObjects:@"公积金 4.7 商业 6.8", @"6", nil], //6-30年 组合
                    [NSArray arrayWithObjects:@"公积金 4.2 商业 6.65", @"7", nil], //4,5年 组合
                    [NSArray arrayWithObjects:@"公积金 4.2 商业 6.4", @"8", nil], //2,3年 组合
                    [NSArray arrayWithObjects:@"公积金 4.2 商业 6.31", @"9", nil], //1年 组合
                    
                    nil];
    
    _resultTitle = [[NSMutableArray alloc] initWithObjects: nil];
    _resultPerMonthRepay = [[NSMutableArray alloc] initWithObjects: nil];
    
    return self;
}

-(void)dealloc
{
    [_sectionOfRepayTypeAndLoanType release];
    [_sectionOfCaculateType release];
    [_sectionOfUnitPriceAndAreaAndMortgagepercent release];
    [_sectionOfTotalPrice release];
    [_sectionOfBizTotalAndFoundTotal release];
    [_sectionOfMortgageyearsAndRate release];
    
    [_optionsRepayType release];
    [_optionsLoanType release];
    [_optionsCaculateType release];
    [_optionsMortgagepercent release];
    [_optionsMortgageyears release];
    
    [_resultTitle release];
    [_resultTitle release];
    
    [super dealloc];
}

@end
