//
//  DefualtUndoTypingItem.h
//  yimediter
//
//  Created by ybz on 2017/12/4.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerAccessoryMenuItem.h"
#import "YIMEditerProtocol.h"

@interface DefualtUndoTypingItem : YIMEditerAccessoryMenuItem <YIMEditerTextViewDelegate>

@property(nonatomic,weak)YIMEditerTextView *textView;

@end
