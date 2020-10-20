//
//  ViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "ViewController.h"
#import "Const.h"
#import "DFTextImageLineItem.h"
#import "DFTextVideoLineItem.h"

#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"

#import "UserTimelineViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //NSLog(@"screen width:%f,screen height:%f",SCREEN_WIDTH,SCREEN_HEIGHT);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"朋友圈";
    
    [self initData];
    
    [self setHeader];
    
}

-(void) setHeader
{
    NSString *coverUrl = [NSString stringWithFormat:@"http://file-cdn.datafans.net/temp/12.jpg_%dx%d.jpeg", (int)self.coverWidth, (int)self.coverHeight];
    [self setCover:coverUrl];
    
    //NSString *avatarUrl = [NSString stringWithFormat:@"http://file-cdn.datafans.net/avatar/1.jpeg_%dx%d.jpeg", (int)self.userAvatarSize, (int)self.userAvatarSize];
    NSString *avatarUrl=@"http://pic.chinaxinge.com/xinge/PHOTO/upload/shopimg/big/20090308193042.jpg";
    [self setUserAvatar:avatarUrl];
    
    [self setUserNick:@"汤臣"];
    
    [self setUserSign:@"灵魂若变卖了 上链也没心跳"];
    
}


-(void) initData
{
    DFTextVideoLineItem *textVedioItem=[[DFTextVideoLineItem alloc]init];
    textVedioItem.itemId=2222;
    textVedioItem.itemType=LineItemTypeTextVideo;
    textVedioItem.userId=66666;
    textVedioItem.userAvatar = @"http://pic.chinaxinge.com/xinge/PHOTO/upload/shopimg/big/20090308193042.jpg";
    textVedioItem.userNick = @"汤臣";
    textVedioItem.title = @"";
    textVedioItem.text = @"!!!!";
    textVedioItem.videoUrl=@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    textVedioItem.ts = [[NSDate date] timeIntervalSince1970]*1000;
    textVedioItem.location = @"广州 • 大学城";
    [self addItem:textVedioItem];
    
    
    DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
    textImageItem.itemId = 1;
    textImageItem.itemType = LineItemTypeTextImage;
    textImageItem.userId = 10086;
    textImageItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    textImageItem.userNick = @"奥巴马";
    textImageItem.title = @"";
    textImageItem.text = @"突袭ISIS";
    
    NSMutableArray *srcImages = [NSMutableArray array];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/11.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/12.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/13.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/14.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/15.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/16.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/17.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/18.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/19.jpg"];
    
    
    
    textImageItem.srcImages = srcImages;
    
    
    NSMutableArray *thumbImages = [NSMutableArray array];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/11.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/12.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/13.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/14.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/15.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/16.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/17.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/18.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/19.jpg_160x160.jpeg"];
    textImageItem.thumbImages = thumbImages;
    
    textImageItem.location = @"ISIS总部";
    textImageItem.ts = [[NSDate date] timeIntervalSince1970]*1000;
    
    
    DFLineLikeItem *likeItem1_1 = [[DFLineLikeItem alloc] init];
    likeItem1_1.userId = 10086;
    likeItem1_1.userNick = @"Allen";
    [textImageItem.likes addObject:likeItem1_1];
    
    
    DFLineLikeItem *likeItem1_2 = [[DFLineLikeItem alloc] init];
    likeItem1_2.userId = 10088;
    likeItem1_2.userNick = @"奥巴马";
    [textImageItem.likes addObject:likeItem1_2];
    
    
    
    DFLineCommentItem *commentItem1_1 = [[DFLineCommentItem alloc] init];
    commentItem1_1.commentId = 10001;
    commentItem1_1.userId = 10086;
    commentItem1_1.userNick = @"习大大";
    commentItem1_1.text = @"精彩 大家鼓掌";
    [textImageItem.comments addObject:commentItem1_1];
    
    
    DFLineCommentItem *commentItem1_2 = [[DFLineCommentItem alloc] init];
    commentItem1_2.commentId = 10002;
    commentItem1_2.userId = 10088;
    commentItem1_2.userNick = @"奥巴马";
    commentItem1_2.text = @"欢迎来到美利坚";
    commentItem1_2.replyUserId = 10086;
    commentItem1_2.replyUserNick = @"习大大";
    [textImageItem.comments addObject:commentItem1_2];
    
    
    DFLineCommentItem *commentItem1_3 = [[DFLineCommentItem alloc] init];
    commentItem1_3.commentId = 10003;
    commentItem1_3.userId = 10010;
    commentItem1_3.userNick = @"神雕侠侣";
    commentItem1_3.text = @"呵呵";
    [textImageItem.comments addObject:commentItem1_3];
    
    [self addItem:textImageItem];
    
    
    DFTextImageLineItem *textImageItem2 = [[DFTextImageLineItem alloc] init];
    textImageItem2.itemId = 2;
    textImageItem2.itemType = LineItemTypeTextImage;
    textImageItem2.userId = 10088;
    textImageItem2.userAvatar = @"http://file-cdn.datafans.net/avatar/2.jpg";
    textImageItem2.userNick = @"奥巴马";
    textImageItem2.title = @"发表了";
    textImageItem2.text = @"京东JD.COM-专业的综合网上购物商城，销售超数万品牌、4020万种商品，http://jd.com 囊括家电、手机、电脑、服装、图书、母婴、个护、食品、旅游等13大品类。秉承客户为先的理念，京东所售商品为正品行货、全国联保、机打发票。@刘强东";
    
    NSMutableArray *srcImages2 = [NSMutableArray array];
    [srcImages2 addObject:@"http://file-cdn.datafans.net/temp/20.jpg"];
    [srcImages2 addObject:@"http://file-cdn.datafans.net/temp/21.jpg"];
    [srcImages2 addObject:@"http://file-cdn.datafans.net/temp/22.jpg"];
    [srcImages2 addObject:@"http://file-cdn.datafans.net/temp/23.jpg"];
    textImageItem2.srcImages = srcImages2;
    
    
    NSMutableArray *thumbImages2 = [NSMutableArray array];
    [thumbImages2 addObject:@"http://file-cdn.datafans.net/temp/20.jpg_160x160.jpeg"];
    [thumbImages2 addObject:@"http://file-cdn.datafans.net/temp/21.jpg_160x160.jpeg"];
    [thumbImages2 addObject:@"http://file-cdn.datafans.net/temp/22.jpg_160x160.jpeg"];
    [thumbImages2 addObject:@"http://file-cdn.datafans.net/temp/23.jpg_160x160.jpeg"];
    textImageItem2.thumbImages = thumbImages2;
    
    DFLineLikeItem *likeItem2_1 = [[DFLineLikeItem alloc] init];
    likeItem2_1.userId = 10086;
    likeItem2_1.userNick = @"Allen";
    [textImageItem2.likes addObject:likeItem2_1];
    
    
    DFLineCommentItem *commentItem2_1 = [[DFLineCommentItem alloc] init];
    commentItem2_1.commentId = 18789;
    commentItem2_1.userId = 10088;
    commentItem2_1.userNick = @"奥巴马";
    commentItem2_1.text = @"欢迎来到美利坚";
    commentItem2_1.replyUserId = 10086;
    commentItem2_1.replyUserNick = @"习大大";
    [textImageItem2.comments addObject:commentItem2_1];
    
    DFLineCommentItem *commentItem2_2 = [[DFLineCommentItem alloc] init];
    commentItem2_2.commentId = 234657;
    commentItem2_2.userId = 10010;
    commentItem2_2.userNick = @"神雕侠侣";
    commentItem2_2.text = @"大家好";
    [textImageItem2.comments addObject:commentItem2_2];
    
    
    [self addItem:textImageItem2];
    
    
    
    
    DFTextImageLineItem *textImageItem3 = [[DFTextImageLineItem alloc] init];
    textImageItem3.itemId = 3;
    textImageItem3.itemType = LineItemTypeTextImage;
    textImageItem3.userId = 10088;
    textImageItem3.userAvatar = @"http://file-cdn.datafans.net/avatar/2.jpg";
    textImageItem3.userNick = @"奥巴马";
    textImageItem3.title = @"发表了";
    textImageItem3.text = @"京东JD.COM-专业的综合网上购物商城";
    
    NSMutableArray *srcImages3 = [NSMutableArray array];
    [srcImages3 addObject:@"http://file-cdn.datafans.net/temp/21.jpg"];
    textImageItem3.srcImages = srcImages3;
    
    
    NSMutableArray *thumbImages3 = [NSMutableArray array];
    [thumbImages3 addObject:@"http://file-cdn.datafans.net/temp/21.jpg_640x420.jpeg"];
    textImageItem3.thumbImages = thumbImages3;
    
    
    textImageItem3.width = 640;
    textImageItem3.height = 360;
    
    textImageItem3.location = @"广州信息港";
    
    DFLineCommentItem *commentItem3_1 = [[DFLineCommentItem alloc] init];
    commentItem3_1.commentId = 78718789;
    commentItem3_1.userId = 10010;
    commentItem3_1.userNick = @"狄仁杰";
    commentItem3_1.text = @"神探是我";
    [textImageItem3.comments addObject:commentItem3_1];

    
    
    
    [self addItem:textImageItem3];
    
    
}



