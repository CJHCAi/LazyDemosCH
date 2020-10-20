//
//  LSLCoverView.h
//  BubbleButton
//
//  Created by lisonglin on 15/05/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSLCoverView;

@protocol LSLCoverViewDelegate <NSObject>

@optional
- (void)coverView:(LSLCoverView *)coverView didClickBtnAtIndex:(NSInteger)index dismiss:(BOOL)dismiss;

@end

@interface LSLCoverView : UIView

@property(nonatomic, assign,getter=isShow) BOOL show;



@property(nonatomic, weak) id<LSLCoverViewDelegate> delegate ;


@end
