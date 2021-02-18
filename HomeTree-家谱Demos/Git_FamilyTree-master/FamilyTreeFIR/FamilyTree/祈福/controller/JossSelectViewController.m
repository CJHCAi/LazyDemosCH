//
//  JossSelectViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/20.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "JossSelectViewController.h"

@interface JossSelectViewController()<UIScrollViewDelegate>
/** 背景图*/
@property (nonatomic, strong) UIImageView *backIV;
/** 白色背景*/
@property (nonatomic, strong) UIImageView *whiteBackIV;
/** 阶梯背景图*/
@property (nonatomic, strong) UIImageView *ladderIV;
/** 白色背景上的佛像*/
@property (nonatomic, strong) UIImageView *jossIV;
/** 白色背景上的文字说明*/
@property (nonatomic, strong) UITextView *jossInfoTX;
/** 请佛按钮*/
@property (nonatomic, strong) UIButton *inviteJossBtn;
/** 佛像名字数组*/
@property (nonatomic, strong) NSArray<NSString *> *jossNameArr;
/** 佛像图片名字数组*/
@property (nonatomic, strong) NSArray<NSString *> *jossImageNameArr;
/** 佛像说明数组*/
@property (nonatomic, strong) NSMutableArray<NSString *> *jossInfoArr;
/** 佛像选择滚动视图*/
@property (nonatomic, strong) UIScrollView *jossSelectSV;
@end

@implementation JossSelectViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.backIV];
    [self.backIV addSubview:self.ladderIV];
    [self.backIV addSubview:self.whiteBackIV];
    [self.whiteBackIV addSubview:self.jossIV];
    [self.whiteBackIV addSubview:self.jossInfoTX];
    [self.whiteBackIV addSubview:self.inviteJossBtn];
    [self initjossSelectSV];
}

#pragma mark - 视图初始化
-(void)initjossSelectSV{
    [self.backIV addSubview:self.jossSelectSV];
    for (int i = 0; i < 12; i++) {
        UIImageView *jossIV = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width/3*i, 0, Screen_width/3, 0.7*CGRectH(self.jossSelectSV))];
        jossIV.image = MImage(self.jossImageNameArr[i]);
        jossIV.contentMode = UIViewContentModeScaleAspectFit;
        [self.jossSelectSV addSubview:jossIV];
        UILabel *jossNameLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(jossIV), CGRectYH(jossIV), CGRectW(jossIV), 0.28*CGRectH(self.jossIV))];
        jossNameLB.textAlignment = NSTextAlignmentCenter;
        jossNameLB.text = self.jossNameArr[i];
        [self.jossSelectSV addSubview:jossNameLB];
    }
}

#pragma mark - 点击方法
-(void)clickInviteJossBtn{
    MYLog(@"请佛");
    [self.delegate chooseJossImage:self.jossIV.image];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    MYLog(@"偏移量%lf",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x == 0) {
        [scrollView setContentOffset:CGPointMake(Screen_width/3*7, 0) animated:NO];
        self.jossIV.image = MImage(@"qf_f7");
    }else if (scrollView.contentOffset.x == Screen_width/3*9){
        [scrollView setContentOffset:CGPointMake(Screen_width/3*2, 0) animated:NO];
        self.jossIV.image = MImage(@"qf_f2");
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        //完成滚动更改佛像显示信息和图
        int index = round(scrollView.contentOffset.x/(Screen_width/3.0));
        MYLog(@"四舍五入结果%d",index);
        [scrollView setContentOffset:CGPointMake(index*Screen_width/3, 0) animated:NO];
        //佛像号是
        int indexTrue = index;
        if (index == 0) {
            indexTrue = 8;
        }
        if (index == 9) {
            indexTrue = 2;
        }
        //图
        self.jossIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"qf_f%d",indexTrue]];
        //说明
        self.jossInfoTX.text = self.jossInfoArr[indexTrue-1];
    }
    
}
//保证因为惯性而导致最终图显示结果不一致
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //完成滚动更改佛像显示信息和图
    int index = round(scrollView.contentOffset.x/(Screen_width/3.0));
    MYLog(@"四舍五入结果%d",index);
    [scrollView setContentOffset:CGPointMake(index*Screen_width/3, 0) animated:NO];
    //佛像号是
    int indexTrue = index;
    if (index == 0) {
        indexTrue = 8;
    }
    if (index == 9) {
        indexTrue = 2;
    }
    self.jossIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"qf_f%d",indexTrue]];
    self.jossInfoTX.text = self.jossInfoArr[indexTrue-1];
}


#pragma mark - lazyLoad
-(UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _backIV.image = MImage(@"bg");
        _backIV.userInteractionEnabled = YES;
    }
    return _backIV;
}

