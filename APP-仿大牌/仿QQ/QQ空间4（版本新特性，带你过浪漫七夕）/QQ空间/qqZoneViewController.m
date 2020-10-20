//
//  qqZoneViewController.m
//  QQ空间登录
//
//  Created by 妖精的尾巴 on 15-8-20.
//  Copyright (c) 2015年 妖精的尾巴. All rights reserved.
//

#import "qqZoneViewController.h"
#import "qqCenterViewController.h"
@interface qqZoneViewController ()
/**
 *创建QQ空间的背景图片
 */
@property(nonatomic,strong)UIImageView* imageView;
/**
 *创建左边视图的背景图片
 */
@property(nonatomic,strong) UIImageView* leftBgimageView;
/**
 *创建顶部的半透明的topLabel，
 */
@property(nonatomic,strong)UILabel* topLabel;
/**
 *创建QQ空间底部的topLabel
 */
@property(nonatomic,strong)UILabel* bottomLabel;
/**
 *创建scrollView作为其他所有控件的父视图
 */
//@property(nonatomic,strong)UIScrollView* bgScroll;
/**
 *顶部半透明的左边按钮
 */
@property(nonatomic,strong)UIButton* leftBtn;
/**
 *顶部半透明的右边按钮
 */
@property(nonatomic,strong)UIButton* rightBtn;
/**
 *左边的抽屉视图view
 */
@property(nonatomic,strong)UIView* leftView;
/**
 *用于左边抽屉视图点击返回的遮盖的按钮
 */
@property(nonatomic,strong)UIButton* coverBtn;
/**
 *用于记录左边抽屉视图是否被拉出来
 */
@property(nonatomic,assign)BOOL isShow;
/**
 *用来模拟根服务器对接的速度（也就是模拟当前网速，本次模拟没有考虑链接失败的情况）
 */
@property(nonatomic,strong)NSTimer* timer;
/**
 *定时器变量
 */
@property(nonatomic,assign)int i;
/**
 *缓冲界面（菊花界面）
 */
@property(nonatomic,strong)UIActivityIndicatorView* actIndView;
/**
 *下拉刷新背景控件
 */
@property(nonatomic,strong)UILabel* loveLabel;
/**
 *创建第一个显示好友的View
 */
@property(nonatomic,strong)UIView* firstView;
/**
 *创建第二个显示好友的View
 */
@property(nonatomic,strong)UIView* secondView;
/**
 *记录好友是否点赞
 */
@property(nonatomic,assign)BOOL isAppreciate;
/**
 *好友点赞按钮
 */
@property(nonatomic,strong)UIButton* appreciateBtn;
/**
 *第二个好友点赞按钮
 */
@property(nonatomic,strong)UIButton* secondAppreciateBtn;
/**
 *好友点赞的头像
 */
@property(nonatomic,strong)UIImageView* avaterImage;
/**
 *应用中心的按钮（也就是中间圆形图片）
 */
@property(nonatomic,strong)UIButton* circleBtn;
/**
 *左边视图顶部衬托背景图片
 */
@property(nonatomic,strong)UIImageView* leftBottomBgimageView;

@end

@implementation qqZoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
   // [self createScrollView];
    [self createBgImage];
    [self createLabel];
    [self createLfetBtn];
    [self createActivityIndicatorView];
    /**
     *开启定时器
     */
     self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self createBottomLabel];
    //[self createFirstView];
    //[self createSecondView];
//    [self createFirstContentInView];
//    [self createSecondContentInView];
    [self createCenterBtn];
    /**
     *将点赞属性设为yes
     */
    self.isAppreciate=YES;
}
/**
 *创建QQ空间顶部的topLabel
 */
-(void)createLabel
{
   self.topLabel =[[UILabel alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40)];
   self.topLabel.userInteractionEnabled=YES;
   self.topLabel.alpha=0.3;
   self.topLabel.backgroundColor=[UIColor greenColor];
   self.topLabel.text=@"全部动态";
   self.topLabel.textColor=[UIColor orangeColor];
   self.topLabel.textAlignment=NSTextAlignmentCenter;
   [self.imageView addSubview:self.topLabel];
}
/**
 *创建QQ空间底部的bottomLabel
 */
