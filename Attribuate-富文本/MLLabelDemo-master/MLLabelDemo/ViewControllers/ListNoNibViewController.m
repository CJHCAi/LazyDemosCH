//
//  ListNoNibViewController.m
//  MLLabelDemo
//
//  Created by 孙巧巧 on 2017/11/28.
//  Copyright © 2017年 孙巧巧. All rights reserved.
//

#import "ListNoNibViewController.h"
#import <MLLabel/NSString+MLExpression.h>
#import "ListNoNibTableViewCell.h"
#import "UITableViewCell+Common.h"
#import "UIView+CateGory.h"
#import "CommonData.h"


@interface ListNoNibViewController ()
@property (nonatomic, strong) NSArray *expressionData;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;
@end

@implementation ListNoNibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ListNoNib(little higher performance)";
    
    [self.tableView registerClass:[ListNoNibTableViewCell class] forCellReuseIdentifier:[ListNoNibTableViewCell cellReuseIdentifier]];
    
    //    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"OriginalExpression"];
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];
    
    self.expressionData = [MLExpressionManager expressionAttributedStringsWithStrings:kCommonListData() expression:exp];
    
}
#pragma mark - getter
- (NSMutableDictionary *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = [NSMutableDictionary new];
    }
    return _cellHeights;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ListNoNibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ListNoNibTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
    
    cell.label.attributedText = self.expressionData[indexPath.row%self.expressionData.count];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.cellHeights[indexPath]) {
        self.cellHeights[indexPath] = @([self heightForRowAtIndexPath:indexPath tableView:tableView]);
    }
    return [self.cellHeights[indexPath] floatValue];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    CGFloat height = [ListNoNibTableViewCell heightForExpressionText:self.expressionData[indexPath.row%self.expressionData.count] width:self.view.width];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
