//
//  HomeViewController.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/11.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "HomeBaseClass.h"
#import "HomeTextView.h"
#import "UIViewExt.h"
#import <SVPullToRefresh.h>
#import "LoginViewController.h"
#import "UserInfoViewController.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HomeBaseClass *home;
@property (nonatomic, strong) NSMutableArray *homeTextViews;
//跳转页面时传值
@property (nonatomic, strong) NSMutableArray *musicPaths;
@property (nonatomic, strong) NSMutableArray *artworkImages;
@property (nonatomic, strong) NSMutableArray *titles;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation HomeViewController
#pragma mark - 生命周期 Life Cilcle

- (void)viewDidLoad {
    [super viewDidLoad];
    //UICollectionView
//    self.headIV.layer.cornerRadius = self.headIV.frame.size.width / 2;
//    self.headIV.layer.masksToBounds = YES;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 94, kScreenW, kScreenH - 94 - kTabBarH) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = kRGBA(243, 243, 243, 1);
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    //注册
    [collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    
    //请求数据
    [Utils requestHomesWithUrlPath:URL_MyChangBaPath andCallback:^(id obj) {
        self.home = obj;
        [self initHomeTextView];
        
        [self.collectionView reloadData];
    }];
    __block HomeViewController *mySelf = self;
    //添加下拉刷新
    [self.collectionView addPullToRefreshWithActionHandler:^{
        NSLog(@"开始刷新");
        [mySelf loadData];
    }];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //刷新头像称昵
    BmobUser *bUser = [BmobUser currentUser];
//    if (bUser) {
//        if ([bUser objectForKey:@"emailVerified"]) {
//            //用户没验证过邮箱
//            if (![[bUser objectForKey:@"emailVerified"] boolValue]) {
//                [BmobUser logout];
//            }
//        }else{
//            [BmobUser logout];
//        }
//    }
//    bUser = [BmobUser currentUser];
    NSString *headPath = [bUser objectForKey:@"headPath"];
    NSString *nick = [bUser objectForKey:@"nick"];
    if (headPath) {
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:headPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.headIV.image = [self circleImage:self.headIV.image withParam:0];
        }];
    }else{
        [self.headIV setImage:[UIImage imageNamed:@"xiaochang_default_avatar"]];
    }
    if (nick) {
        self.nickLabel.text = nick;
    }else if (bUser){
        self.nickLabel.text = @"设置头像称昵";
    }else{
        self.nickLabel.text = @"登录唱吧";
    }
}
#pragma mark - 方法 Methods
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    
    CGContextSetLineWidth(context,2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
    
}

- (IBAction)gotoLoginVC:(id)sender {
    BmobUser *bUser = [BmobUser currentUser];
    if (bUser) {
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}
- (void)loadData{
    //请求数据
    [Utils requestHomesWithUrlPath:URL_MyChangBaPath andCallback:^(id obj) {
        self.home = obj;
        [self initHomeTextView];
        
        [self.collectionView reloadData];
        //结束动画
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}
//初始化文本框计算高度      跳转页面时传值
- (void)initHomeTextView{
    self.homeTextViews = [NSMutableArray array];
    self.musicPaths = [NSMutableArray array];
    self.artworkImages = [NSMutableArray array];
    self.titles = [NSMutableArray array];
    for (HomeResult *result     in self.home.result) {
        //文本框
        HomeTextView *homeTV = [[HomeTextView alloc]initWithFrame:CGRectMake(0, 85, kScreenW - kMargin * 2 - 16, MAXFLOAT)];
        homeTV.text = result.work.title;
        [homeTV sizeToFit];
        [self.homeTextViews addObject:homeTV];
        //跳转页面时传值
        [self.musicPaths addObject:result.work.workpath];
        [self.artworkImages addObject:result.work.song.icon];
        [self.titles addObject:result.work.song.name];
    }
}
- (IBAction)gotoPlayingViewAction:(id)sender {
    PlayingViewController *playingVC = [PlayingViewController sharePlayingVC];
    [self.navigationController pushViewController:playingVC animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.home.result.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];

    HomeResult *result = self.home.result[indexPath.row];
    //在cell内请求图片数据
    cell.result = result;

    cell.nicknameLabel.text = result.work.user.nickname;
    cell.nameLabel.text = result.work.song.name;
    cell.listen_numLabel.text = @(result.work.listen_num).stringValue;
    cell.flower_numLabel.text = @(result.work.flower_num).stringValue;
    cell.forward_numLabel.text = @(result.work.forward_num).stringValue;
    cell.comment_numLabel.text = @(result.work.comment_num).stringValue;
    cell.mvIV.hidden = !result.work.flag.intValue;
    
    HomeTextView *textView = self.homeTextViews[indexPath.row];
//    [cell.contentView addSubview:textView];
    cell.textView.width = kScreenW - kMargin * 2 - 16;
    cell.textView.text = textView.text;
    [cell.textView sizeToFit];
    cell.textView.top = 85;
    cell.textView.left = 8;
    return cell;
}

//控制不同的Item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = kScreenW - kMargin * 2;
    //需要计算高度
    HomeTextView *textView = self.homeTextViews[indexPath.row];
    CGFloat height = 85 + textView.frame.size.height + 2;
    return CGSizeMake(width, height);
}
//设置内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
}
//设置最小的行边距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMargin;
}
//设置最小的列边距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMargin;
}
//某行被点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //某一行被点击时
    PlayingViewController *playingVC = [PlayingViewController sharePlayingVC];
    playingVC.musicPaths = self.musicPaths;
    playingVC.artworkImages = self.artworkImages;
    playingVC.titles = self.titles;
    playingVC.currentIndex = indexPath.row;
    [self.navigationController pushViewController:playingVC animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}


@end
