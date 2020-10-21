//
//  CXViewController.m
//  CXDragTableView
//
//  Created by 616704162@qq.com on 09/10/2019.
//  Copyright (c) 2019 616704162@qq.com. All rights reserved.
//

#import "CXViewController.h"
#import "CXDragTableView.h"
#import "FTQuestionOptionCell.h"

@interface CXViewController ()<CXDragableCellTableViewDataSource,CXDragableCellTableViewDelegate>
@property (nonatomic, strong) CXDragTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@end

@implementation CXViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView ];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTQuestionOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FTQuestionOptionCell class])];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    FTQuestionOptionCell * questionOptionCell= (FTQuestionOptionCell *)cell;
    questionOptionCell.indexPath = indexPath;
    [questionOptionCell fillCellWithObject:self.dataSource[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource[indexPath.row] floatValue];
}

#pragma mark - DHDragableCellTableViewDataSource
//更新数据源（多个分组的情况可自己处理）
- (void)tableView:(UITableView *)tableView newMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark - CXDragableCellTableViewDelegate
//指定不能拖拽的cell
- (BOOL)tableView:(CXDragTableView *)tableView newCanMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return NO;
    }  else{
        return YES;
    }
    return NO;
}

//指定拖拽的跨度
- (BOOL)tableView:(CXDragTableView *)tableView newTargetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section == proposedDestinationIndexPath.section && (proposedDestinationIndexPath.row != 0)) {
        return YES;
    }else{
        return NO;
    }
}

//开始拖拽
- (void)tableView:(CXDragTableView *)tableView willMoveCellAtIndexPath:(NSIndexPath *)indexPath processCell:(UITableViewCell *)cell {
    [(FTQuestionOptionCell *)cell drawdragCell];
}

//拖拽松手后
- (void)tableView:(CXDragTableView *)tableView endMoveCellAtIndexPath:(NSIndexPath *)indexPath processCell:(UITableViewCell *)cell {
    [(FTQuestionOptionCell *)cell resetDrawdragCell];
}

//拖拽松手后，并且动画消息后
- (void)tableView:(CXDragTableView *)tableView animationendMoveCellAtIndexPath:(NSIndexPath *)indexPath processCell:(UITableViewCell *)cell {
    [tableView reloadData];
}

#pragma mark - getter & setter
- (CXDragTableView *)tableView{
    if (!_tableView) {
        _tableView = [[CXDragTableView alloc] initWithFrame:self.view.bounds];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FTQuestionOptionCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FTQuestionOptionCell class])];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromRGB(0xF9F9FB);
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@55,@57,@50,@56,@59,@53,@52,@51,@50,@51,@43,@50,@50,@50,@50,@50,@50].mutableCopy;
    }
    return _dataSource;
}

UIKIT_STATIC_INLINE UIColor *UIColorFromRGB(uint32_t rgbValue) {
    return UIColorFromRGBA(rgbValue,1.0f);
}

UIKIT_STATIC_INLINE UIColor *UIColorFromRGBA(uint32_t rgbValue, CGFloat a) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0f
                            blue:((float)(rgbValue & 0xFF))/255.0f
                           alpha:a];
}

@end
