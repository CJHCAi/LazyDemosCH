# DoubanToday
app store Today转场动画，数据展示为豆瓣电影今日热映电影数据。

App Store今日页面转场动画粗糙的模仿了一下。为了让页面看起来不那么单调，数据用了豆瓣电影今日热映的公开接口，城市使用的是当前定位城市，如果没有定位成功，就访问默认数据。



### demo效果

<div align=center><img src="https://github.com/Dtheme/DoubanToday-master/blob/master/gif/animation.gif"/></div>




#### 实现思路分为3个部分：

下面是核心代码：

第一部分：列表页点击cell的缩放效果在列表页didselectRowAtIndexPath中实现

```objective-c
DouTodayFilmCell *cell = [tableView cellForRowAtIndexPath:indexPath];
cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
```



第二部分：push转场动画在 `TodayTransition`的`pushAnimateTransition:`中实现，这里有一个细节，在toView用一个临时图片承接前面图片magic move动画的下半段，在数据接收完成以后隐藏临时图片

```objective-c
- (void)pushAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    DouTodayViewController *fromVC = (DouTodayViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DouTodayFilmCell *cell = (DouTodayFilmCell *)[fromVC.tableView cellForRowAtIndexPath:[fromVC.tableView indexPathForSelectedRow]];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [toVC valueForKeyPath:@"headerImageView"];
    UIView *fromView = cell.bgView;
    UIView *containerView = [transitionContext containerView];
    UIView *snapShotView = [[UIImageView alloc]initWithImage:cell.bgimageView.image];
    snapShotView.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    
    fromView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toView.hidden = YES;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:25.f];
    titleLabel.text = cell.titleLabel.text;
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (SCREEN_WIDTH-40)*1.3-30, SCREEN_WIDTH-44, 15)];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.f];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.alpha = 0.5;
    contentLabel.text =cell.contentLabel.text;
    [snapShotView addSubview:titleLabel];
    [snapShotView addSubview:contentLabel];
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];
    
    [UIView animateWithDuration:0.6f animations:^{
        if (IPHONE_X) {
            [DzwSingleton sharedInstance].tabBarVC.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 83);
        } else {
            [DzwSingleton sharedInstance].tabBarVC.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 49);
        }
            [DzwSingleton sharedInstance].tabBarVC.tabBar.transform = CGAffineTransformMakeScale(1, 1.1);
    }completion:^(BOOL finished) {
        [DzwSingleton sharedInstance].tabBarVC.tabBar.transform = CGAffineTransformMakeScale(1, 1);
    }];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [containerView layoutIfNeeded];
        toVC.view.alpha = 1.0f;
        
       
        snapShotView.frame = [containerView convertRect:toView.frame fromView:toView.superview];
        titleLabel.frame = CGRectMake(22, 30, SCREEN_WIDTH-30, 30);
        contentLabel.frame = CGRectMake(22, SCREEN_WIDTH*1.3-30, SCREEN_WIDTH*1.3-44, 15);
        
    } completion:^(BOOL finished) {
        
        toView.hidden = NO;
        fromView.hidden = NO;
        [snapShotView removeFromSuperview];
//        [fromVC.tableView reloadData];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
```

第三部分：pop转场动画 `TodayTransition`的`popAnimateTransition:`中实现

```objective-c
- (void)popAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    DouTodayViewController *todayVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    DouFilmInfoViewController *infoVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [infoVC valueForKeyPath:@"headerImageView"];
    todayVC.view.frame = [transitionContext finalFrameForViewController:todayVC];
    DouTodayFilmCell *cell = (DouTodayFilmCell *)[todayVC.tableView cellForRowAtIndexPath:infoVC.selectIndexPath];
    
    UIView *originView = cell.bgimageView;
    
    UIView *snapShotView = [fromView snapshotViewAfterScreenUpdates:NO];
    snapShotView.layer.masksToBounds = YES;
    snapShotView.layer.cornerRadius = 15;
    snapShotView.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    
    fromView.hidden = YES;
    originView.hidden = YES;
    
    [containerView insertSubview:todayVC.view belowSubview:infoVC.view];
    [containerView addSubview:snapShotView];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:25.f];
    titleLabel.text = infoVC.titles;
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.f];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.text =infoVC.titleTwo;
    contentLabel.alpha = 0.5;
    titleLabel.frame = CGRectMake(22, 20, SCREEN_WIDTH-30, 30);
    contentLabel.frame = CGRectMake(22, SCREEN_WIDTH*1.3-30, SCREEN_WIDTH*1.3-44, 15);
    [snapShotView addSubview:titleLabel];
    [snapShotView addSubview:contentLabel];
    
    [UIView animateWithDuration:0.6f animations:^{
        if (IPHONE_X) {
            [DzwSingleton sharedInstance].tabBarVC.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-83, SCREEN_WIDTH, 83);
        } else {
            [DzwSingleton sharedInstance].tabBarVC.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
        }
        [DzwSingleton sharedInstance].tabBarVC.tabBar.transform = CGAffineTransformMakeScale(1, 1.05);

    }completion:^(BOOL finished) {
        [DzwSingleton sharedInstance].tabBarVC.tabBar.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [containerView layoutIfNeeded];
        infoVC.view.alpha = 0.0f;
        snapShotView.layer.cornerRadius = 15;
        infoVC.tableView.frame = CGRectMake(infoVC.tableView.frame.origin.x, infoVC.tableView.frame.origin.y, infoVC.tableView.frame.size.width,SCREEN_WIDTH*1.3*0.8);
        infoVC.tableView.layer.cornerRadius = 15;
        snapShotView.frame = [containerView convertRect:originView.frame fromView:originView.superview];
        titleLabel.frame = CGRectMake(15, 20, SCREEN_WIDTH-30, 30);
        contentLabel.frame = CGRectMake(15, (SCREEN_WIDTH-40)*1.3-30, SCREEN_WIDTH-44, 15);
    } completion:^(BOOL finished) {
        fromView.hidden = YES;
        [snapShotView removeFromSuperview];
        originView.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
```
















