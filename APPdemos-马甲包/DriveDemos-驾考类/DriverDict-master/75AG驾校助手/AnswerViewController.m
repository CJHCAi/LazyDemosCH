//
//  AnswerViewController.m
//  75AG驾校助手
//
//  Created by again on 16/3/31.
//  Copyright © 2016年 again. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerScrollView.h"
#import "Mymanager.h"
#import "AnswerModel.h"
#import "QuestiongCollectManager.h"
#import "SheetView.h"
#import "SelectModelView.h"

@interface AnswerViewController ()<SheetViewDelegate, UIAlertViewDelegate>
@property (strong,nonatomic) AnswerScrollView *answerScrollView;
@property (strong,nonatomic) SheetView *sheetView;
@property (strong,nonatomic) SelectModelView *modelView;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) UILabel *timeLabel;
@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createModelView];
    [self createData];
    [self.view addSubview:_answerScrollView];
    [self createSheetView];
}

- (void)createData
{
    if (_type == 1) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSArray *array = [Mymanager getData:answer];
        for (int i = 0; i <array.count-1; i++) {
            AnswerModel *model = array[i];
//            NSLog(@"%ld",(long)[model.mtype integerValue]);
            if ([model.pid intValue] == self.number+1) {
                [arr addObject:model];
            }
        }
        _answerScrollView = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64-60) withDataArray:arr];
    } else if(_type ==2){
        _answerScrollView = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:[Mymanager getData:answer]];
    } else if (_type ==3) {
        NSMutableArray *temArr = [[NSMutableArray alloc] init];
        NSArray *array = [Mymanager getData:answer];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        [temArr addObjectsFromArray:array];
        for (int i = 0; i <temArr.count; ) {
            int index = arc4random()%(temArr.count);
            [dataArray addObject:temArr[index]];
            [temArr removeObjectAtIndex:index];
        }
        _answerScrollView = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:dataArray];
        NSLog(@"%lu", (unsigned long)dataArray.count);
    } else if(_type == 4){
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSArray *array = [Mymanager getData:answer];
        for (int i = 0; i <array.count -1; i++) {
            AnswerModel *model = array[i];
            if ([model.sid isEqualToString:_subStrNumber]) {
                [arr addObject:model];
            }
        }
        _answerScrollView = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:arr];
    } else if (_type ==5){
        NSMutableArray *temArr = [[NSMutableArray alloc] init];
        NSArray *array = [Mymanager getData:answer];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        [temArr addObjectsFromArray:array];
        for (int i = 0; i<100; i++) {
            int index = arc4random()%(temArr.count);
            [dataArray addObject:temArr[index]];
            [temArr removeObjectAtIndex:index];
        }
        _answerScrollView = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:dataArray];
        [self createNavBtn];
    }
    if(self.type == 7){
        //读取错题
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSArray *array = [Mymanager getData:answer];
        NSArray *wrongArray = [QuestiongCollectManager getWrongQuestion];
        if (!wrongArray) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        for(AnswerModel *model in array){
            for (NSString *num in wrongArray) {
                if ([num isEqualToString:model.mid]) {
                    [arr addObject:model];
                }
            }
        }
      
        _answerScrollView = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:arr];
    }
    if (_type == 8) {
        NSMutableArray *arr =[[NSMutableArray alloc] init];
        NSArray *array = [Mymanager getData:answer];
        
        NSArray *wrongArray = [QuestiongCollectManager getCollectQuestion];
#warning 使用MBProgressHUD弹出
        if (!wrongArray) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        NSLog(@"%@", wrongArray);
        for (AnswerModel *model in array) {
            for (NSString *num in wrongArray) {
                if ([num isEqualToString:model.mid]) {
                    [arr addObject:model];
                }
            }
        }
        _answerScrollView = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withDataArray:arr];
        
    }
    if (_type!=5&&_type!=6) {
        [self createToolBar];
    } else{
        [self createTestToolBar];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
        self.timeLabel.text = @"45:00";
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = self.timeLabel;
    }
//    NSLog(@"%d", self.type);
}

- (void)runTime{
    static int time = 2700;
    time--;
    self.timeLabel.text = [NSString stringWithFormat:@"%d:%d", time/60, time%60];
}

-(void)createTestToolBar{
    UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60-64, self.view.frame.size.width, 60)];
    NSArray * arr = @[[NSString stringWithFormat:@"%lu",(unsigned long)_answerScrollView.dataArray.count],@"收藏本题"];
    barView.backgroundColor=[UIColor whiteColor];
    for (int i=0; i<2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(self.view.frame.size.width/2*i+self.view.frame.size.width/2/2-22, 0, 36, 36);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",16+i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-2.png",16+i]] forState:UIControlStateHighlighted];
        btn.tag=301+i;
        [btn addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(btn.center.x-30, 40, 60, 18)];
        label.textAlignment=NSTextAlignmentCenter;
        label.text=arr[i];
        label.font=[UIFont systemFontOfSize:14];
        [barView addSubview:btn];
        [barView addSubview:label];
    }
    [self.view addSubview:barView];
    
}

