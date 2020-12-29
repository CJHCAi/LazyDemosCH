//
//  IMMessageCellFactory.h
//  StepUp
//
//  Created by chenLong on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface IMMessageCellFactory : NSObject

@end

@interface IMMessageBaseCell : UITableViewCell

- (BOOL)shouldUpdateCellWithObject:(id)object;

@end

@interface IMMessageTextCell : IMMessageBaseCell

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

@end

@interface IMMessageImageCell : IMMessageBaseCell

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

@end

@interface IMMessageAudioCell : IMMessageBaseCell

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

@end