-(void)createBottomLabel
{
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 518, 320, 49)];
    label.userInteractionEnabled=YES;
    [self.bottomLabel addSubview:label];

    
    self.bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 518, 320, 49)];
    self.bottomLabel.backgroundColor=[UIColor cyanColor];
    self.bottomLabel.userInteractionEnabled=YES;
    self.bottomLabel.alpha=0.5;
    [self.view addSubview:self.bottomLabel];
    
}
/**
 *创建QQ空间的背景图片
 */
-(void)createBgImage
{
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 165)];
    self.imageView.userInteractionEnabled=YES;
    self.imageView.image=[UIImage imageNamed:@"love.jpg"];
    [self.view addSubview:self.imageView];
    
    /**
     *创建背景图上的用户圆形头像
     *
     *注意：宽高必须相等，指定圆角半径为宽或者高的一半，指定属性masksToBounds为yes
     */
    UIImageView* qqImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 100, 60, 60)];
    qqImageView.image=[UIImage imageNamed:@"girl.jpg"];
    qqImageView.layer.cornerRadius=30;
    qqImageView.layer.masksToBounds=YES;
    [self.view addSubview:qqImageView];
    
    
    /**
     *创建背景图上的圆形头像下面的底部衬托
     */
    UIImageView* Image=[[UIImageView alloc]initWithFrame:CGRectMake(26, 135, 68, 40)];
    Image.image=[UIImage imageNamed:@"yellowdiamond_riband@2x"];
    [self.view addSubview:Image];
}
/**
 *创建scrollView作为其他所有控件的父视图
 */
//-(void)createScrollView
//{
//    self.bgScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1000)];
//    //self.bgScroll.backgroundColor=[UIColor lightGrayColor];
//    [self.view addSubview:self.bgScroll];
//    self.bgScroll.showsVerticalScrollIndicator=YES;
//    self.bgScroll.contentSize=CGSizeMake(0, 1000);
//    self.bgScroll.contentOffset=CGPointMake(0, 100);
//}
/**
 *创建topLabel左边的按钮
 */
