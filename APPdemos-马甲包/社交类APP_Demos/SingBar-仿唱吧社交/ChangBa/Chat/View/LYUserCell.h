//
//  LYUserCell.h
//  ITSNS
//
//  Created by Ivan on 16/3/11.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EaseMob.h>
#import <BmobSDK/Bmob.h>

@interface LYUserCell : UITableViewCell

@property (nonatomic, strong)EMConversation *conversation;


@property (nonatomic, strong)BmobUser *user;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *unreadCount;
@end
