//
//  wjFoldViewController.m
//  MTreeViewFramework
//
//  Created by wangjun on 16/3/31.
//  Copyright © 2016年 wangjun. All rights reserved.
//  三级的折叠菜单列表

#import "wjFoldViewController.h"
#import "MTreeView.h"
#import "MTreeNode.h"
#import "MTreeNode+ExpandNode.h"
#import "wjFirstFoldView.h"

/* 唯一标识符*/
static NSString *TestViewControllerNode = @"TestViewControllerNode";
/* 第一级是否被点击*/
static BOOL isHeaderViewSelected = NO;

/* 第二级是否被点击*/
static BOOL isCataSelected = NO;

@interface wjFoldViewController () <UITableViewDelegate, UITableViewDataSource, MTreeViewDelegate>

@property (nonatomic, strong) MTreeView *treeView;
/* 一级标题*/
@property (nonatomic, strong) wjFirstFoldView *headerView;


@property (nonatomic, strong) UIView *sepratorLine;

/* 二三级的cell*/
@property (nonatomic, strong) UITableViewCell *childCell;

@end

@implementation wjFoldViewController

#pragma mark - 视图的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择";
    self.view.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1];
    self.treeView.backgroundColor = [UIColor clearColor];
    [self doConfigTreeView];
    [self.treeView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)dealloc {
    isCataSelected = NO;
}


#pragma mark - 数据源及UI界面
- (void)doConfigTreeView {
    // UI
    self.treeView = [[MTreeView alloc] init];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    [self.view addSubview:self.treeView];
    self.treeView.rootNode = [MTreeNode initWithParent:nil expand:NO];
    // 这里可根据实际情况进行多层级的列表嵌套,只需要把子节点添加到父节点下就可以了。
    // 后面会根据实际的数据进行UI的设置
    for (int i = 0; i < 3; i++) {
        // 一级的列表
        MTreeNode *node = [MTreeNode initWithParent:self.treeView.rootNode expand:NO];
        for (int j = 0; j < 4; j++) {
            // 二级列表
            MTreeNode *subnode = [MTreeNode initWithParent:node expand:NO];
            // 二级列表是不是要展开
            subnode.expand = NO;
            [node.subNodes addObject:subnode];
            if (j == 0 || j == 2) {
                // 三级的列表
                for (int k = 0; k < 3; k++) {
                    MTreeNode *subnode1 = [MTreeNode initWithParent:subnode expand:NO];
                    [subnode.subNodes addObject:subnode1];
                }
            }
        }
        [self.treeView.rootNode.subNodes addObject:node];
    }
}


#pragma mark --
#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.treeView numberOfSectionsInTreeView:self.treeView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.treeView treeView:self.treeView numberOfRowsInSection:section];
}

// 第一级标题
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.headerView = [[wjFirstFoldView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.dateLabel.tag = 1000 + section;
    MTreeNode *subNode = self.treeView.rootNode.subNodes[section];
    self.headerView.indicateImageView.transform = subNode.expand ? CGAffineTransformMakeRotation(90 * M_PI / 180.0) : CGAffineTransformMakeRotation(0);
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTaped:)];
    [self.headerView.dateLabel addGestureRecognizer:recognizer];
    self.headerView.dateLabel.userInteractionEnabled = YES;
    
    // 添加图片
    self.headerView.indicateImageView.tag = 1000 + section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTaped:)];
    [self.headerView.indicateImageView addGestureRecognizer:tap];
    self.headerView.indicateImageView.userInteractionEnabled = YES;
    
    // 这里是需要设置一些关于一级列表的相关信息的
    for (int i = 0; i <= section; i++) {
        // 标题
        self.headerView.dateLabel.text = [NSString stringWithFormat:@" 2015.11.2%d ",i];
        self.headerView.dateLabel.font = [UIFont systemFontOfSize:17.0];
        self.headerView.dateLabel.textColor = [UIColor blackColor];
    }
    self.headerView.dateLabel.backgroundColor = [UIColor clearColor];
    
    // 添加分割线
    UIView *line = [[UIView alloc] init];
    line.tag = 100 + section;
    line.frame = CGRectMake(13, 44, (CGRectGetWidth(self.view.bounds) - 26), 1);
    line.backgroundColor = subNode.expand ? [UIColor clearColor] : [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0];
    // 最末header的分割线设为取消设置
    if (section == self.treeView.rootNode.subNodes.count - 1) {
        NSLog(@"section is :%ld", self.treeView.rootNode.subNodes.count);
    } else {
        [self.headerView addSubview:line];
    }
    return self.headerView;
}