-(void)createLfetBtn
{
    self.leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 22)];
    [self.leftBtn setImage:[UIImage imageNamed:@"back_iphone5"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.leftBtn];
    
    self.rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(275, 10, 24, 18)];
    [self.rightBtn setImage:[UIImage imageNamed:@"big_diamond_stone@2x"] forState:UIControlStateNormal];
    [self.imageView addSubview:self.rightBtn];
}
#pragma mark - 显示好友动态内容的两个View
//-(void)createFirstView
//{
//    self.firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 589, 320, 160)];
//    self.firstView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:self.firstView];
//}
-(void)createFirstContentInView
{
    /**
     *好友头像imageView
     */
    UIImageView* avaterImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    avaterImage.image=[UIImage imageNamed:@"123.png"];
    avaterImage.layer.cornerRadius=20;
    avaterImage.layer.masksToBounds=YES;
    [self.firstView addSubview:avaterImage];
    
    /**
     *好友昵称label
     */
    UILabel* nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 10, 100, 20)];
    nameLabel.text=@"学姐是处女座的";
    nameLabel.font=[UIFont systemFontOfSize:14];
    [self.firstView addSubview:nameLabel];
    
    /**
     *好友发送空间消息时间label
     */
    UILabel* timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 30, 60, 20)];
    timeLabel.text=@"刚刚";
    timeLabel.textColor=[UIColor lightGrayColor];
    timeLabel.font=[UIFont systemFontOfSize:11];
    [self.firstView addSubview:timeLabel];
    
    /**
     *好友发送空间内容label
     */
    UILabel* contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 40)];
    contentLabel.numberOfLines=0;
    //contentLabel.backgroundColor=[UIColor greenColor];
    contentLabel.font=[UIFont systemFontOfSize:14];
    contentLabel.text=@"你们这些人要知道，学习是暂时的，学姐才是永\n远的,女汉纸学姐才是你们的依赖,萌萌哒~";
    [self.firstView addSubview:contentLabel];
    
    /**
     *好友点赞按钮
     */
    self.appreciateBtn =[[UIButton alloc]initWithFrame:CGRectMake(10, 105, 25, 25)];
    [_appreciateBtn setImage:[UIImage imageNamed:@"feed_icon_praise_click@2x"] forState:UIControlStateNormal];
    [_appreciateBtn addTarget:self action:@selector(appreciate) forControlEvents:UIControlEventTouchUpInside];
    [self.firstView addSubview:_appreciateBtn];
    
    /**
     *好友评论按钮
     */
    UIButton* commentBtn=[[UIButton alloc]initWithFrame:CGRectMake(270, 105, 30, 30)];
    [commentBtn setImage:[UIImage imageNamed:@"tabbar_btn_popup_talk@2x"] forState:UIControlStateNormal];
    [self.firstView addSubview:commentBtn];

    /**
     *好友评论内容显示label
     */
    UILabel* resultLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 135, 320, 15)];
    resultLabel.text=@"吴彦祖:整天就知道卖萌装可爱,啥时候能正常点？？";
    resultLabel.font=[UIFont systemFontOfSize:12];
    [self.firstView addSubview:resultLabel];
}
//好友点赞响应方法
-(void)appreciate
{
    if (self.isAppreciate) {
        [self.appreciateBtn setImage:[UIImage imageNamed:@"toolbar_icon_praise_clicked@2x"] forState:UIControlStateNormal];
        [self createAppreciateImage];
        self.avaterImage.hidden=NO;
        self.isAppreciate=NO;
    }
    else
    {
        [_appreciateBtn setImage:[UIImage imageNamed:@"feed_icon_praise_click@2x"] forState:UIControlStateNormal];
        self.avaterImage.hidden=YES;
        self.isAppreciate=YES;
    }
}
-(void)secondAppreciate
{
    if (self.isAppreciate) {
        [self.secondAppreciateBtn setImage:[UIImage imageNamed:@"toolbar_icon_praise_clicked@2x"] forState:UIControlStateNormal];
          self.isAppreciate=NO;
    }
    else
    {
        [self.secondAppreciateBtn setImage:[UIImage imageNamed:@"feed_icon_praise_click@2x"] forState:UIControlStateNormal];
        self.isAppreciate=YES;
    }

}
-(void)createAppreciateImage
{
    self.avaterImage=[[UIImageView alloc]initWithFrame:CGRectMake(45, 105, 25, 25)];
    _avaterImage.image=[UIImage imageNamed:@"234.png"];
    _avaterImage.layer.cornerRadius=12.5;
    _avaterImage.layer.masksToBounds=YES;
    [self.firstView addSubview:_avaterImage];

}
//-(void)createSecondView
//{
//    self.secondView=[[UIView alloc]initWithFrame:CGRectMake(0, 755, 320, 160)];
//    self.secondView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:self.secondView];
//}
-(void)createSecondContentInView
{
    /**
     *好友头像imageView
     */
    UIImageView* avaterImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    avaterImage.image=[UIImage imageNamed:@"girl.jpg"];
    avaterImage.layer.cornerRadius=20;
    avaterImage.layer.masksToBounds=YES;
    [self.secondView addSubview:avaterImage];
    
    /**
     *好友昵称label
     */
    UILabel* nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 10, 100, 20)];
    nameLabel.text=@"魔术";
    nameLabel.font=[UIFont systemFontOfSize:14];
    [self.secondView addSubview:nameLabel];
    
    /**
     *好友发送空间消息时间label
     */
    UILabel* timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 30, 60, 20)];
    timeLabel.text=@"一个小时前";
    timeLabel.textColor=[UIColor lightGrayColor];
    timeLabel.font=[UIFont systemFontOfSize:11];
    [self.secondView addSubview:timeLabel];
    
    /**
     *好友发送空间内容label
     */
    UILabel* contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 40)];
    contentLabel.numberOfLines=0;
    //contentLabel.backgroundColor=[UIColor greenColor];
    contentLabel.font=[UIFont systemFontOfSize:14];
    contentLabel.text=@"愿得一心人，免得老相亲";
    [self.secondView addSubview:contentLabel];
    
    /**
     *好友点赞按钮
     */
    self.secondAppreciateBtn =[[UIButton alloc]initWithFrame:CGRectMake(10, 105, 25, 25)];
    [self.secondAppreciateBtn  setImage:[UIImage imageNamed:@"feed_icon_praise_click@2x"] forState:UIControlStateNormal];
   [self.secondAppreciateBtn  addTarget:self action:@selector(secondAppreciate) forControlEvents:UIControlEventTouchUpInside];
    [self.secondView addSubview:self.secondAppreciateBtn];
    
    /**
     *好友评论按钮
     */
    UIButton* commentBtn=[[UIButton alloc]initWithFrame:CGRectMake(270, 105, 30, 30)];
    [commentBtn setImage:[UIImage imageNamed:@"tabbar_btn_popup_talk@2x"] forState:UIControlStateNormal];
    [self.secondView addSubview:commentBtn];
}

