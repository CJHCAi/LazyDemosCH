//
//  ViewController.m
//  DropDownMenuDemo
//
//  Created by admin on 2017/7/7.
//  Copyright © 2017年 王晓丹. All rights reserved.
//
#define iphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NAV_SaferHeight   iphoneX ? 88 : 64
#import "ViewController.h"
#import "PopDropdownMenuView.h"
#import "TitleDropMenuView.h"
@interface ViewController ()<PopDropdownMenuViewDelegate,TitleDropMenuViewDelegate>

@property (nonatomic, strong) PopDropdownMenuView *dropDownView;
@property (nonatomic, strong) TitleDropMenuView *titleView;
@property (nonatomic, assign) NSInteger currentTag;
@end

@implementation ViewController
#pragma mark - Lifecycle
- (void)loadView {
    [super loadView];
    [self customAccessors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self removePopMenuView];
}
#pragma mark - Custom Accessors

- (TitleDropMenuView *)titleView {
    if(!_titleView) {
        _titleView = [TitleDropMenuView TitleDropMenuViewInitWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 44) otherSetting:^(TitleDropMenuView *titleMenuView) {
            titleMenuView.titleArray = @[@"全部ha",@"销量排序",@"离我最近",@"筛选"];
            titleMenuView.imageArray = nil;
            titleMenuView.imageSelectArray = nil;
            titleMenuView.titleColor = @"#949494";
            titleMenuView.titleSelectColor = @"#333333";
        }];
        _titleView.delegate = self;
    }
    return _titleView;
}

- (void)customAccessors {
    [self.view addSubview:self.titleView];
}
#pragma mark - Click Actions
- (void)buttonClick:(UIButton *)button {
    NSLog(@"buttonClick");
}

#pragma mark - Private
- (void)removePopMenuView {
    if(self.dropDownView != nil) {
        [self.dropDownView dismiss:NO];
        self.dropDownView = nil;
    }
}

#pragma mark - TitleDropMenuViewDelegate
- (void)titleButtonClick:(NSInteger)btnTag buttonSelect:(BOOL)isSelect {
    //不同按钮传递不同数据，需重新加载页面
    self.currentTag = btnTag + 100;
    [self removePopMenuView];
    if(isSelect == YES) {
        switch (btnTag) {
            case 0:
            {
                self.dropDownView = [PopDropdownMenuView PopDropdownMenuViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height-(50+NAV_SaferHeight))  tableOneWith:150 imageArray:nil otherSetting:^(PopDropdownMenuView *popDropMenuView) {
                    popDropMenuView.isTowTable = 1;
                    popDropMenuView.firstArray = [NSMutableArray arrayWithObjects:@"马克思",@"没看到就",@"可健康", nil];
                    popDropMenuView.secondArray = [NSMutableArray arrayWithObjects:@"马克思",@"没看到就",@"可健康",nil];
                    popDropMenuView.tmpOuterArray = [NSMutableArray arrayWithObjects:
                                                     @[@"马克思",@"没看到就",@"可健康"],
                                                     @[@"全部",@"排序",@"筛选",@"dws",@"dws",@"马克思",@"没看到就",@"可健康",@"dws",@"wew",@"ewe",@"全部ha",@"销量排序",@"离我最近",@"筛选"],
                                                     @[@"dws",@"wew",@"ewe"], nil];
                }];
                self.dropDownView.delegate = self;
                [self.dropDownView show:YES];
            }
                break;
            case 1:
            {
                self.dropDownView = [PopDropdownMenuView PopDropdownMenuViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height-(50+NAV_SaferHeight))  tableOneWith:self.view.frame.size.width imageArray:@[@"icon_down",@"icon_down",@"icon_shaixuan"] otherSetting:^(PopDropdownMenuView *popDropMenuView) {
                    popDropMenuView.isTowTable = 0;
                    popDropMenuView.firstArray = [NSMutableArray arrayWithObjects:@"马克思",@"没看到就",@"可健康", nil];
                }] ;
                self.dropDownView.delegate = self;
                [self.dropDownView show:YES];
                
            }
                break;
            case 2:
            {
                UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-300)];
                backView.backgroundColor = [UIColor blueColor];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor = [UIColor redColor];
                [button setTitle:@"自定义页面" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(0, 0, 100, 50);
                [backView addSubview:button];
                
                self.dropDownView = [PopDropdownMenuView PopDropdownMenuViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height-(50+NAV_SaferHeight)) contentView:backView otherSetting:^(PopDropdownMenuView *popDropMenuView) {
                }];
                self.dropDownView.delegate = self;
                [self.dropDownView show:YES];
            }
                break;
            case 3:{
                
            }
                break;
            default:
                break;
        }
    }
    
}
#pragma mark - PopDropdownMenuViewDelegate
- (void)tableViewDidSelect:(NSInteger)indexRow obj:(id)obj {
    
}

- (void)dismissCurrentViewChangeSelectBtnStatues:(id)statues {
    UIButton *button = (UIButton *)[self.titleView viewWithTag:self.currentTag];
    button.selected = NO;
}

@end
