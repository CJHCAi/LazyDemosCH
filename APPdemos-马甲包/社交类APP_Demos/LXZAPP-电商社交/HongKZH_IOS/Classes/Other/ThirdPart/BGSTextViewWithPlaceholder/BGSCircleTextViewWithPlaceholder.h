//
//  BGSCircleTextViewWithPlaceholder.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGSCircleTextViewWithPlaceholder : UITextView
@property (strong, nonatomic) NSAttributedString *strPlaceholder; //  The placeholder text, an attributed string should allow more flexibility in content display
@property int intLines; // The maximum number of lines to use to display text
@property int intHeight; // Optional Height
@property int intWidth; // Optional Width

@property BOOL sizeLblToFit; // Optional size label to fit

- (void)clearPlaceholder; // Used when Textview is in edit mode and might already be populated

-(void)changePlaceholderSize;
@end