#pragma mark - 顶部左边的按钮点击响应方法
-(void)leftBtnClick
{
    //将左边self.leftView的是否显示属性设为YES
    self.isShow=YES;
    
    self.coverBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20,  self.view.bounds.size.width, self.view.bounds.size.height-20)];
    self.coverBtn.backgroundColor=[UIColor cyanColor];
    self.coverBtn.alpha=0.4;
    [self.view addSubview:self.coverBtn];
    
    //当点击topLabel左边的按钮时，需要创建self.leftView
    [self createLeftViewsub];
    
    [self.coverBtn addTarget:self action:@selector(removeCoverBtn) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 创建左视图的方法
-(void)createLeftViewsub
{
    self.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 20,self.view.bounds.size.width-80, self.view.frame.size.height)];
    [self.view addSubview:self.leftView];
    self.leftView.alpha=1.0;
    /**
     *创建左边视图的上半部分
     */
    [self createLeftTopview];
    [self createLeftbpttomView];
}
/**
 *创建左边视图的下半部分
 */
-(void)createLeftbpttomView
{
#warning 这里的按钮可能需要自定义，因为图片和文字之间有间隔，二系统自带的按钮无法做到这一点，今后完善(这样重复的代码需要封装)
    UIButton* topicBtn=[[UIButton alloc]initWithFrame:CGRectMake(35, 205, 140, 42)];
    [topicBtn setImage:[UIImage imageNamed:@"ugc_icon_qq_click@2x"] forState:UIControlStateNormal];
    topicBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    //topicBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    //topicBtn.backgroundColor=[UIColor greenColor];
    [topicBtn setTitle:@"话题圈" forState:UIControlStateNormal];
    [self.leftBgimageView addSubview:topicBtn];
    
    UIButton* huaBtn=[[UIButton alloc]initWithFrame:CGRectMake(35, 260, 140, 42)];
    [huaBtn setImage:[UIImage imageNamed:@"ugc_icon_qq_click@2x"] forState:UIControlStateNormal];
    [huaBtn setTitle:@"小画报" forState:UIControlStateNormal];
    huaBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    //huaBtn.backgroundColor=[UIColor greenColor];
    [self.leftBgimageView addSubview:huaBtn];
    
    UIButton* newsBtn=[[UIButton alloc]initWithFrame:CGRectMake(35, 315, 140, 42)];
    [newsBtn setImage:[UIImage imageNamed:@"toolbar_icon_favorites_clicked@2x"] forState:UIControlStateNormal];
    [newsBtn setTitle:@"大头条" forState:UIControlStateNormal];
    newsBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    //newsBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    //newsBtn.backgroundColor=[UIColor greenColor];
    [self.leftBgimageView addSubview:newsBtn];
    
    UIButton* mimiBtn=[[UIButton alloc]initWithFrame:CGRectMake(35, 370, 140, 42)];
    [mimiBtn setImage:[UIImage imageNamed:@"ugc_icon_qq_click@2x"] forState:UIControlStateNormal];
    [mimiBtn setTitle:@"小秘密" forState:UIControlStateNormal];
    mimiBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    //mimiBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    //mimiBtn.backgroundColor=[UIColor greenColor];
    [self.leftBgimageView addSubview:mimiBtn];
    
    UIButton* renBtn=[[UIButton alloc]initWithFrame:CGRectMake(35, 425, 140, 42)];
    [renBtn setImage:[UIImage imageNamed:@"ugc_icon_qq_click@2x"] forState:UIControlStateNormal];
    [renBtn setTitle:@"大日记" forState:UIControlStateNormal];
    renBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    //renBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0,20);
    //renBtn.backgroundColor=[UIColor greenColor];
    [self.leftBgimageView addSubview:renBtn];
}
/**
 *创建左边视图的上半部分
 */
