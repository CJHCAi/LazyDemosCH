//
//  HKCloseOrderViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCloseOrderViewController.h"

@interface HKCloseOrderViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, copy)NSString *str;
@end

@implementation HKCloseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight-213, self.view.frame.size.width, 213)];
    
    self.pickerView.backgroundColor = [UIColor whiteColor];
    
    self.pickerView.delegate = self;
    
    self.pickerView.dataSource = self;
    
    [self.view addSubview:self.pickerView];
    
    [self.view addSubview:self.topView];
    
    [self.pickerView reloadAllComponents];
}

//返回有几列
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.str = self.questionArray[row];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    
    return 1;
    
}

//返回指定列的行数

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    
    return self.questionArray.count;
    
}

//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 37.f;
    
}

//返回指定列的宽度

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    
    return  kScreenWidth;
    
}



// 自定义指定列的每行的视图，即指定列的每行的视图行为一致

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (!view){
        
        view = [[UIView alloc]init];
        
    }
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
    
    text.textAlignment = NSTextAlignmentCenter;
    
    text.text = [self.questionArray objectAtIndex:row];
    
    [view addSubview:text];
    
    //隐藏上下直线
    
    
    return view;
    
}


- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
        [_questionArray addObject:@"缺货"];
        [_questionArray addObject:@"买家不想要了"];
        [_questionArray addObject:@"其他"];
    }
    return _questionArray;
}



-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-253, kScreenWidth, 40)];
        UIButton*btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, 50, 16)];
        [btn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:0];
        [btn setTitle:@"取消" forState:0];
        [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:btn];
        UIButton*btn2 = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-33-15, 20, 50, 16)];
        [btn2 setTitle:@"完成" forState:0];
        [btn2 setTitleColor:[UIColor colorWithRed:64.0/255.0 green:144.0/255.0 blue:247.0/255.0 alpha:1] forState:0];
         [_topView addSubview:btn2];
         [btn2 addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)close{
    if ([self.delegate respondsToSelector:@selector(closeWithStr:)]) {
        if (self.str.length == 0) {
            self.str = self.questionArray[0];
        }
        [self.delegate closeWithStr:self.str];
    }
    [self cancel];
}

@end
