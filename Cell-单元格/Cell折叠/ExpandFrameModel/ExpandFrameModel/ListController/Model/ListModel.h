//
//  ListModel.h
//  ExpandFrameModel
//
//  Created by 栗子 on 2017/12/6.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, assign) BOOL isSelected;

@end
