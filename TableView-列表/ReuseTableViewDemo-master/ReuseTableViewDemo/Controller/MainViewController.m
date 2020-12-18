//
//  MainViewController.m
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import "MainViewController.h"
#import "AddressViewController.h"
#import "TaskViewController.h"
#import "TaskCell.h"

#define HeaderHeight 38
#define firstSectionHeight 44
#define contentToLeftWidth 117

static NSString *taskIdentifier = @"TaskCell";

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, copy)NSArray *addressArray;

@property (nonatomic, copy)NSArray *taskArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"ReuseTableViewDemo";
    self.view.backgroundColor = RGB(239, 239, 244, 1);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

// section数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// row数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return self.taskArray.count;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

// cell布局
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    switch (indexPath.section) {
        case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 标题
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, SCREEN_WIDTH/3, firstSectionHeight)];
                titleLabel.text = @"Buttons";
                titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
                titleLabel.textColor = [UIColor blackColor];
                [cell addSubview:titleLabel];
                // 内容
                UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH*2/3, firstSectionHeight)];
                contentLabel.font = [UIFont systemFontOfSize:15];
                contentLabel.textColor = RGB(170,170,170, 0.75);
                contentLabel.text = @"请选择多个button";
                [cell addSubview:contentLabel];
                
                UIScrollView *scrollView = [[UIScrollView alloc] init];
                [cell addSubview:scrollView];
                // 布局
                NSArray *array = self.addressArray;
                NSInteger lines = 0;
                if (array.count%3 != 0) {
                    lines = array.count/3 + 1;
                } else {
                    lines = array.count/3;
                }
                if (lines < 3) {
                    scrollView.frame = CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH - contentToLeftWidth, 33*lines);
                } else {
                    scrollView.frame = CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH - contentToLeftWidth, 33*3);
                }
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - contentToLeftWidth, 33*lines);
                scrollView.bounces = NO;
                // 选中人的集合
                for (NSInteger i = 0; i < array.count; i++) {
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake((scrollView.width/3)*(i%3), 33*(i/3), scrollView.width/3, 33)];
                    subView.backgroundColor = [UIColor whiteColor];
                    [scrollView addSubview:subView];
                    // 图标
                    UIImageView *iconView = [[UIImageView alloc] init];
                    iconView.image = [UIImage imageNamed:@"icon_people"];
                    [iconView sizeToFit];
                    iconView.frame = CGRectMake(5, (33 - iconView.height)/2, iconView.width, iconView.height);
                    [subView addSubview:iconView];
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right + 11, 0, subView.width - iconView.right - 11, subView.height)];
                    contentLabel.font = [UIFont systemFontOfSize:13];
                    contentLabel.text = array[i][@"PERSONNAME"];
                    contentLabel.textColor = RGB(134, 134, 134, 1);
                    [subView addSubview:contentLabel];
                }
                // 选入按钮
                UIButton *addressButton = [[UIButton alloc] init];
                if (scrollView.height == 0) {
                    addressButton.frame = CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH - contentToLeftWidth - contentToLeftWidth, firstSectionHeight);
                } else {
                    addressButton.frame = CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH - contentToLeftWidth - contentToLeftWidth, scrollView.height);
                }
                [addressButton addTarget:self action:@selector(addressClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:addressButton];
                return cell;
            }
            break;
        case 1:
        {
            TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:taskIdentifier];
            if (cell == nil) {
                cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.task = self.taskArray[indexPath.row];
            cell.imageButton.userInteractionEnabled = NO;
            return cell;
        }
            break;
        default:
            {
                return nil;
            }
            break;
    }
}

// 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight)];
            headerView.backgroundColor = [UIColor whiteColor];
            // 标头
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            iconImageView.image = [UIImage imageNamed:@"icon_one"];
            [iconImageView sizeToFit];
            iconImageView.frame = CGRectMake(0, (HeaderHeight - iconImageView.height)/2, iconImageView.width, iconImageView.height);
            [headerView addSubview:iconImageView];
            // 标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, SCREEN_WIDTH/3, 20)];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.font = [UIFont systemFontOfSize:17];
            titleLabel.text = @"多个button处理";
            [headerView addSubview:titleLabel];
            // 分割线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + (HeaderHeight - 20)/2 - 0.5, SCREEN_WIDTH, 0.5)];
            lineView.backgroundColor =RGB(200,199,204, 1);
            [headerView addSubview:lineView];
            return headerView;
        }
        case 1:
        {
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight)];
            headerView.backgroundColor = [UIColor whiteColor];
            // 标头
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            iconImageView.image = [UIImage imageNamed:@"icon_one"];
            [iconImageView sizeToFit];
            iconImageView.frame = CGRectMake(0, (HeaderHeight - iconImageView.height)/2, iconImageView.width, iconImageView.height);
            [headerView addSubview:iconImageView];
            // 标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, SCREEN_WIDTH/3, 20)];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.font = [UIFont systemFontOfSize:17];
            titleLabel.text = @"单个button处理";
            [headerView addSubview:titleLabel];
            // 添加按钮
            UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 12 - 40, (HeaderHeight - 20)/2, 40, 20)];
            addLabel.text = @"添加";
            addLabel.textColor = RGB(56, 173, 255, 1);
            addLabel.tag = 1000*section;
            addLabel.font = [UIFont systemFontOfSize:15];
            addLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskClick:)];
            [addLabel addGestureRecognizer:singleTap];
            singleTap.delegate = self;
            singleTap.cancelsTouchesInView = NO;
            [headerView addSubview:addLabel];
            // 分割线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + (HeaderHeight - 20)/2 - 0.5, SCREEN_WIDTH, 0.5)];
            lineView.backgroundColor =RGB(200,199,204, 1);
            [headerView addSubview:lineView];
            return headerView;
        }
            break;
        default:
            return nil;
            break;
    }
}

// 尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

// 头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return HeaderHeight;
            break;
        case 1:
            return HeaderHeight;
            break;
        default:
            return 0;
            break;
    }
}

// 尾视图高度
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

// 选择多个button点击处理
- (void)addressClick:(UIButton *)sender {
    
    AddressViewController *addressViewController = [AddressViewController new];
    addressViewController.title = @"选择多个button";
    addressViewController.addressBlock = ^(NSArray *userArray) {
        self.addressArray = userArray;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addressViewController animated:YES];
}

// 选择单个button点击处理
- (void)taskClick:(UITapGestureRecognizer *)sender{
    
    TaskViewController *taskViewController = [TaskViewController new];
    taskViewController.title = @"选择单个button处理";
    taskViewController.taskBlock = ^(NSArray *taskArray) {
        self.taskArray = taskArray;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:taskViewController animated:YES];
}

// row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            if (!self.addressArray) {
                return firstSectionHeight;
            } else {
                NSInteger lines = 0;
                if (self.addressArray.count%3 != 0) {
                    lines = self.addressArray.count/3 + 1;
                } else {
                    lines = self.addressArray.count/3;
                }
                if (lines < 3) {
                    return lines*3*firstSectionHeight/4;
                } else {
                    return 3*3*firstSectionHeight/4;
                }
            }
        }
            break;
        case 1:
        {
            return 65;
        }
            break;
        default:
            return 0;
            break;
    }
}



@end
