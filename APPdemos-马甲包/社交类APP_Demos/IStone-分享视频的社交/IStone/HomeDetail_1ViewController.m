//
//  HomeDetail_1ViewController.m
//  IStone
//
//  Created by 胡传业 on 14-7-23.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import "HomeDetail_1ViewController.h"

#import "CommentCell.h"

@interface HomeDetail_1ViewController ()

@end

@implementation HomeDetail_1ViewController

@synthesize headerView = _headerView;
@synthesize webView = _webView;
@synthesize tableView = _tableView;

-(id) init {
    
    if (self = [super init]) {
        
        // 滚动视图
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
//        _scrollView.backgroundColor = [UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1.0];
//        _scrollView.contentSize = CGSizeMake(320, 900);
//        [self.view addSubview:_scrollView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 330, 640) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view  addSubview:_tableView];
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 375)];
        self.headerView = self.tableView.tableHeaderView;
        
        // 播放视频视图
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, 320, 280)];

        [_headerView addSubview:_webView];
        
        // 用户头像
        UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 30, 30)];
        self.iconView = userImage;
        
        self.iconView.image = [UIImage imageNamed:@"user"];
        
        [_headerView addSubview:userImage];
        
        // 圆形用户图像
        [userImage.layer setCornerRadius:CGRectGetHeight([userImage bounds]) / 2];
        userImage.layer.masksToBounds = YES;
        
        
        // 用户昵称
        UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, 85, 30)];
        nickName.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        self.nickName = nickName;
        // 字体颜色
//        self.nickName.textColor = [UIColor whiteColor];
        
        // data
        self.nickName.text = @"我是只懒猫";
        
        [_headerView addSubview:nickName];
        
        // 关注
        UIButton *followButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 12, 50, 30)];
        self.followButton = followButton;
        
        UIImage *bgImg1 = [UIImage imageNamed:@"follow"];
        UIImage *bgImg2 = [UIImage imageNamed:@"followed"];
        [followButton setImage:bgImg1 forState:UIControlStateNormal];
        [followButton setImage:bgImg2 forState:UIControlStateSelected];
        
        
//        self.followButton.titleLabel.font = [UIFont systemFontOfSize:13];
//        [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
        
        [self.followButton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
//        [self.followButton setBackgroundColor: [UIColor colorWithRed:57.0/255 green:204.0/255 blue:230.0/255 alpha:1.0f]];
//        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
//        [self.followButton setTitleColor:[UIColor colorWithRed:80.0/255 green:227.0/255 blue:194.0/255 alpha:1.0f] forState:UIControlStateHighlighted];//设置title在button被选中情况下为绿色字体
        
        [_headerView addSubview:followButton];
        
        // 点赞按钮
        UIButton *praiseButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 340, 29, 27)];
        self.praiseButton = praiseButton;
        
        UIImage *image_1 = [UIImage imageNamed:@"RedHeart_better"];
        UIImage *image_2 = [UIImage imageNamed:@"fullRedHeart_better"];
        [praiseButton setImage:image_1 forState:UIControlStateNormal];
        [praiseButton setImage:image_2 forState:UIControlStateSelected];
        [self.praiseButton addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:praiseButton];
        
        // 点赞量
        UILabel *praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 335, 55, 33)];
        self.praiseLabel = praiseLabel;
       
//        self.praiseLabel.textColor = [UIColor whiteColor];
         [_headerView addSubview:praiseLabel];
        
        // data
        self.praiseLabel.text = @"29";
        
        // 转发
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 335, 50, 30)];
        self.shareButton = shareButton;
//        self.shareButton.titleLabel.font = [UIFont systemFontOfSize:13];
//        [self.shareButton setTitle:@"转发" forState:UIControlStateNormal];
        UIImage *Img1 = [UIImage imageNamed:@"share"];
        [shareButton setImage:Img1 forState:UIControlStateNormal];
        
        [self.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        
        [_headerView addSubview:shareButton];
        
        
        // 评论列表
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, 320, 300)];
//        [_scrollView addSubview:tableView];
//        self.tableView = tableView;
        
        
        
        // 创建 视频资源路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"popeye" ofType:@"mp4"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        // 创建 资源请求对象
        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
        
        // 网页视图 加载资源请求
        [_webView loadRequest:request];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
//    
//    self.tableView.tableHeaderView = myView;
//    self.tableView.tableHeaderView.backgroundColor = [UIColor greenColor];
    
    
//    // UIWebView
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 280)];
//    webView.backgroundColor = [UIColor greenColor];
//    
//    [scrollView addSubview:webView];

    
//    // 禁止 scrollView 的滑动
//    webView.scrollView.bounces = NO;
//    [self.view addSubview:webView];
//    self.webView = webView;
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://icat.scuec.edu.cn/MPaper/?cat=3"]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://v.youku.com/v_show/id_XNzQ0MDU1NjMy.html?from=y1.3-tech-index3-232-10183.89992-89990.1-1"]];
   
}

// 关注按钮被点击时，该方法被触发
-(void) tap:(id) sender {
    NSLog(@"tap:");
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
}

// 点赞
-(void) praise:(id) sender {
    NSLog(@"praise:");
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}



// 转发按钮被点击时， 该方法被触发
-(void) share {
    NSLog(@"share");
}

#pragma mark -
#pragma mark UITableViewDelegate and DataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.iconView.image = [UIImage imageNamed:@"user"];
    cell.nameLabel.text = @"嘻哈时代";
    cell.comment.text = @"nice ! 这个视频太酷了~ ~";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
