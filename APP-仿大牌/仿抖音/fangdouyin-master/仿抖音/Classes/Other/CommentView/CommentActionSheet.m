//
//  CommentActionSheet.m
//  CommentAlert
//
//  Created by 李立 on 2018/1/8.
//  Copyright © 2018年 李立. All rights reserved.
//
#define Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Screen_Width [[UIScreen mainScreen] bounds].size.width

#import "CommentActionSheet.h"
#import "CHCommentView.h"
static const CGFloat kMoveAnimationDuration = .25f;

@interface CommentActionSheet ()<UITableViewDelegate, UITableViewDataSource,CHCommentViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CGRect originalFrame;     // 当前视图的原始位置
#pragma mark - UITouch 滑动
@property (assign, nonatomic) CGPoint startLocation;    // 记录滑动触摸的起始位置
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)CHCommentView * commentView;
@property(nonatomic,strong)UIView * topView;
@end

@implementation CommentActionSheet


static NSString * cellID=@"commentCell";
static CGFloat topH=300;
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.originalFrame = frame;
        [self prepareUI];
    }
    
    return self;
}

- (instancetype)init
{
    if (self = [super init]){
        [self prepareUI];
    }
    
    return self;
}


- (void)prepareUI{
    
    self.bgView=[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.bgView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.bgView];
    [[[UIApplication sharedApplication]keyWindow] bringSubviewToFront:self.bgView];
   
    [self.bgView addSubview:self];
    
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, topH)];
    [self.bgView addSubview:self.topView];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    [self.topView addGestureRecognizer:tap];

    self.commentView=[[CHCommentView alloc]init];
    _commentView.delegate=self;
    _commentView.frame=CGRectMake(0,Screen_Height, Screen_Width, Screen_Height-topH);
    _commentView.backgroundColor=[UIColor blueColor];
    [self.bgView addSubview:_commentView];
    
    // 创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.commentView.frame.size.width, self.commentView.frame.size.height-20) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.backgroundColor = [UIColor orangeColor];
    [self.commentView addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.bgView.hidden=YES;

}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.tableView.frame =CGRectMake(0, 20, self.commentView.frame.size.width, self.commentView.frame.size.height-20);
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.backgroundColor=[UIColor orangeColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark - 滑动动效
- (void)CommentViewTouchBegin:(NSSet<UITouch *> *)touches{
    // 获取起始位置
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    self.startLocation = location;
    NSLog(@"startLocation:x:%lg, y:%lg", location.x, location.y);
}

- (void)CommentViewTouchMove:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    // 当前触摸点
    CGPoint currentPoint = [touch locationInView:self.superview];
    NSLog(@"currentPoint:x:%lg, y:%lg", currentPoint.x, currentPoint.y);
    // 上一个触摸点
    CGPoint previousPoint = [touch previousLocationInView:self.superview];
    // 当前view的中点
    CGPoint center = self.commentView.center;
    if (currentPoint.y>topH) {
        // 设置y方向的偏移
        CGFloat ofsetY=currentPoint.y - previousPoint.y;
        center.y += ofsetY;
        // 修改当前view的中点(中点改变view的位置就会改变)
        self.commentView.center = center;
    }
}

- (void)CommentViewTouchEnd:(NSSet<UITouch *> *)touches{
    // 获取终点位置
    UITouch *touch = [touches anyObject];
    CGPoint endLocation = [touch locationInView:self.commentView.superview];
    NSLog(@"endLocation:x:%lg, y:%lg", endLocation.x, endLocation.y);
    // 计算frame
    CGRect rect = self.originalFrame;
    rect.origin.y = self.commentView.superview.frame.size.height - self.originalFrame.size.height;
    CGFloat yOffset = endLocation.y - self.startLocation.y;
    if (endLocation.y>topH) {
        if (yOffset > self.commentView.frame.size.height * 1.0f/3.0f){
            // 消失
            [self hidden];
        }else{
            [self show];
        }
    }else{
        [self show];
    }
}


#pragma mark - 各种点击事件
-(void)tapClicked{
    [self hidden];
}
-(void)show{
    self.bgView.hidden=NO;
    [UIView animateWithDuration:kMoveAnimationDuration animations:^{
        self.commentView.frame = CGRectMake(0, topH, Screen_Width, Screen_Height-topH);
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)hidden{
    [UIView animateWithDuration:kMoveAnimationDuration animations:^{
        self.commentView.frame=CGRectMake(0,Screen_Height, Screen_Width, Screen_Height-topH);
    } completion:^(BOOL finished) {
        self.bgView.hidden=YES;
    }];
    
}
@end










