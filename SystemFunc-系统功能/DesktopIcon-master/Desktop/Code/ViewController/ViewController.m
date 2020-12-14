//
//  ViewController.m
//  Desktop
//
//  Created by 罗泰 on 2018/11/6.
//  Copyright © 2018 chenwang. All rights reserved.
//

#import "ViewController.h"
#import "Module.h"
#import "NextViewController.h"

#define kCellReuseIdentifier @"kCellReuseIdentifier"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView                        *tableView;
@property (nonatomic, strong) NSArray<Module *>                         *dataArr;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
}


#pragma mark - Setter & Getter
- (NSArray<Module *> *)dataArr {
    if (!_dataArr)
    {
        NSArray *titles = @[@"小功能一", @"小功能二", @"小功能三"];
        NSArray *codes = @[@1, @2, @3];
        NSInteger count = 3;
        self.dataArr = [self createDataArrWithTitles:titles
                                               codes:codes
                                               count:count];
    }
    return _dataArr;
}


- (NSArray<Module *> *)createDataArrWithTitles:(NSArray<NSString *>*)titles
                                         codes:(NSArray<NSNumber *>*)codes
                                         count:(NSInteger)count {
    NSMutableArray<Module *> *tempArr = [NSMutableArray arrayWithCapacity:count];
    Module *model = nil;
    for(int i = 0; i < count; i++)
    {
        model = [[Module alloc] init];
        model.title = titles[i];
        model.code = codes[i].integerValue;
        [tempArr addObject:model];
    }
    return [NSArray arrayWithArray:tempArr];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    Module *model = [self.dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NextViewController *nextVC = [[NextViewController alloc] initWithModel:self.dataArr[indexPath.row]];
    [self.navigationController pushViewController:nextVC animated:YES];
}
@end
