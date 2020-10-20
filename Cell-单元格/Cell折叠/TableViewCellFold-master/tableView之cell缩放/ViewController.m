//
//  ViewController.m
//  tableView之cell缩放
//
//  Created by imac on 16/9/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ViewController.h"
#define Screenwidth [UIScreen mainScreen].bounds.size.width
#define ScreennHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{

    //简单的说,30代表的最多个setion的数字,数字可以比section大,不能小
    BOOL close[30];
    /**
     *  BOOL flag[3]; 意思就是创建了一个含有三个bool值的数组,用的时候其实很简单,假如你的数组中的第二个数据取反了,这样写就行 flag[1] = !flog[1],这是c里面的数组写法，比如int类型的数组 就是 int arr[3]= {1,2,3}; 动态分配就是malloc
     */
}


@property (nonatomic,strong) UITableView *WBTableView;
@property (nonatomic,strong) NSArray *Close;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //这个的目的是为了使得启动app时，单元格是收缩的
    for (int i=0; i<30; i++) {
        close[i] = YES;
    }
    //创建
    _WBTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, Screenwidth, ScreennHeight) style:UITableViewStylePlain];
    _WBTableView.dataSource = self;
    _WBTableView.delegate = self;
    
    [self.view addSubview:self.WBTableView];
    
}

//数据源方法的实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (close[section]) {
        return 0;
    }
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld组 第%ld行",indexPath.section,indexPath.row];
    
    return cell;
}

//组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

//创建组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, 50)];
    view.tag = 1000 + section;
    view.backgroundColor = [UIColor colorWithRed:0.849 green:0.195 blue:0.258 alpha:0.7];;
    [view addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 70, 30)];
    label.textColor = [UIColor colorWithRed:1.000 green:0.985 blue:0.996 alpha:1.000];
    label.font = [UIFont systemFontOfSize:14];
    label.text = [NSString stringWithFormat:@"第%ld组",section];
    [view addSubview:label];
    
    
    return view;
    
}

/**
 *  cell收缩/展开 刷新
 *
 *  @param view <#view description#>
 */
-(void)sectionClick:(UIControl *)view{
    
    //获取点击的组
    NSInteger i = view.tag - 1000;
    //取反
    close[i] = !close[i];
    //刷新列表
    NSIndexSet * index = [NSIndexSet indexSetWithIndex:i];
    [_WBTableView reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
}



@end
