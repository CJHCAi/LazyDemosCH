//
//  FirendListCell.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/20.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "FirendListCell.h"

@implementation FirendListCell
- (void)awakeFromNib {
    self.photo.layer.masksToBounds = YES;
    self.photo.layer.cornerRadius = 30;
}
@end