- (void)createToolBar{
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64-60, self.view.frame.size.width, 60)];
    NSArray *arr = nil;
//    if (_type ==8) {
//        arr = @[[NSString stringWithFormat:@"%lu", (unsigned long)_answerScrollView.hadAnswerArray.count], @"查看答案", @"收藏本题"];
//
//    } else {
//        
        arr = @[[NSString stringWithFormat:@"%lu", (unsigned long)_answerScrollView.dataArray.count], @"查看答案", @"收藏本题"];
//    }
    barView.backgroundColor = [UIColor whiteColor];
    for (int i=0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.frame.size.width/3*i+self.view.frame.size.width/3/2-22, 0, 36, 36);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", 16+i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-2.png", 16+i]] forState:UIControlStateHighlighted];
        btn.tag = 301+i;
        [btn addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.center.x -30, 40, 60, 18)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = arr[i];
        label.font = [UIFont systemFontOfSize:14];
        [barView addSubview:label];
        [barView addSubview:btn];
    }
    [self.view addSubview:barView];
}

- (void)clickToolBar:(UIButton *)btn{
    switch (btn.tag) {
        case 301:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.sheetView.frame = CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height);
                
                self.sheetView->_backView.alpha = 0.5;
            }];
        }
            break;
        case 302:
        {
            if (_type!=5&&_type!=6) {
                if ([_answerScrollView.hadAnswerArray[_answerScrollView.currentPage] intValue]!=0) {
                    return;
                } else {
                    AnswerModel *model = [_answerScrollView.dataArray objectAtIndex:_answerScrollView.currentPage];
                    NSString *answer = model.manswer;
                    char an = [answer characterAtIndex:0];
                    
                    [_answerScrollView.hadAnswerArray replaceObjectAtIndex:_answerScrollView.currentPage withObject:[NSString stringWithFormat:@"%d",an-'A'+1]];
                    [_answerScrollView reloadData];
                }
            }

        }
            break;
        case 303:
        {
            AnswerModel *model = _answerScrollView.dataArray[_answerScrollView.currentPage];
            [QuestiongCollectManager addCollectQuestion:[model.mid intValue]];
//            NSLog(@"%@", [QuestiongCollectManager getCollectQuestion]);
        }
        default:
            break;
    }
}

- (void)createNavBtn{
    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc] init];
    itemLeft.title = @"返回";
    [itemLeft setTarget:self];
    [itemLeft setAction:@selector(clickNavBtnReturn)];
    
    self.navigationItem.leftBarButtonItem = itemLeft;
    
    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] init];
    itemRight.title = @"交卷";
    [itemRight setTarget:self];
    [itemRight setAction:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = itemRight;
}

- (void)clickNavBtnReturn{
    NSString *title = @"温馨提示";
    NSString *message = @"时间还多,确定要离开考试么";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"不，谢谢！" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我要离开" style:
                              UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                  [self.navigationController popViewControllerAnimated:YES];
                              }];
    [alertController addAction:action];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clickRightItem{
    
    NSString *title = @"温馨提示";
    NSString *message = @"确定交卷？";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"不了" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定交卷" style:
                              UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                  [self.navigationController popViewControllerAnimated:YES];
                              }];
    [alertController addAction:action];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (void)SheetViewClick:(int)index{
    UIScrollView *scroll = self.answerScrollView->_scrollView;
    scroll.contentOffset = CGPointMake((index-1)*scroll.frame.size.width, 0);
    [scroll.delegate scrollViewDidEndDecelerating:scroll];
}
- (void)createModelView{
    self.modelView = [[SelectModelView alloc] initWithFrame:self.view.frame addTouch:^(SelectModel model) {
//        NSLog(@"当前模式:%d", model);
    }];
    [self.view addSubview:self.modelView];
    self.modelView.alpha = 0;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(modelChange:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)modelChange:(UIBarButtonItem *)item{
//    NSLog(@"22222");
    [UIView animateWithDuration:0.3 animations:^{
        self.modelView.alpha = 1;
    }];
}

- (void)createSheetView{
    self.sheetView = [[SheetView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height -150) withSuperView:self.view andQuestion:(int)_answerScrollView.dataArray.count];
    _sheetView.delegate = self;
    [self.view addSubview:_sheetView];
}
@end
