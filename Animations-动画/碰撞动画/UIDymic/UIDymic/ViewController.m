//
//  ViewController.m
//  UIDymic
//
//  Created by 七啸网络 on 2017/11/7.
//  Copyright © 2017年 CWM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property(nonatomic,strong)UIDynamicAnimator * animator;

@end

@implementation ViewController
-(UIDynamicAnimator *)animator{
    
    if (!_animator) {
        _animator=[[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1.创建碰撞行为
    UIGravityBehavior * Gravity=[[UIGravityBehavior alloc]init];
//    Gravity.magnitude=100;
    [Gravity addItem:self.blueView];

    UICollisionBehavior * Collision=[[UICollisionBehavior alloc]init];
// Collision.translatesReferenceBoundsIntoBoundary=YES;
    [Collision addItem:self.blueView];
    [Collision addItem:self.seg];
    //添加边界
    
//    CGFloat x=self.view.frame.size.width;
//    CGFloat y=self.view.frame.size.height;
//    [Collision addBoundaryWithIdentifier:@"line" fromPoint:CGPointMake(0, y*0.5) toPoint:CGPointMake(x, y)];
//    [Collision addBoundaryWithIdentifier:@"line2" fromPoint:CGPointMake(x, 0) toPoint:CGPointMake(x, y)];

    CGFloat width=self.view.frame.size.width;
    [Collision addBoundaryWithIdentifier:@"circle" forPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)]];
        //2.添加行为
    [self.animator addBehavior:Collision];
    [self.animator addBehavior:Gravity];
}
/**重力行为*/
-(void)testGravity{
    
    //1.创建物理仿真器
    self.animator=[[UIDynamicAnimator alloc]initWithReferenceView:self.blueView];
    //2.创建物理仿真行为
    UIGravityBehavior * GravityBehavior=[[UIGravityBehavior alloc]init];
    [GravityBehavior addItem:self.blueView];
    
    //重力方向
    GravityBehavior.gravityDirection=CGVectorMake(100, 100);
    //重力加速度
    GravityBehavior.magnitude=10;
    //3.添加物理仿真行为到物理仿真器
    [self.animator addBehavior:GravityBehavior];

    
}


@end
