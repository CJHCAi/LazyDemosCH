# How To Use
    //创建lotteryView
    LuckView *luckView = [[LuckView alloc] initWithFrame:CGRectMake(0, (ScreenHeight - ScreenWidth) * 0.5, ScreenWidth,  ScreenWidth)];
    //网络图片
    luckView.imageArray = [@[@"http://st.depositphotos.com/1842549/2870/i/950/depositphotos_28700059-Green-square-shiny-icon.jpg",@"http://st.depositphotos.com/1842549/2869/i/950/depositphotos_28699735-Green-square-shiny-icon.jpg",@"http://st.depositphotos.com/1842549/2870/i/950/depositphotos_28700445-Green-square-shiny-icon.jpg",@"http://st.depositphotos.com/1842549/2870/i/950/depositphotos_28700229-Green-square-shiny-icon.jpg",@"http://www.iconpng.com/png/boxed_metal_icons/gamecenter.png",@"http://www.iconpng.com/png/boxed_metal_icons/line.png",@"http://www.iconpng.com/png/boxed_metal_icons/internet_explorer.png",@"http://www.iconpng.com/png/boxed_metal_icons/gps.png"]mutableCopy];
    //指定抽奖结果,对应数组中的元素
    luckView.stopCount = 5;
    //设置代理
    luckView.delegate = self;
    [self.view addSubview:luckView];
# demonstration
![image](https://github.com/woaichunchunma/Lottery/blob/master/%E6%95%88%E6%9E%9C%E5%9B%BE.gif)
