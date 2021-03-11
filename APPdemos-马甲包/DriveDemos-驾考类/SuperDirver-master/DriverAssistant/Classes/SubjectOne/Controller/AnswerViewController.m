//
//  AnswerViewController.m
//  DriverAssistant
//
//  Created by C on 16/3/29.
//  Copyright © 2016年 C. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerScrollView.h"
#import "DataManger.h"
#import "AnswerModel.h"
#import "SelectModelView.h"
#import "SheetView.h"
#import "QuestionCollectManager.h"
#import "ShowScoreViewController.h"
#import "TestScoreModel.h"

@interface AnswerViewController ()<SheetViewDelegate,scrollDelegate>
{
    AnswerScrollView *_answerScrollView;
    SelectModelView * _modelView;
    SheetView *_sheetView;
    UILabel *_timeLabel;
    NSTimer *_timer;
    int _time;
    NSMutableArray *_questionsArray;
    NSArray *_collcetQuestionsArray;
}
@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
    self.navigationItem.title = _myTitle;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatData];
    _answerScrollView.delegate = self;
    [self.view addSubview:_answerScrollView];
    [self creatToolBar];
    [self creatModelView];
    [self creatSheetView];
    _collcetQuestionsArray = [QuestionCollectManager getCollectQuestion];
}

/**
 初始化答题数据
 */
- (void)creatData{
    _questionsArray = [NSMutableArray array];
    if (_type == 1) {//章节练习
        NSArray *array = [DataManger getData:answer];
        for (int i = 0; i < array.count - 1; i++) {
            AnswerModel *model = array[i];
            if ([model.pid intValue] == _number+1) {
                [_questionsArray addObject:model];
            }
        }
    }else if (_type == 2){//顺序练习
        _questionsArray = [NSMutableArray arrayWithArray:[DataManger getData:answer]];
    }else if (_type == 3){//随机练习
        NSArray *array = [DataManger getData:answer];
        NSMutableArray *dataArr = [NSMutableArray array];
        [_questionsArray addObjectsFromArray:array];
        for (int i=0; i<_questionsArray.count; i++) {
            int index = arc4random()%(_questionsArray.count);
            [dataArr addObject:_questionsArray[index]];
            [_questionsArray removeObject:_questionsArray[index]];
        }
    }else if (_type == 4){//专项练习
        NSArray *array = [DataManger getData:answer];
        for (int i = 0; i < array.count - 1; i++) {
            AnswerModel *model = array[i];
            if ([model.sid intValue] == _number+1) {
                [_questionsArray addObject:model];
            }
        }
    }else if (_type == 5){//模拟考试（全真）
        NSMutableArray *TempArr = [NSMutableArray array];
        NSArray *array = [DataManger getData:answer];
        [TempArr addObjectsFromArray:array];
        for (int i = 0; i < 100; i++) {
            int index = arc4random()%(TempArr.count);
            [_questionsArray addObject:TempArr[index]];
            [TempArr removeObjectAtIndex:index];
        }
    }
    else if (_type == 6){//模拟考试(先考未答)
        NSMutableArray *TempArr = [NSMutableArray array];
        NSArray *array = [DataManger getData:answer];
        [TempArr addObjectsFromArray:array];
        for (int i = 0; i < 100; i++) {
            int index = arc4random()%(TempArr.count);
            [_questionsArray addObject:TempArr[index]];
            [TempArr removeObjectAtIndex:index];
        }
    }else if (_type == 7){//我的错题
        //读取错题
        NSArray *dataArray = [DataManger getData:answer];
        NSArray *wrongArray = [QuestionCollectManager getWrongQuestion];
        for (AnswerModel *model in dataArray) {
            for (NSString *num in wrongArray) {
                if ([num isEqualToString:model.mid]) {
                    [_questionsArray addObject:model];
                }
            }
        }
        _answerScrollView = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60-64) withDataArray:_questionsArray];
    }else if (_type == 8){//我的收藏
        //读取收藏题目
        NSArray *dataArray = [DataManger getData:answer];
        NSArray *array = [QuestionCollectManager getCollectQuestion];
        for (AnswerModel *model in dataArray) {
            for (NSString *num in array) {
                if ([num isEqualToString:model.mid]) {
                    [_questionsArray addObject:model];
                }
            }
        }
    }
    NSLog(@"%ld",_questionsArray.count);
    _answerScrollView = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60-64) withDataArray:_questionsArray];
    
    
    
}

