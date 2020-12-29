//
//  MeViewController.m
//  RabbitWallpaper
//
//  Created by MacBook on 16/5/19.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()

@end

@implementation MeViewController{
    //现实动画
    UIDynamicAnimator * _dynamicAnimator;
    //现实行为
    UIDynamicItemBehavior * _dynamicItemBehavior;
    //重力行为
    UIGravityBehavior * _gravityBehavior;
    //碰撞行为
    UICollisionBehavior * _collisionBehavior;
    
    //手指触摸
    UIImageView *_handImageView;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createDynamic];

    _handImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-163/2, ScreenHeight/2-190/2, 163, 190)];
    _handImageView.image = [UIImage imageNamed:@"hand"];
    [self.view addSubview:_handImageView];
    
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"🙄🙄🙄" message:@"如果Birds满屏了，截屏发我微信有红包!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];

}
-(void)createDynamic
{
    //创建现实动画
    _dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //创建现实行为
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc]init];
    //设置弹力值.数值越大，弹力值越大
    _dynamicItemBehavior.elasticity = 0.5;
    
    //重力行为
    _gravityBehavior = [[UIGravityBehavior alloc]init];
    
    //碰撞行为
    _collisionBehavior = [[UICollisionBehavior alloc]init];
    //开启刚体碰撞
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    //将行为添加到现实动画中
    [_dynamicAnimator addBehavior:_dynamicItemBehavior];
    [_dynamicAnimator addBehavior:_gravityBehavior];
    [_dynamicAnimator addBehavior:_collisionBehavior];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    int x = arc4random() % (int)self.view.frame.size.width;
    int size = arc4random() % 50 + 1;
    _handImageView.hidden=YES;
    NSArray * imageArray = @[@"bird1",@"bird2",@"bird3",@"bird4",@"bird5",@"bird6",@"ice1",@"ice2",@"ice3",@"pig1",@"pig2"];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 100, size, size)];
    imageView.image = [UIImage imageNamed:imageArray[arc4random() % imageArray.count]];
    [self.view addSubview:imageView];
    
    //让imageView遵循行为
    [_dynamicItemBehavior addItem:imageView];
    [_gravityBehavior addItem:imageView];
    [_collisionBehavior addItem:imageView];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
