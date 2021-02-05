//
//  NMImageView.m
//  XBNetMusic
//
//  Created by 小白 on 15/12/4.
//  Copyright (c) 2015年 小白. All rights reserved.
//

#import "NMImageView.h"
#import "UIView+Extension.h"
@interface NMImageView ()
@property (nonatomic,strong)UIImageView *backgroundView;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIImageView *faceView;//这里不讲username和faceView打包到一个view的原因是因为username会撑大这个整体的view 导致有大量空白，影响用户点击
@property (nonatomic,strong)UIButton *username;
@end


@implementation NMImageView


-(void)setupBackgroundView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, self.width, self.height);
    //这里图片放到了打包里面去了，要按照这个方法去找文件，加载。一般来说，取打包文件的图片是不占用缓存的，使用images.xcassets是要占用的
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"1706442046308354.jpg"];
    imageView.image = [UIImage imageWithContentsOfFile:path];
    self.backgroundView = imageView;
    [self addSubview:imageView];
}


-(void)setupFaceView{
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat w = 50;
    CGFloat h = 50;
    CGFloat x = 10;
    CGFloat y = self.username.y - h ;
    XBlog(@"CGRectGetMaxY(self.username.frame) = %f",CGRectGetMaxY(self.username.frame));
    imageView.frame = CGRectMake(x, y, w, h);
    //设置圆形
    imageView.layer.cornerRadius = 25;
    imageView.layer.masksToBounds = YES;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"cm2_icn_user_who.png"];
    imageView.image= [UIImage imageWithContentsOfFile:path];
    
    
    imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoClick)];
    [imageView addGestureRecognizer:singleTap];

    
    
    [self addSubview:imageView];
    self.faceView = imageView;
}


/*
 设置用户名
 */
-(void)setupUsername{
    UIButton *username = [UIButton buttonWithType:UIButtonTypeCustom];
    [username setTitle:@"小白" forState:UIControlStateNormal];
    [username setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    username.titleLabel.font = [UIFont boldSystemFontOfSize:17];//这里加粗字体
    [username sizeToFit];//这里根据名字自动设置大小
    
    username.x = 15;
    username.y = self.height - 5 - username.height;
    
    [username addTarget:self action:@selector(userInfoClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.username = username;
    [self addSubview:username];
    
}

-(void)userInfoClick{
    XBlog(@"用户信息被点击");
}


/*
 设置签到按钮
 */
-(void)setupBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat w = 55;
    CGFloat h = 22;
    CGFloat x = self.width - w - 10;
    CGFloat y = ImageViewHeigth - h - 15;
    
    btn.frame = CGRectMake(x,y,w,h);
    [btn setTitle:@" 签到" forState:UIControlStateNormal];//设置按钮必须要用这个啊 用.那个好像不好用啊
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_lay_icn_jifen"]];
    [btn setImage:[UIImage imageNamed:@"cm2_lay_icn_jifen"] forState:UIControlStateNormal];
     [btn setImage:nil forState:UIControlStateDisabled];
    
    
    
    //设置边框颜色
    btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    //设置边框宽度
    btn.layer.borderWidth = 1.0f;
    //设置圆角
    btn.layer.cornerRadius = 5.0f;
    //设置子空间不可超出父控件
    btn.layer.masksToBounds = YES;
    
    
    
    [btn addTarget:self action:@selector(checkinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    

    //btn.backgroundColor = [UIColor redColor];
    [self addSubview:btn];
    self.btn = btn;
}

-(void)checkinBtnClick{
    XBlog(@"签到按下了");
    [self.btn setTitle:@"已签到" forState:UIControlStateNormal];
     [self.btn setImage:nil forState:UIControlStateNormal];
    self.btn.enabled = NO;
}





-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupBackgroundView];
        [self setupBtn];

        [self setupUsername];
        [self setupFaceView];
        self.layer.masksToBounds = YES;//这个属性设置后，子视图只能在父视图里面了 不可超出
    }
    return self;
}


@end