-(void)createLeftTopview
{
    /**
     *这是在创建self.leftView的背景图片
     */
#warning(这样重复的代码需要封装)
    /**
     *左边视图背景图
     */
    self.leftBgimageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.leftView.frame.size.width, self.view.frame.size.height)];
    self.leftBgimageView.image=[UIImage imageNamed:@"colorful_b@2x"];
    self.leftBgimageView.userInteractionEnabled=YES;
    [self.leftView addSubview:self.leftBgimageView];
    
    /**
     *左边底部衬托背景图（填补透明度过小带来的影响）
     */
    self.leftBottomBgimageView =[[UIImageView alloc]initWithFrame:CGRectMake(0,460 ,230, 100)];
    self.leftBottomBgimageView.image=[UIImage imageNamed:@"mountain@2x"];
    self.leftBottomBgimageView.userInteractionEnabled=YES;
    [self.leftView addSubview:self.leftBottomBgimageView];

    
    
    UISearchBar* search=[[UISearchBar alloc]initWithFrame:CGRectMake(10, 20, 200, 40)];
    UIImage* image=[UIImage imageNamed:@"search@2x"];
    int leftCap = image.size.width * 0.5;
    int topCap = image.size.height * 0.5;
    UIImage* stretchImage= [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
    [search setBackgroundColor:[UIColor colorWithPatternImage:stretchImage]];
    search.layer.masksToBounds=YES;
    search.layer.cornerRadius=10;
    search.placeholder=@"搜索好友/动态";
    [self.leftBgimageView addSubview:search];
    
    
    UIImageView* specialImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 25, 25)];
    specialImage.image=[UIImage imageNamed:@"care@2x"];
    [self.leftBgimageView addSubview:specialImage];
    UILabel* specialLabel=[[UILabel alloc]initWithFrame:CGRectMake(18, 130, 60, 20)];
    specialLabel.text=@"特别关心";
    specialLabel.font=[UIFont systemFontOfSize:10];
    [self.leftBgimageView addSubview:specialLabel];
    
    UIImageView* dayImage=[[UIImageView alloc]initWithFrame:CGRectMake(97, 100, 25, 25)];
    dayImage.image=[UIImage imageNamed:@"day@2x"];
    [self.leftBgimageView addSubview:dayImage];
    UILabel* dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(93, 130, 60, 20)];
    dayLabel.text=@"那年今日";
    dayLabel.font=[UIFont systemFontOfSize:10];
    [self.leftBgimageView addSubview:dayLabel];
    
    
    UIImageView* friendImage=[[UIImageView alloc]initWithFrame:CGRectMake(170, 100, 25, 25)];
    friendImage.image=[UIImage imageNamed:@"humen@2x"];
    [self.leftBgimageView addSubview:friendImage];
    UILabel* friendLabel=[[UILabel alloc]initWithFrame:CGRectMake(165, 130, 60, 20)];
    friendLabel.text=@"最近联系";
    friendLabel.font=[UIFont systemFontOfSize:10];
    [self.leftBgimageView addSubview:friendLabel];
    
    UIImageView* lineImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 175, 186, 1)];
    lineImage.image=[UIImage imageNamed:@"line@2x"];
    [self.leftBgimageView addSubview:lineImage];
    
#warning 这里图片老是被拉伸，调整不过来，先放这里(这样重复的代码需要封装)
    //    UIImageView* bottomImage=[[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 150, 70)];
    //    imageView.image=[UIImage imageNamed:@"mountain@2x"];
    //    [self.leftView addSubview:bottomImage];
}
#pragma mark - 移除遮盖的方法
-(void)removeCoverBtn
{
    if (self.isShow)
    {
        self.leftView.hidden=YES;
        self.coverBtn.hidden=YES;
        self.isShow=NO;
    }
    else{
        self.leftView.hidden=NO;
        self.coverBtn.hidden=NO;
        self.isShow=YES;
    }
}
#pragma mark - 处理键盘退下的方法之一
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.leftView endEditing:YES];
}
#pragma mark - 定时器方法
/**
 *定时器响应方法
 */