#pragma mark - NavBar
- (void)creatNavBarItem
{
    if (_type !=5 && _type!=6) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"答题模式" style:UIBarButtonItemStylePlain target:self action:@selector(modelChange:)];
        self.navigationItem.rightBarButtonItem = item;
    }else{
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickNavBtn:)];
        leftItem.tag = 401;
        self.navigationItem.leftBarButtonItem = leftItem;
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"交卷" style:UIBarButtonItemStylePlain target:self action:@selector(clickNavBtn:)];
        rightItem.tag = 402;
        self.navigationItem.rightBarButtonItem = rightItem;
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
        _time = 3600;
        _timeLabel.text = [NSString stringWithFormat:@"%d:%d",_time/60,_time%60];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = _timeLabel;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
        
    }
}

- (void)runTime
{
    
    if (_time > 0) {
        _time--;
        _timeLabel.text = [NSString stringWithFormat:@"%d:%d",_time/60,_time%60];
    }else{
        if (_time == 0) {
            [_timer invalidate];
            _timer = nil;
            UIAlertController *alterCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"答题时间到,系统已自动交卷！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定并查看成绩" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIBarButtonItem *item = (UIBarButtonItem *)[self.view viewWithTag:402];
                [self submitScoreWithItem:item];
            }];
            [alterCtl addAction:okAction];
            [self presentViewController:alterCtl animated:YES completion:nil];
        }
    }
    
    
    
}
/**
 返回和交卷
 */
- (void)clickNavBtn:(UIBarButtonItem *)item
{
    if (item.tag == 401) {
        UIAlertController *alterCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"时间还够,确定离开考试吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定,我要离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self submitScoreWithItem:item];
        }];
        [alterCtl addAction:cancelAction];
        [alterCtl addAction:okAction];
        [self presentViewController:alterCtl animated:YES completion:nil];
    }
    else if (item.tag == 402)
    {
        UIAlertController *alterCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"时间还够,确定要交卷吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定,我要交卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self submitScoreWithItem:item];
        }];
        [alterCtl addAction:cancelAction];
        [alterCtl addAction:okAction];
        [self presentViewController:alterCtl animated:YES completion:nil];
    }
    
    
}

/**
 交卷
 */
- (void)submitScoreWithItem:(UIBarButtonItem *)item
{
    int score = 0;
    int correctNum = 0;
    int wrongNum = 0;
    int undoNum = 0;
    NSArray *myAnswerArray = _answerScrollView.hadAnswerArray;
    NSArray *answerArray = _answerScrollView.dataArray;
    for (int i=0; (int)i<myAnswerArray.count; i++) {
        AnswerModel *model = answerArray[i];
        NSString *answerStr = model.manswer;
        NSString *myAnswerStr = [NSString stringWithFormat:@"%c",'A'-1+[myAnswerArray[i] intValue]];
        
        if ([myAnswerArray[i] isEqualToString:@"0"]) {
            undoNum++;
        }else{
            if ([model.mtype intValue] == 1)
            {//选择题
                if ([answerStr isEqualToString:myAnswerStr]) {
                    //答对了
                    score++;
                    correctNum++;
                }else
                {
                    wrongNum++;
                }
                
            }else if([model.mtype intValue] == 2)
            {//判断题
                if ([answerStr isEqualToString:[self letterAnswerToCNWithAnswer:myAnswerStr]]) {
                    score++;
                    correctNum++;
                }else
                {
                    wrongNum++;
                }
            }
        }
        
    }
    TestScoreModel *testScoreModel = [[TestScoreModel alloc] init];
    testScoreModel.testTitle = @"科目一 理论考试";
    testScoreModel.testScore = [NSString stringWithFormat:@"%d",score];
    testScoreModel.correctNum = [NSString stringWithFormat:@"%d",correctNum];
    testScoreModel.wrongNum = [NSString stringWithFormat:@"%d",wrongNum];
    testScoreModel.undoNum = [NSString stringWithFormat:@"%d",undoNum];
    if (item.tag == 401) {//返回
        [self.navigationController popViewControllerAnimated:YES];
    }else if(item.tag == 402){//交卷
        ShowScoreViewController *showScoreCtl = [[ShowScoreViewController alloc] initWithTestScoreModel:testScoreModel];
        [self.navigationController pushViewController:showScoreCtl animated:YES];
    }
    
}

/**
 判断题答案由字母转成文字
 */
- (NSString *)letterAnswerToCNWithAnswer:(NSString *)answer
{
    if ([answer isEqualToString:@"A"]){
        return @"对";
    }else if ([answer isEqualToString:@"B"]){
        return @"错";
    }else{
        return nil;
    }
}

