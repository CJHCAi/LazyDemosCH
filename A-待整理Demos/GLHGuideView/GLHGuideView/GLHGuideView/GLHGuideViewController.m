//
//  GLHGuideViewController.m
//  GLHGuideView
//
//  Created by ligui on 2017/5/26.
//  Copyright © 2017年 ligui. All rights reserved.
//

#import "GLHGuideViewController.h"
#import "GLHGuideView.h"

@interface GLHGuideViewController ()
@property (nonatomic, strong) NSDictionary *guideDict;
@property (nonatomic, strong) NSMutableArray *guideArr;
@end

@implementation GLHGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];/*id   主键  (根据id显不显示)
                         desc 描述(可以存放url)
                         style 被指引控制显示样式（0=距形 1=圆形）
                         sort 排序
                         arrow_type      箭头方向(1左上,2右上,3左下,4右下,99只居中显示文字,98描述里放url)
                         ui            页面
                         ui_c_id          控件ID
                         ui_c_tag         控件tag 
*/
    _guideDict = @{@"Datas": @[@{
        @"id": @1,
        @"desc": @"新加登录按钮",
        @"style": @"0",
        @"sort":@1,
        @"arrow_type": @1,
        @"ui": @"ViewController",
        @"ui_c_id": @"btnLogin",
        @"ui_c_tag": @"116"
    },@{
        @"id": @1,
        @"desc": @"新加设置按钮",
        @"style": @"1",
        @"sort": @2,
        @"arrow_type": @2,
        @"ui": @"ViewController",
        @"ui_c_id": @"btnSet",
        @"ui_c_tag": @"117"
        },@{
                                   @"id": @1,
                                   @"desc": @"新加设置按钮",
                                   @"style": @"1",
                                   @"sort": @3,
                                   @"arrow_type": @2,
                                   @"ui": @"ViewController",
                                   @"ui_c_id": @"btnSet",
                                   @"ui_c_tag": @"118"
                                   }]};
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)guideArr
{
    if (!_guideArr) {
        _guideArr = [NSMutableArray array];
    }
    return _guideArr;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSArray *dataArr = _guideDict[@"Datas"];
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        if ([dict[@"ui"] isEqualToString:NSStringFromClass([self class])]) {
            [self.guideArr addObject:dict];
        }
    }];
    if (_guideArr.count<1) {
        return;
    }
    NSMutableArray *descArr = [NSMutableArray array];
    NSMutableArray *styleArr = [NSMutableArray array];
    NSMutableArray *arrowArr = [NSMutableArray array];
    for (NSDictionary *dataDict in [self sortDataArrayBySort:_guideArr]) {
        UIView *view = (UIView *)[self.view viewWithTag:[dataDict[@"ui_c_tag"] integerValue]];
        [descArr addObject:@{dataDict[@"desc"]:[NSValue valueWithCGRect:[view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow]]}];
        [styleArr addObject:dataDict[@"style"]];
        [arrowArr addObject:dataDict[@"arrow_type"]];
    }
    GLHGuideView *guideView = [[GLHGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds guides:[descArr copy] styles:[styleArr copy] arrowType:[arrowArr copy]];
    [guideView showGuide];
}
- (NSArray *)sortDataArrayBySort:(NSMutableArray *)muArr
{
    NSArray *sortedArray = [muArr sortedArrayUsingComparator:^(NSDictionary *dict1,NSDictionary *dict2) {
        if ([dict1[@"sort"] integerValue] < [dict2[@"sort"] integerValue]) {
            
            return NSOrderedAscending;
            
        } else {
            
            return NSOrderedDescending;
            
        }
        
    }];
    
    return sortedArray;
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
