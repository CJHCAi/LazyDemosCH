//
//  HKEnterpriseIntroduceViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEnterpriseIntroduceViewController.h"
#import "IQKeyboardManager.h"

@interface HKEnterpriseIntroduceViewController () <UITextViewDelegate>
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *tipLabel;
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, strong) UIView *inputAccessoryView;
@end

@implementation HKEnterpriseIntroduceViewController

#pragma mark 设置 nav
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGFloat keyboardHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardHeight);
    }];
}
 
- (void)keyboardWillHide:(NSNotification *)noti
{
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

//导航右侧按钮点击
- (void)nextStep {
    DLog(@"保存");
    [self.view endEditing:YES];
    self.formModel.value = self.textView.text;
    self.formModel.placeHolder = self.textView.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.source == 1) {
        self.title = @"公司介绍";
    } else if (self.source == 2){
        self.title = @"职位描述";
    }
    
    self.view.backgroundColor = RGB(241,241,241);
    [self setNavItem];
    [self setUpUI];
    [self addTapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClick:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)bgClick:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

- (void)setUpUI {
    DLog(@"%f",self.view.height);
    UIView *containerView = [HKComponentFactory viewWithFrame:CGRectZero supperView:self.view];
    containerView.backgroundColor = [UIColor whiteColor];
    self.containerView = containerView;
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    UITextView *textView = [HKComponentFactory textViewWithFrame:CGRectMake(16, 16, kScreenWidth-16*2, self.containerView.height-16*2) font:[UIFont fontWithName:PingFangSCRegular size:15.f] textColor:RGB(153,153,153) placeHolder:@"详细描述一下公司介绍，字数控制在10-800字内" supperView:self.containerView];
    textView.delegate = self;
  //  textView.backgroundColor = [UIColor blueColor];
    
    if (self.formModel.value) {
        textView.text = self.formModel.value;
    }
    self.textView = textView;
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.bottom.equalTo(self.containerView);
    }];
    
    //键盘上方视图
    UIView *inputAccessoryView = [HKComponentFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 40) supperView:nil];
    inputAccessoryView.backgroundColor = RGB(241,241,241);
    self.inputAccessoryView = inputAccessoryView;   //强引用这个视图

    UILabel *tipLabel = [HKComponentFactory labelWithFrame:CGRectMake(16, 13, 100, 14) textColor:RGB(255,102,102) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:14.f] text:@"" supperView:inputAccessoryView];
    if ([self.textView.text length] > 10) {
        tipLabel.text = @"已超出10字";
    }
    self.tipLabel = tipLabel;

    UILabel *countLabel = [HKComponentFactory labelWithFrame:CGRectMake(kScreenWidth-16-80, 13, 80, 15) textColor:RGB(153,153,153) textAlignment:NSTextAlignmentRight font:[UIFont fontWithName:PingFangSCRegular size:15.f] text:@"" supperView:inputAccessoryView];
    self.countLabel = countLabel;
    self.countLabel.text = [NSString stringWithFormat:@"%ld/800",[self.textView.text length]];

    self.textView.inputAccessoryView = self.inputAccessoryView;
}

#pragma mark UITextViewDelegate

#define MAX_LIMIT_NUMS 800

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.countLabel.text = [NSString stringWithFormat:@"%d/%ld",800,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    if ([textView.text length] > 10) {
        self.tipLabel.text = @"已超出10字";
    }
    
    //不让显示负数 口口日
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%d",existTextNum,MAX_LIMIT_NUMS];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