#pragma mark - toolBar
- (void)creatToolBar{
    NSArray *array;
    int iconCount;
    if (_type != 5&&_type != 6) {
        array= @[[NSString stringWithFormat:@"%d/%lu",1,(unsigned long)_answerScrollView.dataArray.count],@"查看答案",@"收藏本题"];
        iconCount = 3;
    }else
    {
        array = @[[NSString stringWithFormat:@"%d/%lu",1,(unsigned long)_answerScrollView.dataArray.count],@"收藏本题"];
        iconCount = 2;
    }
    [self creatToolBarWithArray:array andIconCout:iconCount];
    
}

- (void)creatToolBarWithArray:(NSArray *)array andIconCout:(int)iconCount{
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-70-64, self.view.frame.size.width, 70)];
    barView.backgroundColor = [UIColor whiteColor];
    for (int i=0; i<iconCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.frame.size.width/iconCount*i+self.view.frame.size.width/iconCount/2-22, 8, 36, 36);
   
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",16+i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-2.png",16+i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(onClickToolBar:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.center.x - 30, 48, 60, 18)];

        label.textAlignment = NSTextAlignmentCenter;
            label.text = @"取消收藏";
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:14];
        [barView addSubview:btn];
        [barView addSubview:label];
        
        if (iconCount == 3) {//练习模式
            btn.tag = 301+i;
            label.tag = 501 + i;
        }else{//模拟考试
            btn.tag = 301+i*2;
            label.tag = 501+i*2;
        }
        //第一题可能已经收藏
        if (i==2 && _questionsArray.count>2) {
            AnswerModel *model = [_questionsArray objectAtIndex:0];
            NSArray *collectArr = [QuestionCollectManager getCollectQuestion];
            for (NSNumber *num in collectArr) {
                if ([num intValue]==[model.mid intValue]) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"18-2"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"18"] forState:UIControlStateHighlighted];
                    label.text = @"取消收藏";
                    break;
                }
            }
        }

        
    }
    [self.view addSubview:barView];
    
}

- (void)creatModelView
{
    _modelView = [[SelectModelView alloc] initWithFrame:self.view.frame andTouch:^(UIButton *btn) {
        switch (btn.tag) {
            case 401:
            {
                if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"背题模式"]) {
                    for (int i = 0; i<_answerScrollView.tempAnswerArray.count; i++) {
                        [_answerScrollView.tempAnswerArray replaceObjectAtIndex:i withObject:@"0"];
                    }
                    self.navigationItem.rightBarButtonItem.title = @"答题模式";
                    [_answerScrollView reloadData];
                }
                
            }
                break;
            case 402:
            {
                if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"答题模式"]) {
                    for (int i = 0; i<_answerScrollView.tempAnswerArray.count; i++) {
                        [_answerScrollView.tempAnswerArray replaceObjectAtIndex:i withObject:@"1"];
                    }                    self.navigationItem.rightBarButtonItem.title = @"背题模式";
                    [_answerScrollView reloadData];
                }
            }
                break;
                
            default:
                break;
        }
    }];
    [self.view addSubview:_modelView];
    _modelView.alpha = 0;
    [self creatNavBarItem];
}
- (void)modelChange:(UIBarButtonItem *)item
{
    [UIView animateWithDuration:0.3 animations:^{
        _modelView.alpha = 1;
    }];
}

#pragma mark - SheetView
- (void)creatSheetView
{
    _sheetView = [[SheetView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-80) withSuperView:self.view andQuestionCount:(int)_answerScrollView.dataArray.count];
    [self.view addSubview:_sheetView];
}

