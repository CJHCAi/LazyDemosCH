//
//  YMTableViewCell.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTextData.h"
#import "WFTextView.h"
#import "YMButton.h"


@protocol cellDelegate <NSObject>

- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger) cellStamp;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;
-(void)didPromulgatorNameOrHeadPicPressedForIndex:(NSInteger)index name:(NSString*)name;
-(void)didRichTextPress:(NSString*)text index:(NSInteger)index;
-(void)didRichTextPress:(NSString*)text index:(NSInteger)index replyIndex:(NSInteger)index;

@end

@interface YMTableViewCell : UITableViewCell<WFCoretextDelegate>

@property BOOL hideReply;


//----- 界面------//


/**
 头像
 */
@property (nonatomic,strong) UIImageView * headerImage;

/**
 用户名
 */
@property(nonatomic , strong)UILabel *nameLbl;

/**
 时间戳
 */
@property(nonatomic,strong)UILabel *introLbl;

/**
 展开/收起按钮
 */
@property(nonatomic,strong)UIButton *foldBtn;

/**
 下方评论背景（灰色那个）
 */
@property(nonatomic,strong)UIImageView *replyImageView;

//----- 数据------//

/**
 图片数据
 */
@property (nonatomic,strong) NSMutableArray * imageArray;

/**
 动态内容
 */
@property (nonatomic,strong) NSMutableArray * ymTextArray;

/**
 评论内容
 */
@property (nonatomic,strong) NSMutableArray * ymShuoshuoArray;
@property (nonatomic,assign) id<cellDelegate> delegate;
@property (nonatomic,assign) NSInteger stamp;

/**
 评论按钮
 */
@property (nonatomic,strong) YMButton *replyBtn;

/**
 点赞按钮
 */
@property (nonatomic,strong) YMButton *likeBtn;

- (YMTextData*)getYMTextData;

- (void)setYMViewWith:(YMTextData *)ymData;

@end
