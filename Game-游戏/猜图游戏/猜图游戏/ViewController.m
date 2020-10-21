//
//  ViewController.m
//  猜图游戏
//
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "ViewController.h"
#import "HMQuestionModel.h"

const int rowButtonCount = 7;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *moneyButton;
@property (weak, nonatomic) IBOutlet UILabel *indexLable;
@property (weak, nonatomic) IBOutlet UILabel *textLable;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//模型数组索引
@property (assign, nonatomic) int index;
//保存icon的原来的frame
@property (assign, nonatomic) CGRect oldFrame;
//保存阴影按钮
@property (strong, nonatomic) UIButton *coverButton;
//模型数组
@property (strong, nonatomic) NSArray *questions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //取出模型
    HMQuestionModel *questionModel = self.questions[self.index];
    [self setOptionButtonForModel:questionModel];
    //拿到icon的当前frame,便于以后恢复原来的大小
    self.oldFrame = self.iconButton.frame;
    
    self.index = -1;
    //初始化imageView
    [self didClickNextButton];
}

#pragma mark - 点击的图片
- (IBAction)icon {
    if (self.coverButton) {
        [self recover];
    } else {
        [self didClickPlusIconButton];
    }
}

#pragma mark - 点击大图
- (IBAction)didClickPlusIconButton {
    UIButton *coverButton = [[UIButton alloc] init];
    coverButton.frame = self.view.bounds;
    [self.view addSubview:coverButton ];
    self.coverButton = coverButton;
    coverButton.backgroundColor = [UIColor blackColor];
    coverButton.alpha = 0;
    CGFloat iconW = self.view.frame.size.width;
    CGFloat iconH = iconW;
    CGFloat iconY = (self.view.frame.size.height - iconH) * 0.5;
    [self.view bringSubviewToFront:self.iconButton];
    
    [UIView animateWithDuration:2 animations:^{
        self.iconButton.frame = CGRectMake(0, iconY, iconW, iconH);
        coverButton .alpha = 0.6;
    }];
    
    //监听阴影按钮点击,把被点击的按钮传进来
    [self.coverButton  addTarget:self action:@selector(recover) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 设置数据
- (void)setDataForModel:(HMQuestionModel *)model {
    self.textLable.text = model.title;
    self.indexLable.text = [NSString stringWithFormat:@"%d / %zd", self.index + 1, self.questions.count];
    [self.iconButton setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
}

#pragma mark - 恢复
- (void)recover {
    [UIView animateWithDuration:1.5 animations:^{
        self.iconButton.frame = self.oldFrame;
        self.coverButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self.coverButton removeFromSuperview];
    //  ************** 用weak修饰的时候就不会有问题,但是还是要设置为nil,因为内存不会这么快回收
         self.coverButton = nil;
    }];
}

#pragma mark - 扣分
-(void)reduceScore:(int)score {
    [self.moneyButton setTitle:[NSString stringWithFormat:@"%d", score] forState:UIControlStateNormal];
}

#pragma mark - 点击提示
- (IBAction)didClickPromptButton {
    //取出当前分数
    int score = self.moneyButton.currentTitle.intValue;
    score -= 1000;
    //扣分
    if (score) {
        [self reduceScore:score];
    } else {
        //弹框
        [self tangKuang1];
    }
    
    //清空所以得答案按钮的文字
    for (UIButton *answerButton in self.answerView.subviews) {
        [self didAnsweButton:answerButton];
    }
    //取出正确答案,把第一个字显示出来
    HMQuestionModel *model = self.questions[self.index];
    NSString *str =  model.answer;
    //截取第一个字符
    str = [str substringToIndex:1];

    for (UIButton *button in self.optionView.subviews) {
        if ([str isEqualToString:button.currentTitle]) {
            [self didOptionButton:button];
            break;
        }
    }
}

#pragma mark - 点击帮助
- (IBAction)didClickHelpButton {
   [self tangKuang2];
}

#pragma mark - 点击下一张
- (IBAction)didClickNextButton {
    //打开用户交互
    self.optionView.userInteractionEnabled = YES;
    //加载数据
    self.index++;
    if (self.index  == 10) {
        [self tangKuang3];
        self.view.userInteractionEnabled = NO;
        return;
    }
 
    if (self.index == 9) {
        self.nextButton.enabled = NO;
        
    }
    
    HMQuestionModel *model = self.questions[self.index];
    [self setDataForModel:model];
    [self setAnswerButtonForModel:model];
    [self setOptionButtonForModel:model];
}

#pragma mark - 生成答案按钮
- (void)setAnswerButtonForModel:(HMQuestionModel *)model {
    //清空上次的答案按钮
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger count = model.answer.length;
    for (int i = 0; i < count; i++) {
        int space = 10;//行间距
        CGFloat answerButtonY = 0;
        CGFloat answerButtonH = self.answerView.frame.size.height;
        CGFloat answerButtonW = answerButtonH;
        CGFloat answerButtonX = 0;
        int leftSpace = (self.view.frame.size.width - count * answerButtonW - (count - 1) * space) * 0.5;
        answerButtonX = leftSpace + i * (space + answerButtonW);
        UIButton *answerButton = [[UIButton alloc] init];
        [self.answerView addSubview:answerButton];
        answerButton.frame = CGRectMake(answerButtonX, answerButtonY, answerButtonW, answerButtonH);
        [answerButton setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerButton setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        //添加监听
        [answerButton addTarget:self action:@selector(didAnsweButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 点击的答案按钮
- (void)didAnsweButton:(UIButton *)button {
    //打开optionView的用户交互
    self.optionView.userInteractionEnabled = YES;
    //让当前的按钮的文字设置为nil
    [button setTitle:nil forState:UIControlStateNormal];
    //遍历数组通过tag值拿到和当前文字相同的选项按钮,让选项按钮显示
    for (UIButton *optionButton in self.optionView.subviews) {
        if (optionButton.tag == button.tag) {
            //让和答案按钮一样文字显示
            optionButton.hidden = NO;
        }
    }
    [self setTitleForColor:[UIColor blackColor]];
 
}

#pragma mark - 生成选项按钮
- (void)setOptionButtonForModel:(HMQuestionModel *)model {
    //清空上次的答案按钮
    [self.optionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger optionButtonRowCount = model.options.count;
    //option按钮
    int colSpace = 20;
    int rowSpace = 10;
    int topSpace = 15;
    CGFloat optionButtonX = 0;
    CGFloat optionButtonY = 0;
    for (int j = 0; j < optionButtonRowCount; j++) {
        int row = j / rowButtonCount;
        int col = j % rowButtonCount;
        
        CGFloat optionButtonW = 40;
        CGFloat optionButtonH = optionButtonW;
        int optionleftSpace = (self.view.frame.size.width - rowButtonCount * optionButtonW - (rowButtonCount - 1) * rowSpace) * 0.5;
        ;
        optionButtonX = optionleftSpace + col * (rowSpace + optionButtonW);
        optionButtonY = topSpace + row * (colSpace + optionButtonH);
        
        UIButton *optionButton = [[UIButton alloc] init];
        [self.optionView addSubview:optionButton];
        //设置每个选项按钮的tag值
        optionButton.tag = j + 1;
        
        optionButton.frame = CGRectMake(optionButtonX, optionButtonY, optionButtonW, optionButtonH);
        
        [optionButton setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionButton setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        
        [optionButton setTitle:model.options[j] forState:UIControlStateNormal];
        [optionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //监听按钮的点击
        [optionButton addTarget:self action:@selector(didOptionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 点击的选项按钮
- (void)didOptionButton:(UIButton *)button {
    //隐藏按钮
    button.hidden = YES;
    //假设答案按钮已经满了
    BOOL isFull = YES;
    for (UIButton *answerButton in self.answerView.subviews) {
        if (!answerButton.currentTitle || !answerButton.currentTitle.length) {
            [answerButton setTitle:button.currentTitle forState:UIControlStateNormal];
            [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //把当前的点击的button的tag传给answerButton的tag
            answerButton.tag = button.tag;
            break;
        }
    }
 
    //**************
    //遍历答案数组只要有一个不满就isFull为NO,为YES的时候就禁止用户交互
    for (UIButton *answerButton in self.answerView.subviews) {
        if (!answerButton.currentTitle || !answerButton.currentTitle.length) {
            isFull = NO;
            break;
        }
    }
    
    //取出模型
    HMQuestionModel *model = self.questions[self.index];
    //创建一个可变的NSString
    NSMutableString *answerMstr = [NSMutableString string];
    if (isFull) {
        //取出当前的答案按钮的文字
        for (UIButton *answerButton in self.answerView.subviews) {
            [answerMstr appendString:answerButton.currentTitle];
        }
        self.optionView.userInteractionEnabled = NO;
        //取出当前分数
        int score = self.moneyButton.currentTitle.intValue;
        //扣分
        score += 1000;
        //判断是输入的答案是否正确,设置相对应得文字的颜色
        if ([model.answer isEqualToString:answerMstr]) {
                     [self reduceScore:score];
            [self setTitleForColor:[UIColor blueColor]];
            
            [self performSelector:@selector(didClickNextButton) withObject:nil afterDelay:1.1];
        } else {
         [self setTitleForColor:[UIColor redColor]];
        }
    }
}

#pragma mark - 设置文字的颜色
- (void)setTitleForColor:(UIColor *)colcor {
    for (UIButton *answerButton in self.answerView.subviews) {
        [answerButton setTitleColor:colcor forState:UIControlStateNormal];
    }
}

#pragma mark - 懒加载
- (NSArray *)questions {
    if (!_questions) {
        _questions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil]];
        NSMutableArray *Marr = [NSMutableArray array];
        for (NSDictionary *dict in _questions) {
            HMQuestionModel *questionModel = [[HMQuestionModel alloc] initWithDict:dict];
            [Marr addObject:questionModel];
        }
        _questions = Marr;
    }
    return _questions;
}

#pragma mark - 金币不足的弹框
- (void)tangKuang1 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"余额不足请充值" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 帮助的弹框
- (void)tangKuang2 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"正在开发" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 过关的弹框
- (void)tangKuang3 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜你过关了" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
