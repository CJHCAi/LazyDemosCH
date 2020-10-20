//
//  ContactTableViewCell.h
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactModel;
@interface ContactTableViewCell : UITableViewCell


@property (nonatomic,strong) ContactModel *contact;//model
/**是否选中 多个单元格需要从VC中插看是否被选中*/
@property (nonatomic,copy) void (^selectedBlock)(ContactModel *contact);//huidiao

@end
