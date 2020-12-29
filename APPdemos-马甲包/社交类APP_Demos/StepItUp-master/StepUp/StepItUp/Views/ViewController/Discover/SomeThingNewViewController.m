//
//  TestViewController.m
//  WFCoretext
//
//  Created by David on 15/2/7.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "SomeThingNewViewController.h"
#import "UIImageView+WebCache.h"

@interface SomeThingNewViewController () 

@end

@implementation SomeThingNewViewController
NSMutableArray * ymDataArray;

UITabBar *topBar;

- (void)viewDidLoad {
	[super viewDidLoad];
    
    
	self.title = @"DDRichText";

    
	//图片支持网络异步加载
	NSMutableArray *_imageDataSource = [NSMutableArray arrayWithCapacity:0];
	[_imageDataSource addObject:@"https://octodex.github.com/images/privateinvestocat.jpg"];
	[_imageDataSource addObject:@"https://octodex.github.com/images/gracehoppertocat.jpg"];
	[_imageDataSource addObject:@"https://octodex.github.com/images/jetpacktocat.png"];
	[_imageDataSource addObject:@"https://octodex.github.com/images/minertocat.png"];
	[_imageDataSource addObject:@"https://octodex.github.com/images/luchadortocat.png"];
	[_imageDataSource addObject:@"https://octodex.github.com/images/saritocat.png"];
	[_imageDataSource addObject:@"https://octodex.github.com/images/steroidtocat.png"];
	
	NSMutableArray *_replyDataSource = [[NSMutableArray alloc] init];//回复数据来源
	[_replyDataSource addObject:@"@Della:@戴伟来 DDRichText棒棒哒！ @daiweilai： @daiweilai @戴伟来:I am Della，这是一个IOS库[em:01:][em:02:][em:03:]"];
    
    NSMutableArray *_likersDataSource = [[NSMutableArray alloc] init];//点赞人数据源
    [_likersDataSource addObjectsFromArray:[NSArray arrayWithObjects:@"JFT0M",@"JFT0M",@"JFT0M", nil]];
	
	ymDataArray =[[NSMutableArray alloc]init];

    YMTextData *ymData = [[YMTextData alloc] init];
    ymData.showImageArray = _imageDataSource;
    ymData.foldOrNot = YES;
	ymData.showShuoShuo = @"这是DDRichText！！支持富文本并且文本能够收缩和伸展，支持图片，支持图片预览，能够回复，使用非常简单！！，这是一个电话号码13800138000，我是@戴伟来 @daiweilai： @daiweilai @戴伟来:支持自定义表情[em:01:] [em:02:] [em:03:] 这是一个网址https://github.com/daiweilai 也支持自定义位置的富文本点击！";
    ymData.replyDataSource = _replyDataSource;
    ymData.likersDataSource = _likersDataSource;
    ymData.name = @"David";
    ymData.intro = @"2015-2-8";
	ymData.headPicURL = @"https://octodex.github.com/images/mummytocat.gif";
    [ymDataArray addObject:ymData];
    self.delegate = self;
    self.dataSource = self;
}

-(NSString *)senderName{
    return @"David";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfRowsInDDRichText{
	return 5;
}

-(YMTextData *)dataForRowAtIndex:(NSInteger)index{
    return [ymDataArray objectAtIndex:0];
}

-(BOOL)hideReplyButtonForIndex:(NSInteger)index{
	return NO;
}

-(void)didPromulgatorNameOrHeadPicPressedForIndex:(NSInteger)index name:(NSString *)name{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布者回调" message:[NSString stringWithFormat:@"姓名：%@\n index：%ld",name,(long)index] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
}


-(void)didRichTextPressedFromText:(NSString*)text index:(NSInteger)index{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"正文富文本点击回调" message:[NSString stringWithFormat:@"点击的内容：%@\n index：%ld",text,(long)index] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
}

-(void)didRichTextPressedFromText:(NSString *)text index:(NSInteger)index replyIndex:(NSInteger)replyIndex{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评论的富文本点击回调" message:[NSString stringWithFormat:@"点击的内容：%@\n index：%ld \n replyIndex:%ld",text,(long)index,(long)replyIndex] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
}

-(void)hideTopBar{
    
}

-(void)replyForIndex:(NSInteger)index replyText:(NSString*)text{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"回复的回调" message:[NSString stringWithFormat:@"回复的内容：%@\n index：%ld",text,(long)index] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
}

@end