- (void)onClickToolBar:(UIButton *)btn
{
    switch (btn.tag) {
        case 301://上拉抽屉
        {
            [UIView animateWithDuration:0.3 animations:^{
                _sheetView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80);
                _sheetView.backView.alpha = 0.8;
                _sheetView.delegate = self;
            }];
        }
            break;
        case 302://查看答案
        {
            if ([_answerScrollView.hadAnswerArray[_answerScrollView.currentPage] intValue]!=0) {
                return;
            }else{
                AnswerModel * model = [_answerScrollView.dataArray objectAtIndex:_answerScrollView.currentPage];
                NSString * answer = model.manswer;
                char an = [answer characterAtIndex:0];
                
                [_answerScrollView.hadAnswerArray replaceObjectAtIndex:_answerScrollView.currentPage withObject:[NSString stringWithFormat:@"%d",an-'A'+1]];
                [_answerScrollView reloadData];
            }
            
        }
            break;
        case 303://收藏本题or取消收藏
        {
            UILabel *collectLabel = [self.view viewWithTag:503];
            AnswerModel *model =_answerScrollView.dataArray[_answerScrollView.currentPage];
            if ([collectLabel.text isEqualToString:@"收藏本题"]) {
                [QuestionCollectManager addCollectQuestion:[model.mid intValue]];
                [btn setBackgroundImage:[UIImage imageNamed:@"18-2"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"18"] forState:UIControlStateHighlighted];
                collectLabel.text = @"取消收藏";
            }else if ([collectLabel.text isEqualToString:@"取消收藏"]){
                [QuestionCollectManager removeCollectQuestion:[model.mid intValue]];
                [btn setBackgroundImage:[UIImage imageNamed:@"18"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"18-2"] forState:UIControlStateHighlighted];
                collectLabel.text = @"收藏本题";
            }
            _collcetQuestionsArray = [QuestionCollectManager getCollectQuestion];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SheetViewDelegate
- (void)SheetViewClick:(int)index
{
    UIScrollView *scrollView = _answerScrollView.scrollView;
    scrollView.contentOffset = CGPointMake((index-1)*scrollView.frame.size.width, 0);
    UILabel *label = (UILabel *)[self.view viewWithTag:501];
    label.text = [NSString stringWithFormat:@"%d/%lu",index,(unsigned long)_answerScrollView.dataArray.count];
    [scrollView.delegate scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - AnswerScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(int)index{
    UILabel *label = (UILabel *)[self.view viewWithTag:501];
    label.text = [NSString stringWithFormat:@"%d/%lu",index,(unsigned long)_answerScrollView.dataArray.count];
    for (int i=0; i<_questionsArray.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i+1001];
        button.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    }
    UIButton *button = (UIButton *)[_sheetView viewWithTag:index+1000];
    button.backgroundColor = [UIColor orangeColor];
    AnswerModel *model;
    if (_questionsArray.count == index) {
        model = [_questionsArray objectAtIndex:index-1];
    }else{
        model = [_questionsArray objectAtIndex:index];
    }
    UIButton *btncollet = (UIButton *)[self.view viewWithTag:303];
    UILabel *labcollect = (UILabel *)[self.view viewWithTag:503];
    [btncollet setBackgroundImage:[UIImage imageNamed:@"18"] forState:UIControlStateNormal];
    [btncollet setBackgroundImage:[UIImage imageNamed:@"18-2"] forState:UIControlStateHighlighted];
    labcollect.text = @"收藏本题";

    for (NSNumber *num in _collcetQuestionsArray) {
        if ([num intValue]+1==[model.mid intValue]) {
            [btncollet setBackgroundImage:[UIImage imageNamed:@"18-2"] forState:UIControlStateNormal];
            [btncollet setBackgroundImage:[UIImage imageNamed:@"18"] forState:UIControlStateHighlighted];
            labcollect.text = @"取消收藏";
            break;
        }
    }

}

- (void)clearAnswerData{
    for (int i=0; i<_answerScrollView.hadAnswerArray.count; i++) {
        _answerScrollView.hadAnswerArray[i] = @0;
    }
    [_answerScrollView reloadData];
}
- (void)answerQuestion:(NSArray *)questionArr {
    int score = 0;
    int correctNum = 0;
    int wrongNum = 0;
    int undoNum = 0;
    NSArray *myAnswerArray = _answerScrollView.hadAnswerArray;
    NSArray *answerArray = _answerScrollView.dataArray;
    for (int i=0; (int)i<myAnswerArray.count; i++) {
        AnswerModel *model = answerArray[i];
        NSString *answerStr = model.manswer;
        NSString *myAnswerStr = [NSString stringWithFormat:@"%c",'A'-1+[myAnswerArray[i] intValue]];
        
        if ([myAnswerArray[i] isEqualToString:@"0"]) {
            undoNum++;
        }else{
            if ([model.mtype intValue] == 1)
            {//选择题
                if ([answerStr isEqualToString:myAnswerStr]) {
                    //答对了
                    score++;
                    correctNum++;
                }else
                {
                    wrongNum++;
                }
                
            }else if([model.mtype intValue] == 2)
            {//判断题
                if ([answerStr isEqualToString:[self letterAnswerToCNWithAnswer:myAnswerStr]]) {
                    score++;
                    correctNum++;
                }else
                {
                    wrongNum++;
                }
            }
        }
        
    }
    UILabel *rightNumLabel = (UILabel *)[_sheetView viewWithTag:601];
    UILabel *wrongNumLabel = (UILabel *)[_sheetView viewWithTag:602];
    UILabel *undoNumLabel = (UILabel *)[_sheetView viewWithTag:603];
    rightNumLabel.text = [NSString stringWithFormat:@"%d",score];
    wrongNumLabel.text = [NSString stringWithFormat:@"%d",wrongNum];
    undoNumLabel.text = [NSString stringWithFormat:@"%d",undoNum];
}

@end
