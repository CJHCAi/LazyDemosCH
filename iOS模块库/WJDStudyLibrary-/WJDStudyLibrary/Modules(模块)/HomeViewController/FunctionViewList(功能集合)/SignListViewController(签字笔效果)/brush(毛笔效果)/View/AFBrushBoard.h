//
//  AFBrushBoard.h
//  AFBrushBoard
//
//  Created by Ordinary on 16/3/24.
//  Copyright © 2016年 Ordinary. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OkClick)(void);

@interface AFBrushBoard : UIImageView

@property(nonatomic,copy)OkClick okClick;

@end
