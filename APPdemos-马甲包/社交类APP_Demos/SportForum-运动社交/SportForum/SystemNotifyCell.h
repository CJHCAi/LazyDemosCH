//
//  SystemNotifyCell.h
//  SportForum
//
//  Created by liyuan on 14-7-2.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    e_notify_coach_comment,
    e_notify_coach_pass_comment,
    e_notify_coach_npass_comment,
    e_notify_comment,
    e_notify_thumb,
    e_notify_subscribe,
    e_notify_reward,
    e_notify_tx,
    e_notify_send_heart,
    e_notify_receive_heart,
    e_notify_runshare,
    e_notify_runshared,
    e_notify_postshare,
    e_notify_postshared,
    e_notify_pkshare,
    e_notify_pkshared,
    e_notify_at,
    e_notify_record,
    e_notify_info,
}e_notify_type;

typedef void (^DelClickBlock)(void);

@interface SystemNotifyItem : NSObject

@property(nonatomic, copy) NSString* strPid;
@property(nonatomic, copy) NSString* strFrom;
@property(nonatomic, copy) NSString* strImage;
@property(nonatomic, copy) NSString* strNikeName;
@property(nonatomic, copy) NSString* strUserId;
@property(nonatomic, copy) NSString* strRecordId;
@property(nonatomic, copy) NSString* strArticleId;
@property(nonatomic, copy) NSString* strLatlng;//数据结构内容:(经度，纬度)
@property(nonatomic, copy) NSString* strLocAddr;
@property(nonatomic, copy) NSString* strMapUrl;//地图截图
@property(nonatomic, strong) NSDate* time;
@property(nonatomic, assign) NSInteger unReadCount;
@property(nonatomic, assign) NSInteger unTotalCount;
@property(nonatomic, assign) e_notify_type eNotifyType;
@property(nonatomic, assign) long long lRunBeginTime;

@end

@interface SystemNotifyCell : UITableViewCell

@property(nonatomic, strong) UIImageView *notifyImageView;
@property(nonatomic, strong) UILabel *lbNotifyName;
@property(nonatomic, strong) UILabel *lbTime;
@property(nonatomic, strong) UILabel *lbTotalNotify;
@property(nonatomic, strong) UILabel * lbNum;
@property(nonatomic, strong) UIImageView * imgViewNum;
@property(nonatomic, strong) UIImageView * articleImgView;
@property(nonatomic, strong) UIImageView * imgViewArr;
@property(nonatomic, strong) UIImageView *viewSystem;

@property(nonatomic, strong) CSButton *btnDel;
@property(nonatomic, strong) UIImageView *notifyImgViewDel;
@property(nonatomic, strong) UILabel *lbNotifyNameDel;
@property(nonatomic, strong) UILabel *lbTimeDel;
@property(nonatomic, strong) UILabel *lbTotalNotifyDel;
@property(nonatomic, strong) UILabel * lbNumDel;
@property(nonatomic, strong) UIImageView * imgViewNumDel;
@property(nonatomic, strong) UIImageView *articleImgViewDel;
@property(nonatomic, strong) UIImageView *imgViewSystemDel;
@property(nonatomic, strong) UIView *viewDel;

@property(nonatomic, strong) SystemNotifyItem *systemNotifyItem;
@property(nonatomic, strong) DelClickBlock delClickBlock;
@property(nonatomic, assign) BOOL bEditMode;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
+(CGFloat)heightOfCell;

@end
