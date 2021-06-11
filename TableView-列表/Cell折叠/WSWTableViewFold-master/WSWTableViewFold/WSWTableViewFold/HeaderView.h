//
//  HeaderView.h
//  WSWTableViewFoldOpen
//
//  Created by WSWshallwe on 2017/5/25.
//  Copyright © 2017年 shallwe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBlock)(void);

@interface HeaderView : UIView

@property(nonatomic,copy)TapBlock block;

-(void)updateWithStatus:(int)status;

@end