#pragma mark --
// 一级标题的点击事件
-(void)sectionTaped:(UITapGestureRecognizer *) recognizer {
    UIView *view = recognizer.view;
    NSUInteger tag = view.tag - 1000;
    // 翻转箭头
    [self firstImageIndicateRotateInSectionWithTap:recognizer];
    [self.treeView expandNodeAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:tag]];
}

// 第一级点击事件：箭头图标旋转以及分割线的处理
- (void)firstImageIndicateRotateInSectionWithTap:(UITapGestureRecognizer *)tap {
    NSLog(@"tap view tag is %ld", tap.view.tag);
    [UIView animateWithDuration:0.2 animations:^{
        // 是否展开
        wjFirstFoldView *headerView = (wjFirstFoldView *)tap.view.superview;
        isHeaderViewSelected = !isHeaderViewSelected;
        MTreeNode *subNode = self.treeView.rootNode.subNodes[tap.view.tag - 1000];
        headerView.indicateImageView.transform = !subNode.expand ? CGAffineTransformMakeRotation(90 * M_PI / 180.0) : CGAffineTransformMakeRotation(0);
        // 分割线的颜色需要进行改变
        UIView *line = (UIView *)[self.view viewWithTag:100 + tap.view.tag - 1000];
        line.backgroundColor = !subNode.expand ? [UIColor clearColor] : [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0];
    }];
}


// 第二级标题UI界面
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTreeNode *subNode = [self.treeView nodeAtIndexPath:indexPath];
    self.childCell = [tableView dequeueReusableCellWithIdentifier:TestViewControllerNode];
    if (!self.childCell) {
        self.childCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TestViewControllerNode];
    }
    // 分割线的内边距
    self.childCell.separatorInset = UIEdgeInsetsMake(0, 13.0f, 0, 13.0f);
//    self.childCell.textLabel.text = [NSString stringWithFormat:@" %@级子类目：%@",@(subNode.depth), @(indexPath.row)];
    self.childCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tableView setSeparatorColor:[UIColor colorWithRed:172/255.0 green:197/255.0 blue:217/255.0 alpha:1.0]];
    // 二级标题
    if (subNode.depth == 1) {
        isCataSelected = NO;
        self.childCell.textLabel.text = @"whatEver";
        self.childCell.textLabel.textColor = [UIColor blackColor];
        self.childCell.textLabel.font = [UIFont systemFontOfSize:17.0];
        self.childCell.backgroundColor = [UIColor colorWithRed:177/255.0 green:221/255.0 blue:253/255.0 alpha:1.0];
        self.childCell.imageView.image = !subNode.expand ? [UIImage imageNamed:@"add"] : [UIImage imageNamed:@"minus"];
        self.childCell.tag = indexPath.section + 200;
    } else if (subNode.depth == 2) { // 第三级的标题
        self.childCell.textLabel.text = @"耗儿鱼";
        self.childCell.textLabel.textColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1.0];
        self.childCell.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.childCell.backgroundColor = [UIColor colorWithRed:220/255.0 green:237/255.0 blue:251/255.0 alpha:1.0];
        self.childCell.imageView.image = [UIImage imageNamed:@"dot"];
    }
    return self.childCell;
}

// 二三级标题的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.treeView expandNodeAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MTreeNode *subNode = [self.treeView nodeAtIndexPath:indexPath];
    NSLog(@"sub node is :%ld", subNode.depth);
    
    if (subNode.depth == 1) {
        // cell右边的图标变成减号
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.imageView.image = subNode.expand ? [UIImage imageNamed:@"minus"] : [UIImage imageNamed:@"add"];
    } else if (subNode.depth == 2) {
        // 根据不同的数据进入下个界面去
        
    }
}




#pragma mark --
#pragma mark MTreeView delegate

- (void) treeView:(MTreeView *)treeView willexpandNodeAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willexpandNodeAtIndexPath = [%@, %@]", @(indexPath.section), @(indexPath.row));
}

- (void) treeView:(MTreeView *)treeView didexpandNodeAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didexpandNodeAtIndexPath = [%@, %@]", @(indexPath.section), @(indexPath.row));
}



@end
