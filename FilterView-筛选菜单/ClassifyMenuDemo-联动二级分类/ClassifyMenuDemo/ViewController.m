//
//  ViewController.m
//  ClassifyMenuDemo
//
//  Created by LiuLi on 2019/2/21.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "ViewController.h"
#import "ClassifyMenu.h"

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define ISEMPTY(_v) ([_v isKindOfClass:[NSNull class]] || _v == nil || _v.length == 0)

@interface ViewController ()

/** 控制右滑返回手势  */
@property (nonatomic,assign) BOOL isCanBack;

@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UILabel *resultLabel;
@property (nonatomic,strong) ClassifyMenu *menu;
@property (nonatomic,assign) BOOL isShowMenu;
@property (nonatomic,strong) CMNode *rootNode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn setFrame:CGRectMake(0, 0, 200, 44)];
    [self.titleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.titleBtn setTitle:@"点击选择" forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.titleBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleBtn;
    
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.resultLabel.center = self.view.center;
    self.resultLabel.textColor = [UIColor redColor];
    self.resultLabel.font = [UIFont systemFontOfSize:15];
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.text = @"全部类目";
    [self.view addSubview:self.resultLabel];
    
    self.isShowMenu = NO;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)clickTitleBtn:(UIButton *)sender {
    
    if (self.isShowMenu == NO) {
        WEAKSELF
        self.rootNode = [self doConfigNodes];
        self.menu = [[ClassifyMenu alloc] initWithFrame:CGRectZero rootNode:self.rootNode chooseResult:^(CMNode *node) {
            weakSelf.isShowMenu = NO;
            NSString *result = @"";
            if (node.depth == 0) {
                // 一级终结
                result = [NSString stringWithFormat:@"%@", node.name];
            }else if (node.depth == 1) {
                // 二级终结
                result = [NSString stringWithFormat:@"%@-%@", node.parentNode.name, node.name];
            }else if (node.depth == 2) {
                // 三级终结
                result = [NSString stringWithFormat:@"%@-%@-%@", node.parentNode.parentNode.name, node.parentNode.name, node.name];
            }
            NSLog(@"选择的结果：%@", result);
            self.resultLabel.text = result;
        } closeMenuAction:^{
            weakSelf.isShowMenu = NO;
        }];
        [self.menu show];
        self.isShowMenu = YES;
    }else {
        self.isShowMenu = NO;
        if (self.menu) {
            [self.menu close];
        }
    }
}

