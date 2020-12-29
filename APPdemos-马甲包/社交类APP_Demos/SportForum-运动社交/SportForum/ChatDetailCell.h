//
//  ChatDetailCell.h
//  SportForum
//
//  Created by liyuan on 14-6-24.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DelClickBlock)(void);

@interface ChatDetailItem : NSObject

@property(nonatomic, copy) NSString* userId;
@property(nonatomic, copy) NSString* userImage;
@property(nonatomic, copy) NSString* nickName;
@property(nonatomic, copy) NSString* latestContent;
@property(nonatomic, strong) NSDate* time;
@property(nonatomic, assign) NSInteger unReadCount;
@property(nonatomic, assign)BOOL bSystemMsg;

@end

@interface ChatDetailCell : UITableViewCell

@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UILabel *lbNickName;
@property(nonatomic, strong) UILabel *lbTime;
@property(nonatomic, strong) UILabel *lbLatestContent;
@property(nonatomic, strong) UILabel * lbNum;
@property(nonatomic, strong) UIImageView * imgViewNum;
@property(nonatomic, strong) UIImageView * imgViewArr;
@property(nonatomic, strong) UIImageView *viewChat;

@property(nonatomic, strong) CSButton *btnDel;
@property(nonatomic, strong) UIImageView *userImgDel;
@property(nonatomic, strong) UILabel *lbNickNameDel;
@property(nonatomic, strong) UILabel *lbTimeDel;
@property(nonatomic, strong) UILabel *lbLatestConDel;
@property(nonatomic, strong) UILabel * lbNumDel;
@property(nonatomic, strong) UIImageView * imgViewNumDel;
@property(nonatomic, strong) UIImageView *imgViewDel;
@property(nonatomic, strong) UIView *viewDel;
@property(nonatomic, strong) ChatDetailItem *chatDetailItem;
@property(nonatomic, strong) DelClickBlock delClickBlock;
@property(nonatomic, assign) BOOL bEditMode;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
+(CGFloat)heightOfCell;

@end