-(void)timerAction:(NSTimer*)timer
{
    NSLog(@"QQ空间控制器正在调用定时器方法");
    self.i++;
    self.topLabel.alpha=0.3;
    self.topLabel.text=@"获取数据中...";
    for (int j=0; j<5; j++) {
        NSLog(@"正在刷新中");
    }
    if (self.i==5) {
        [timer invalidate];
        timer=nil;
        self.topLabel.alpha=0.4;
        self.topLabel.text=@"全部动态";
        [self.actIndView stopAnimating];
        [self dropAnimation];
        [self backToOriginalFrame];
    }
}
#pragma mark - 刷新完后消息提示动画
-(void)dropAnimation
{
    /**
     *消息背景控件label
     */
    self.loveLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.loveLabel.backgroundColor=[UIColor orangeColor];
    self.loveLabel.text=@"哇哦，共获取到两条好友的动态哦^_^";
    self.loveLabel.textAlignment=1;
    self.loveLabel.font=[UIFont systemFontOfSize:15];
    [self.imageView insertSubview:self.loveLabel belowSubview:self.topLabel];
    /**
     *UIView成功显示动画
     */
    [UIView animateWithDuration:2 animations:^{
        self.loveLabel.frame=CGRectMake(0, 40, self.view.bounds.size.width, 40);
    } completion:^(BOOL finished)
     {
         //[self performSelector:@selector(labelHidden) withObject:nil afterDelay:2];
         [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
#warning 在这里不能用self.loveLabel.transform=CGAffineTransformIdentity;，否则只能回到动画开始的位置
             //self.loveLabel.transform=CGAffineTransformIdentity;
#warning 在这里要想使用self.loveLabel.transform=CGAffineTransformIdentity，需要取得self.loveLabel的y值
             self.loveLabel.frame=CGRectMake(0, 0, self.view.bounds.size.width, 40);
         } completion:^(BOOL finished) {
             [self.loveLabel removeFromSuperview];
         }];
         
     }];
}
//-(void)labelHidden
//{
//    self.loveLabel.transform=CGAffineTransformIdentity;
//    self.loveLabel.hidden=YES;
//}
-(void)backToOriginalFrame
{
    NSLog(@"刷新完成调用了backToOriginalFrame方法");
    [UIView animateWithDuration:1 animations:^{
        self.firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 589, 320, 160)];
        self.firstView.backgroundColor=[UIColor whiteColor];
        
        
        self.secondView=[[UIView alloc]initWithFrame:CGRectMake(0, 755, 320, 160)];
        self.secondView.backgroundColor=[UIColor whiteColor];
       
    } completion:^(BOOL finished) {
        self.firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 189, 320, 160)];
        self.firstView.backgroundColor=[UIColor whiteColor];
        [self createFirstContentInView];
        [self.view addSubview:self.firstView];
        
        self.secondView=[[UIView alloc]initWithFrame:CGRectMake(0, 355, 320, 160)];
        self.secondView.backgroundColor=[UIColor whiteColor];
        [self createSecondContentInView];
         [self.view addSubview:self.secondView];
    }];
}
#pragma mark - QQ空间刷新时刷新（菊花）控件
/**
 *添加蒙版时注册时等候界面(菊花界面)
 */
-(void)createActivityIndicatorView
{
    self.actIndView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.actIndView.frame=CGRectMake(145,60,40,40);
    [self.view addSubview:self.actIndView];
    [self.actIndView startAnimating];
}
#pragma mark - 创建中心按钮的方法
-(void)createCenterBtn
{
    self.circleBtn=[[UIButton alloc]initWithFrame:CGRectMake(140, 5 , 39, 39)];
    [self.circleBtn setImage:[UIImage imageNamed:@"enterbar_btn_add@2x"] forState:UIControlStateNormal];
    [self.circleBtn setImage:[UIImage imageNamed:@"enterbar_btn_add_click@2x"] forState:UIControlStateSelected];
    [self.circleBtn addTarget:self action:@selector(circleClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomLabel addSubview:self.circleBtn];
}
-(void)circleClick
{
    NSLog(@"用户点击了中心按钮，进入模态窗口");
#warning 未完成，在这里继续
    qqCenterViewController* centerVc=[[qqCenterViewController alloc]init];
    [self presentViewController:centerVc animated:YES completion:^{
        NSLog(@"模态动画完成");
    }];
}
@end
