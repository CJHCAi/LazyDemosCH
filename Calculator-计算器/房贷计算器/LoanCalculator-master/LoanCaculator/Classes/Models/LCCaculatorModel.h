//
//  LCCaculatorModel.h
//  LoanCaculator
//
//  Created by lingyi xu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCCaculatorModel : NSObject
{
#pragma mark - MainViewController Base data
    
    /*
     * 多维数组形式 [标题,显示结果,结果数字,是否可以选择]
     */
    NSMutableArray *_sectionOfRepayTypeAndLoanType; //还款方式和贷款类型
    NSMutableArray *_sectionOfCaculateType; //计算方式
    NSMutableArray *_sectionOfUnitPriceAndAreaAndMortgagepercent; //单价，面积，按揭成数
    NSMutableArray *_sectionOfTotalPrice; //总价
    NSMutableArray *_sectionOfBizTotalAndFoundTotal; //组合型时的商业贷款和公积金贷款
    NSMutableArray *_sectionOfMortgageyearsAndRate; //按揭年数和利率
    
    BOOL _showSectionOfCaculateType;
    BOOL _showSectionOfUnitPriceAndAreaAndMortgagepercent;
    BOOL _showSectionOfTotalPrice;
    BOOL _showSectionOfBizTotalAndFoundTotal; 
    
#pragma mark - OptionsViewController Options data
    
    NSArray *_optionsRepayType;
    NSArray *_optionsLoanType;
    NSArray *_optionsCaculateType;
    NSArray *_optionsMortgagepercent;
    NSArray *_optionsMortgageyears;
    
    NSArray *_optionsRate;
    
#pragma mark - ResultViewController show
    
    NSMutableArray *_resultTitle;
    NSMutableArray *_resultPerMonthRepay;
}

#pragma mark - Property MainViewController Base data

@property (nonatomic,retain) NSMutableArray *sectionOfRepayTypeAndLoanType;
@property (nonatomic,retain) NSMutableArray *sectionOfCaculateType;
@property (nonatomic,retain) NSMutableArray *sectionOfUnitPriceAndAreaAndMortgagepercent;
@property (nonatomic,retain) NSMutableArray *sectionOfTotalPrice;
@property (nonatomic,retain) NSMutableArray *sectionOfBizTotalAndFoundTotal;
@property (nonatomic,retain) NSMutableArray *sectionOfMortgageyearsAndRate;

@property (nonatomic,assign) BOOL showSectionOfCaculateType;
@property (nonatomic,assign) BOOL showSectionOfUnitPriceAndAreaAndMortgagepercent;
@property (nonatomic,assign) BOOL showSectionOfTotalPrice;
@property (nonatomic,assign) BOOL showSectionOfBizTotalAndFoundTotal;

#pragma mark - Property OptionsViewController Options data

@property (nonatomic,readonly,retain) NSArray *optionsRepayType;
@property (nonatomic,readonly,retain) NSArray *optionsLoanType;
@property (nonatomic,readonly,retain) NSArray *optionsCaculateType;
@property (nonatomic,readonly,retain) NSArray *optionsMortgagepercent;
@property (nonatomic,readonly,retain) NSArray *optionsMortgageyears;

@property (nonatomic,readonly,retain) NSArray *optionsRate;

#pragma mark - Property ResultViewController show

@property (nonatomic,retain) NSMutableArray *resultTitle;
@property (nonatomic,retain) NSMutableArray *resultPerMonthRepay;

+(LCCaculatorModel *)instance;

@end