-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId
{
        DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
        commentItem.commentId = [[NSDate date] timeIntervalSince1970];
        commentItem.userId = 10098;
        commentItem.userNick = @"金三胖";
        commentItem.text = text;
        [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
    
}


-(void)onLike:(long long)itemId
{
    //点赞
    NSLog(@"onLike: %lld", itemId);
    
    DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
    likeItem.userId = 10092;
    likeItem.userNick = @"琅琊榜";
    [self addLikeItem:likeItem itemId:itemId];
    
}


-(void)onClickUser:(NSUInteger)userId
{
    //点击左边头像 或者 点击评论和赞的用户昵称
    NSLog(@"onClickUser: %ld", userId);
    
    UserTimelineViewController *controller = [[UserTimelineViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)onClickHeaderUserAvatar
{
    [self onClickUser:1111];
}






-(void) refresh
{
    //下来刷新
    //模拟网络请求
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self endRefresh];
    });
}



-(void) loadMore
{
    //加载更多
    //模拟网络请求
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
        textImageItem.itemId = 3;
        textImageItem.itemType = LineItemTypeTextImage;
        textImageItem.userId = 10018;
        textImageItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
        textImageItem.userNick = @"富二代";
        textImageItem.title = @"发表了";
        textImageItem.text = @"你才是富二代";
        
        
        NSMutableArray *srcImages3 = [NSMutableArray array];
        [srcImages3 addObject:@"http://file-cdn.datafans.net/temp/11.jpg"];
        textImageItem.srcImages = srcImages3;
        
        
        NSMutableArray *thumbImages3 = [NSMutableArray array];
        [thumbImages3 addObject:@"http://file-cdn.datafans.net/temp/11.jpg_640x420.jpeg"];
        textImageItem.thumbImages = thumbImages3;
        
        
        textImageItem.width = 640;
        textImageItem.height = 360;

        
        
        
        textImageItem.location = @"广州信息港";
        [self addItem:textImageItem];
        
        [self endLoadMore];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
