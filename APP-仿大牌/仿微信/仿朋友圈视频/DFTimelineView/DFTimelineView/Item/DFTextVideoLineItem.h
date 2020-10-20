//
//  DFTextVideoLineItem.h
//  DFTimelineView
//
//  Created by CaptainTong on 15/11/13.
//  Copyright © 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

@interface DFTextVideoLineItem : DFBaseLineItem

@property (nonatomic, strong) NSString *text;

@property(nonatomic,strong)NSString *videoUrl;

@property (nonatomic, strong) NSAttributedString *attrText;

@end
