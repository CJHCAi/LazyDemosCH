//
//  RoundProgressView.h
//  RoundProgressView
//
//  Created by Danny Shmueli on 7/9/13.
//  Copyright (c) 2013 Danny Shmueli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoundProgressViewDelegate <NSObject>

- (void)stopAction;

@end

@interface RoundProgressView : UIView

@property (nonatomic, readwrite) float progress;
@property (nonatomic, assign) id<RoundProgressViewDelegate>delegate;

@end
