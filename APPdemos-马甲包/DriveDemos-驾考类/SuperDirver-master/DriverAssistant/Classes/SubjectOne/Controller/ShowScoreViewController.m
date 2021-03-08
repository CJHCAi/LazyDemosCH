//
//  ShowScoreViewController.m
//  DriverAssistant
//
//  Created by C on 16/4/3.
//  Copyright © 2016年 C. All rights reserved.
//

#import "ShowScoreViewController.h"
#import "MainTestViewController.h"
@interface ShowScoreViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testTitle;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrongNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *undoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgTitle;

@end

@implementation ShowScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        _testTitle.text = _testScoreModel.testTitle;
    _scoreLabel.text = _testScoreModel.testScore;
    _correctNumLabel.text = _testScoreModel.correctNum;
    _wrongNumLabel.text = _testScoreModel.wrongNum;
    _undoNumLabel.text = _testScoreModel.undoNum;
    if ([_testScoreModel.testScore intValue] < 90){
        _msgTitle.text = @"很遗憾，没有通过考试！";
    }else{
        _msgTitle.text = @"恭喜你，通过考试！";
    }

}


- (instancetype)initWithTestScoreModel:(TestScoreModel *)testScoreModel{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"模拟考试成绩";
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
        self.navigationItem.leftBarButtonItem = item;
        _testScoreModel = testScoreModel;
    }
    return self;
}

- (void)onClickBack{
    NSArray* tempVCA = [self.navigationController viewControllers];
    for(UIViewController *tempVC in tempVCA)
    {
        if([tempVC isKindOfClass:[MainTestViewController class]])
        {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

@end
