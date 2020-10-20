//
//  ListViewController.m
//  MLLabelDemo
//
//  Created by 孙巧巧 on 2017/11/30.
//  Copyright © 2017年 孙巧巧. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "CommonData.h"
#import "UITableViewCell+Common.h"
//#import "NSString+MLExpression.h"
#import <MLLabel/NSString+MLExpression.h>
#import "UIView+CateGory.h"



@interface ListViewController ()

@property (nonatomic, strong) NSArray *expressionData;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"List";
    
//    [self.tableView registerNib:[ListTableViewCell nib] forCellReuseIdentifier:[ListTableViewCell cellReuseIdentifier]];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ListTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[ListTableViewCell cellReuseIdentifier]];
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];
    
    self.expressionData = [MLExpressionManager expressionAttributedStringsWithStrings:kCommonListData() expression:exp];
    
    // Do any additional setup after loading the view.
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
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ListTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
    
    cell.textlabel.attributedText = self.expressionData[indexPath.row%self.expressionData.count];
    
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
    CGFloat h = [ListTableViewCell heightForExpressionText:self.expressionData[indexPath.row%self.expressionData.count] width:self.view.width];
    return h;
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