#pragma mark - 数据源及UI界面
- (CMNode *)doConfigNodes {
    NSDictionary *item1 = @{@"name":@"一级分类1", @"arr":@[@{@"name":@"二级分类1", @"arr":@[@{@"name":@"三级分类11"}, @{@"name":@"三级分类22"}, @{@"name":@"三级分类33"}, @{@"name":@"三级分类44"}, @{@"name":@"三级分类55"}]},
                                                       @{@"name":@"二级分类2", @"arr":@[@{@"name":@"游泳馆1"}, @{@"name":@"游泳馆2"}, @{@"name":@"游泳馆3"}, @{@"name":@"游泳馆4"}, @{@"name":@"游泳馆5"}]},
                                                       @{@"name":@"二级分类3", @"arr":@[@{@"name":@"舞蹈1"}, @{@"name":@"舞蹈2"}, @{@"name":@"舞蹈3"}, @{@"name":@"舞蹈4"}, @{@"name":@"舞蹈5"}]},
                                                       @{@"name":@"亲子", @"arr":@[@{@"name":@"少儿才艺"}, @{@"name":@"少儿打架"}, @{@"name":@"科普"}]},
                                                       @{@"name":@"二级分类5", @"arr":@[@{@"name":@"hello1"}, @{@"name":@"hello Kitty"}, @{@"name":@"蓝胖子"}, @{@"name":@"小黑"}, @{@"name":@"大大pan"}]}]};
    NSDictionary *item2 = @{@"name":@"热门精选", @"arr":@[@{@"name":@"为你推荐", @"arr":@[@{@"name":@"快餐小吃1"}, @{@"name":@"快餐小吃2"}]}, @{@"name":@"超市", @"arr":@[@{@"name":@"超市1"}, @{@"name":@"超市2"}, @{@"name":@"超市3"}, @{@"name":@"超市4"}, @{@"name":@"超市5"}]}]};
    NSDictionary *item3 = @{@"name":@"休闲娱乐", @"arr":@[@{@"name":@"彩妆造型1", @"arr":@[@{@"name":@"美发1"}, @{@"name":@"美发2"}, @{@"name":@"美发3"}, @{@"name":@"美发4"}, @{@"name":@"美发5"}]}, @{@"name":@"宠物", @"arr":@[@{@"name":@"狗狗1"}, @{@"name":@"狗狗2"}, @{@"name":@"狗狗3"}, @{@"name":@"狗狗4"}, @{@"name":@"狗狗5"}]}]};
    NSDictionary *item4 = @{@"name":@"运动健身", @"arr":@[@{@"name":@"少林武术", @"arr":@[@{@"name":@"少林棍1"}, @{@"name":@"少林棍2"}, @{@"name":@"少林棍3"}, @{@"name":@"少林棍4"}, @{@"name":@"少林棍5"}]}, @{@"name":@"峨眉派", @"arr":@[@{@"name":@"白骨爪1"}, @{@"name":@"白骨爪2"}, @{@"name":@"白骨爪3"}, @{@"name":@"白骨爪4"}, @{@"name":@"白骨爪5"}]}]};
    NSDictionary *item5 = @{@"name":@"电影", @"arr":@[@{@"name":@"万达院1", @"arr":@[@{@"name":@"王思聪1"}, @{@"name":@"王思聪2"}, @{@"name":@"王思聪3"}, @{@"name":@"王思聪4"}, @{@"name":@"王思聪5"}]}, @{@"name":@"万达院2", @"arr":@[@{@"name":@"IceBear1"}, @{@"name":@"IceBear2"}]}]};
    NSArray *temps = @[item1, item2, item3, item4, item5];
    // 找到已选择的
    NSArray *temp = [self.resultLabel.text componentsSeparatedByString:@"-"];
    NSString *nodeName1 = @"";
    NSString *nodeName2 = @"";
    NSString *nodeName3 = @"";
    if (temp.count == 1) {
        nodeName1 = temp[0];
    }else if (temp.count == 2) {
        nodeName1 = temp[0];
        nodeName2 = temp[1];
    }else if (temp.count == 3) {
        nodeName1 = temp[0];
        nodeName2 = temp[1];
        nodeName3 = temp[2];
    }
    CMNode *rootNode = [[CMNode alloc] initWithParent:nil expand:NO];
    // 这里可根据实际情况进行多层级的列表嵌套,只需要把子节点添加到父节点下就可以了。
    // 后面会根据实际的数据进行UI的设置
    for (int i = 0; i < temps.count; i++) {
        // 一级的列表
        CMNode *node = [CMNode initWithParent:rootNode expand:YES];
        node.name = temps[i][@"name"];
        
        if ((ISEMPTY(self.resultLabel.text) || [nodeName1 isEqualToString:@"全部类目"]) && i==0) {
            node.isChoosed = YES;
            node.expand = YES;
        }else {
            if ([nodeName1 isEqualToString:node.name]) {
                node.isChoosed = YES;
                node.expand = YES;
            }else {
                node.isChoosed = NO;
                node.expand = NO;
            }
        }
        [rootNode.subNodes addObject:node];
        
        NSArray *twoLevelObjs = temps[i][@"arr"];
        for (int j = 0; j < twoLevelObjs.count; j++) {
            // 二级列表
            CMNode *subnode = [CMNode initWithParent:node expand:NO];
            subnode.name = twoLevelObjs[j][@"name"];
            
            if ((ISEMPTY(self.resultLabel.text) || [nodeName1 isEqualToString:@"全部类目"]) && ISEMPTY(nodeName2) && i==0 && j==0) {
                subnode.isChoosed = YES;
            }else {
                if ([nodeName1 isEqualToString:node.name] && [nodeName2 isEqualToString:subnode.name]) {
                    subnode.isChoosed = YES;
                }else {
                    subnode.isChoosed = NO;
                }
            }
            [node.subNodes addObject:subnode];
            
            NSArray *threeLevelObjs = twoLevelObjs[j][@"arr"];
            for (int k = 0; k < threeLevelObjs.count; k++) {
                // 三级的列表 (整理后放右侧陈列)
                CMNode *threeNode = [CMNode initWithParent:subnode expand:NO];
                threeNode.name = threeLevelObjs[k][@"name"];
                if ((ISEMPTY(self.resultLabel.text) || [nodeName1 isEqualToString:@"全部类目"]) && i==0 && j==0 && k==0) {
                    threeNode.isChoosed = YES;
                }else {
                    if ([nodeName1 isEqualToString:node.name] && [nodeName2 isEqualToString:subnode.name] && [nodeName3 isEqualToString:threeNode.name]) {
                        threeNode.isChoosed = YES;
                    }else {
                        threeNode.isChoosed = NO;
                    }
                }
                [subnode.threeNodes addObject:threeNode];
            }
        }
    }
    return rootNode;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}

#pragma mark -- 禁用边缘返回
-(void)forbiddenSideBack {
    self.isCanBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

#pragma mark --恢复边缘返回
- (void)resetSideBack {
    self.isCanBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}

@end
