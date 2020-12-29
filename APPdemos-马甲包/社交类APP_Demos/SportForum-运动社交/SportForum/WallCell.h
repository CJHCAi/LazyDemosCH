//
//  WallCell.h
//  SportForum
//
//  Created by zhengying on 6/10/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "SFGridViewCell.h"
#import "AutoSizeTextLabel.h"
@interface WallCellInfo : NSObject
@property(nonatomic, copy) NSString* imageUser;
@property(nonatomic, copy) NSString* imageURL;
@property(nonatomic, copy) NSString* title;
@property(nonatomic, assign) NSInteger thumbCount;
@property(nonatomic, assign) NSInteger commentCount;
@end

@interface WallCell : SFGridViewCell
@property(nonatomic, strong) UIView* viewContent;
@property(nonatomic, strong) AutoSizeTextLabel* lblDesc;
@property(nonatomic, strong) UIImageView* imgViewUser;
@property(nonatomic, strong) UIImageView* imgViewPic;
@property(nonatomic, strong) UIView* viewFrame;
@property(nonatomic, strong) WallCellInfo* cellInfo;
@property(nonatomic, assign) BOOL showThumbAndCommentCount;
@end
