//
//  CardView.h
//  card
//
//  Created by tmachc on 15/9/11.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCard.h"

@interface CardView : UIView

@property (nonatomic, getter=isGrayBackgroud) BOOL grayBackgroud;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, strong, readonly) PlayingCard *card;

- (instancetype)initWithPlayingCard:(PlayingCard *)card;

@end