-(UIImageView *)whiteBackIV{
    if (!_whiteBackIV) {
        _whiteBackIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.04375*CGRectW(self.backIV), 0.0264*CGRectH(self.backIV), 0.9125*CGRectW(self.backIV), 0.5714*CGRectH(self.backIV))];
        _whiteBackIV.image = MImage(@"qf_bg_03");
        _whiteBackIV.userInteractionEnabled = YES;
    }
    return _whiteBackIV;
}


-(UIImageView *)ladderIV{
    if (!_ladderIV) {
        _ladderIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.8352*CGRectH(self.backIV), Screen_width, 0.1538*CGRectH(self.backIV))];
        _ladderIV.image = MImage(@"qf_bgsk");
        UIImageView *redLadderIV = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width/3-10, 0, Screen_width/3+20, CGRectH(_ladderIV)+5)];
        redLadderIV.image = MImage(@"qf_hukuai");
        MYLog(@"%lf",redLadderIV.frame.size.width);
        [_ladderIV addSubview:redLadderIV];
    }
    return _ladderIV;
}

-(UIImageView *)jossIV{
    if (!_jossIV) {
        _jossIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 0.4760*CGRectW(self.whiteBackIV), 0.8077*CGRectH(self.whiteBackIV))];
        _jossIV.contentMode = UIViewContentModeScaleAspectFit;
        _jossIV.image = MImage(@"qf_f7");
    }
    return _jossIV;
}

-(UITextView *)jossInfoTX{
    if (!_jossInfoTX) {
        _jossInfoTX = [[UITextView alloc]initWithFrame:CGRectMake(0.4966*CGRectW(self.whiteBackIV), 0.0385*CGRectH(self.whiteBackIV), 0.4897*CGRectW(self.whiteBackIV), 0.7077*CGRectH(self.whiteBackIV))];
        _jossInfoTX.editable = NO;
        NSString *str = self.jossInfoArr[6];
        _jossInfoTX.attributedText = [NSString getLineSpaceStr:str];
        _jossInfoTX.backgroundColor = [UIColor clearColor];
    }
    return _jossInfoTX;
}

-(UIButton *)inviteJossBtn{
    if (!_inviteJossBtn) {
        _inviteJossBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5137*CGRectW(self.whiteBackIV), 0.7885*CGRectH(self.whiteBackIV), 0.4349*CGRectW(self.whiteBackIV), 0.1192*CGRectH(self.whiteBackIV))];
        //_inviteJossBtn.backgroundColor = [UIColor blueColor];
        [_inviteJossBtn setBackgroundImage:MImage(@"qf_anniu") forState:UIControlStateNormal];
        [_inviteJossBtn setTitle:@"请佛" forState:UIControlStateNormal];
        [_inviteJossBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_inviteJossBtn addTarget:self action:@selector(clickInviteJossBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteJossBtn;
}

-(NSArray<NSString *> *)jossNameArr{
    if (!_jossNameArr) {
        _jossNameArr = @[@"财神",@"弥勒佛",@"月老",@"地藏王",@"普贤菩萨",@"关公",@"观世音菩萨",@"释迦牟尼",@"财神",@"弥勒佛",@"月老",@"地藏王"];
    }
    return _jossNameArr;
}

-(NSArray<NSString *> *)jossImageNameArr{
    if (!_jossImageNameArr) {
        _jossImageNameArr = @[@"qf_f7",@"qf_f8",@"qf_f1",@"qf_f2",@"qf_f3",@"qf_f4",@"qf_f5",@"qf_f6",@"qf_f7",@"qf_f8",@"qf_f1",@"qf_f2"];
    }
    return _jossImageNameArr;
}

-(NSMutableArray<NSString *> *)jossInfoArr{
    if (!_jossInfoArr) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JossInfo.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
        _jossInfoArr = [@[] mutableCopy];
        [_jossInfoArr addObjectsFromArray:arr];

    }
    return _jossInfoArr;
}

-(UIScrollView *)jossSelectSV{
    if (!_jossSelectSV) {
        _jossSelectSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0.6044*CGRectH(self.backIV), Screen_width, 0.3868*CGRectH(self.backIV))];
        _jossSelectSV.contentSize = CGSizeMake(Screen_width/3*12, 0.3868*CGRectH(self.backIV));
        MYLog(@"%lf",Screen_width/3*10.0);
        _jossSelectSV.delegate = self;
        _jossSelectSV.bounces = NO;
        //_jossSelectSV.contentOffset = CGPointMake(Screen_width/3*2, 0);
        _jossSelectSV.contentOffset = CGPointMake(Screen_width/3*7, 0);
    }
    return _jossSelectSV;
}

@end
