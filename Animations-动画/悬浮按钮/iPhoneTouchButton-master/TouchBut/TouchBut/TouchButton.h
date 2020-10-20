//
//  TouchButton.h
//  TouchBut
//
//  Created by 邱荣贵 on 2017/12/6.
//  Copyright © 2017年 邱久. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchButton : UIButton
{
    BOOL MoveEnable;
    BOOL MoveEnabled;
    CGPoint beginpoint;
}

@property(nonatomic)BOOL MoveEnable;
@property(nonatomic)BOOL MoveEnabled;

@end
