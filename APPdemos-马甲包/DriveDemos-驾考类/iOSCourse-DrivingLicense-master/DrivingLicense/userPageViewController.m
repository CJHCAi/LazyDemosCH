//
//  userPageViewController.m
//  DrivingLicense
//
//  Created by #incloud on 17/2/11.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "userPageViewController.h"
#import "AdViewController.h"
#import "loginViewController.h"

@interface userPageViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

static NSString *identifierCell = @"identify";

@implementation userPageViewController {
    CGFloat middleUnderViewMaxY;
}
- (UIScrollView *)scrollView {
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_HEIGHT)];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0];
    
    // 隐藏navigationBar底部分割线
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
    
    [self initWithScrollView];
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initWithScrollView {
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_HEIGHT)];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_HEIGHT * 0.25)];
    [tempView addSubview:contentView];
    contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0];
    
    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEM_WIDTH - 60) / 2, 0, 60, 60)];
    userImgView.userInteractionEnabled = YES;
    [contentView addSubview:userImgView];
    userImgView.clipsToBounds = YES;
    userImgView.layer.cornerRadius = userImgView.frame.size.width / 2;
    userImgView.image = [UIImage imageNamed:@"user"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
    [userImgView addGestureRecognizer:tap];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((contentView.frame.size.width - 70) / 2, CGRectGetMaxY(userImgView.frame) + 5, 70, 20)];
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.text = @"未登录";
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:userNameLabel];
    
    UIView *middleViewUnderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame), SCREEM_WIDTH, 40)];
    middleUnderViewMaxY = CGRectGetMaxY(middleViewUnderView.frame);
    middleViewUnderView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    [tempView addSubview:middleViewUnderView];
    
    CGFloat middleViewWidth = SCREEM_WIDTH * 0.8;
    CGFloat middleViewHeight = 50;
    UIView *middleView  = [[UIView alloc] initWithFrame:CGRectMake((SCREEM_WIDTH - middleViewWidth) / 2, CGRectGetMaxY(contentView.frame) - middleViewHeight / 2, middleViewWidth, middleViewHeight)];
    middleView.clipsToBounds = YES;
    middleView.layer.cornerRadius = 3;
    middleView.backgroundColor = [UIColor whiteColor];
    middleView.alpha = 0.9;
    [tempView addSubview:middleView];
    
    UIImageView *diaryImgView = [[UIImageView alloc] initWithFrame:CGRectMake(middleView.frame.size.width * 0.05, (middleView.frame.size.height - middleView.frame.size.width * 0.12) / 2, middleView.frame.size.width * 0.12, middleView.frame.size.width * 0.12)];
    diaryImgView.image = [UIImage imageNamed:@"book"];
    [middleView addSubview:diaryImgView];
    
    UILabel *diaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(diaryImgView.frame) + middleView.frame.size.width * 0.015, diaryImgView.frame.origin.y , 63, diaryImgView.frame.size.height)];
    diaryLabel.textAlignment = NSTextAlignmentLeft;
    diaryLabel.text = @"学车日记";
    diaryLabel.textColor = [UIColor blackColor];
    diaryLabel.font = [UIFont systemFontOfSize:15];
    [middleView addSubview:diaryLabel];
    
    CGFloat interval = middleView.frame.size.width / 2 - (diaryImgView.frame.size.width + diaryLabel.frame.size.width) - diaryImgView.frame.origin.x;
    UIImageView *signInImgView = [[UIImageView alloc] initWithFrame:CGRectMake(middleView.frame.size.width / 2 + interval, (middleView.frame.size.height - middleView.frame.size.width * 0.12) / 2, middleView.frame.size.width * 0.12, middleView.frame.size.width * 0.12)];
    signInImgView.image = [UIImage imageNamed:@"star"];
    [middleView addSubview:signInImgView];
    
    UILabel *signInLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(signInImgView.frame) + middleView.frame.size.width * 0.015, signInImgView.frame.origin.y , 63, signInImgView.frame.size.height)];
    signInLabel.textAlignment = NSTextAlignmentLeft;
    signInLabel.text = @"每日签到";
    signInLabel.textColor = [UIColor blackColor];
    signInLabel.font = [UIFont systemFontOfSize:15];
    [middleView addSubview:signInLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(middleViewUnderView.frame), SCREEM_WIDTH, SCREEM_HEIGHT * 0.4) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [tempView addSubview:self.collectionView];
    
    tempView.frame = CGRectMake(0, 0, SCREEM_WIDTH, CGRectGetMaxY(self.collectionView.frame));
    [self.scrollView addSubview:tempView];
    
    AdViewController *AdView = [[AdViewController alloc] init];
    AdView.view.frame = CGRectMake(0, SCREEM_HEIGHT - self.tabBarController.tabBar.frame.size.height - 115, SCREEM_WIDTH, 50);
    [self.scrollView addSubview:AdView.view];
}

- (void)imageTap {
    loginViewController *login = [[loginViewController alloc] init];
    [self presentViewController:login animated:YES completion:^{
        NSLog(@"啊哈哈哈哈");
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

// item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEM_WIDTH * 0.24,SCREEM_WIDTH * 0.24);
}

//定义每个item 的 margin 边缘
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(30, SCREEM_WIDTH * 0.1, 20, SCREEM_WIDTH * 0.1);//分别为上、左、下、右
}

//每个section中不同的行之间的行间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    cell.backgroundColor =  [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width / 6, 0, cell.frame.size.width / 1.5, cell.frame.size.width / 1.5)];
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    [cell.contentView addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame), cell.frame.size.width, cell.frame.size.height - imgView.frame.size.height)];
    [cell.contentView addSubview:titleLabel];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:12];
    switch (indexPath.row)
    {
        case 0:
            titleLabel.text = @"实时停车场";
            break;
        case 1:
            titleLabel.text = @"违章高发地";
            break;
        case 2:
            titleLabel.text = @"尾号限行";
            break;
        case 3:
            titleLabel.text = @"今日油价";
            break;
        case 4:
            titleLabel.text = @"全国油站油价";
            break;
        case 5:
            titleLabel.text = @"车系查询";
            break;
    }
    
    return cell;
    
    //    此处能看处 虽然都是继承于UIScrollview但是，还是有细微的不同的。
    //    UICollectionViewCell是没有textLabel的等 UILabel的属性的。自定义有更大的灵活性。
    
}

@end
