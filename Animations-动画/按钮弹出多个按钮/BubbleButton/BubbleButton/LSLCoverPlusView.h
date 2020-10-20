//
//  LSLCoverPlusView.h
//  BubbleButton
//
//  Created by lisonglin on 15/05/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSLCoverPlusView;

@protocol LSLCoverPlusViewDelegate <NSObject>

- (void)coverPlusView:(LSLCoverPlusView *)coverView didClickAtIndex:(NSInteger)index;

@end

@interface LSLCoverPlusView : UIView

@property(nonatomic, weak) id<LSLCoverPlusViewDelegate> delegate ;


@end
