//
//  AnswerViewController.m
//  StudyDrive
//
//  Created by zgl on 16/1/7.
//  Copyright © 2016年 sj. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerScrollView.h"
#import "MyDataManager.h"
#import "AnswerModel.h"
#import "SelectModelView.h"
#import "SheetView.h"

@interface AnswerViewController ()<SheetViewDelegate,UIAlertViewDelegate>
{
    AnswerScrollView * _answerScrollView;
    SelectModelView * modelView;
    SheetView * _sheetView;
}

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatData];

    [self.view addSubview:_answerScrollView];
    [self creatToolBar];
    [self creatModelView];
    [self creatSheetView];
}

-(void)creatData
{
    if (_type==1) {     //章节练习
        NSMutableArray * arr = [[NSMutableArray alloc]init];
        NSArray * array = [MyDataManager getData:answer];
        for (int i=0; i<array.count-1; i++) {
            AnswerModel * model = array[i];
            if ([model.pid intValue]==_number+1) {
                [arr addObject:model];
            }
        }
        _answerScrollView = [[AnswerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:arr];
    }else if (_type==2){    //顺序练习
        _answerScrollView = [[AnswerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:[MyDataManager getData:answer]];
    }else if(_type==3){      //随机练习
        NSMutableArray *temArr = [[NSMutableArray alloc]init];
        NSArray *array = [MyDataManager getData:answer];
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        [temArr addObjectsFromArray:array];
        for (int i=0; i<temArr.count; i++) {
            int index = arc4random()%(temArr.count);
            [dataArray addObject:temArr[index]];
            [temArr removeObjectAtIndex:index];
        }
        
        _answerScrollView = [[AnswerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:dataArray];
    }else if (_type==4){    //专项练习
        NSMutableArray * arr = [[NSMutableArray alloc]init];
        NSArray * array = [MyDataManager getData:answer];
        for (int i=0; i<array.count-1; i++) {
            AnswerModel * model = array[i];
            if ([model.sid isEqualToString:_subStrNumber]) {
                [arr addObject:model];
            }
        }
        _answerScrollView = [[AnswerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:arr];
        
    }else if(_type==5){     //全真模拟
        NSMutableArray *temArr = [[NSMutableArray alloc]init];
        NSArray *array = [MyDataManager getData:answer];
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        [temArr addObjectsFromArray:array];
        for (int i=0; i<100; i++) {
            int index = arc4random()%(temArr.count);
            [dataArray addObject:temArr[index]];
            [temArr removeObjectAtIndex:index];
        }
        
        _answerScrollView = [[AnswerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:dataArray];
        
        [self creatNavBtn];
    }
    
    
}

-(void)creatNavBtn
{
    UIBarButtonItem * itemLeft = [[UIBarButtonItem alloc]init];
    itemLeft.title = @"返回";
    [itemLeft setTarget:self];
    [itemLeft setAction:@selector(clickNavBtnReturn)];
    
    self.navigationItem.backBarButtonItem = itemLeft;
    
    UIBarButtonItem * itemRight = [[UIBarButtonItem alloc]init];
    itemRight.title = @"交卷";
    [itemRight setTarget:self];
    [itemRight setAction:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = itemRight;
}

-(void)clickRightItem
{
    //创建弹出框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"时间还多，确定要离开考试吗？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    //创建确定按钮
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"我要交卷" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"注意学习");
    }];
    
    //创建取消按钮
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"不，谢谢" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"注意学习");
    }];
    
    //将按钮添加到UIAlertController对象上
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    // 将UIAlertController模态出来
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)clickNavBtnReturn
{
    //创建弹出框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"时间还多，确定要离开考试吗？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    //创建确定按钮
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"我要交卷" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"注意学习");
    }];
    
    //创建取消按钮
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"不，谢谢" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"注意学习");
    }];
    
    //将按钮添加到UIAlertController对象上
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    // 将UIAlertController模态出来
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            //做交卷处理
            [self.navigationController popoverPresentationController];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - delegate
-(void)SheetViewClick:(int)index
{
    NSLog(@"aaaaaaa");
    NSLog(@"%d",index);
    UIScrollView * scroll = _answerScrollView->_scrollView;
    scroll.contentOffset = CGPointMake((index-1)*scroll.frame.size.width, 0);
    [scroll.delegate scrollViewDidEndDecelerating:scroll];
}

-(void)creatSheetView
{
    _sheetView = [[SheetView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-80) withSuperView:self.view andQuesCount:50];
    _sheetView.delegate = self;
    [self.view addSubview:_sheetView];
}

-(void)creatModelView
{
    modelView = [[SelectModelView alloc]initWithFrame:self.view.frame addTouch:^(SelectModel model) {
        NSLog(@"当前模式：%d",model);
    }];
    [self.view addSubview:modelView];
    modelView.alpha = 0;
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"答题模式" style:UIBarButtonItemStylePlain target:self action:@selector(modelChange:)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)modelChange:(UIBarButtonItem *)item
{
    [UIView animateWithDuration:0.3 animations:^{
        modelView.alpha = 1;
    }];
}

-(void)creatToolBar
{
    UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60-64, self.view.frame.size.width, 60)];
    barView.backgroundColor = [UIColor whiteColor];
    NSArray * arr = @[[NSString stringWithFormat:@"%lu",(unsigned long)_answerScrollView.dataArray.count],@"查看答案",@"收藏本题"];
    for (int i=0; i<3; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.frame.size.width/3*i+self.view.frame.size.width/3/2-22, 0, 36, 36);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",16+i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-2.png",16+i]] forState:UIControlStateHighlighted];
        btn.tag = 301+i;
        [btn addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(btn.center.x-30, 40, 60, 18)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = arr[i];
        label.font = [UIFont systemFontOfSize:14];
        [barView addSubview:btn];
        [barView addSubview:label];
    }
    [self.view addSubview:barView];
}

-(void)clickToolBar:(UIButton *)btn
{
    switch (btn.tag) {
        case 301:   //选题抽屉
        {
            [UIView animateWithDuration:0.3 animations:^{
                _sheetView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80);
                _sheetView->_backView.alpha = 0.8;
            }];
        }
            break;
            
        case 302:   //查看答案
        {
            if ([_answerScrollView.hadAnswerArray[_answerScrollView.currentPage] intValue]!=0) {
                return;
            }else{
                AnswerModel * model = [_answerScrollView.dataArray objectAtIndex:_answerScrollView.currentPage];
                NSString * answer = model.manswer;
                char an = [answer characterAtIndex:0];
                [_answerScrollView.hadAnswerArray replaceObjectAtIndex:_answerScrollView.currentPage withObject:[NSString stringWithFormat:@"%d",an-'A'+1]];
            }
        }
            break;
            
        default:
            break;
    }
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
