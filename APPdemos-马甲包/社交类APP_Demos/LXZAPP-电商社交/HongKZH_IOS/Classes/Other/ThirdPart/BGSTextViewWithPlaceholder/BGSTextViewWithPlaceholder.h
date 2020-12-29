//
//  BGSTextViewWithPlaceholder.h
//  BGSTextViewWithPlaceholder
//
//  Created by Peter Todd Air on 30/08/2014.
//  Copyright (c) 2014 Bright Green Star. All rights reserved.
//
/*
    This aim of this development is to create a UITextView class that performs as a standard UITextView but also
    enables the inclusion of placeholder text.  Similar to UITextField.
    Requirements
    1 - should accept a string to display as placeholder text
    2 - should default to a light grey color, similar to UITextField text
    3 - shoudl be able to pass an optional font to the display the placeholder text
    4 - when the user starts editing the placeholder text should vanish
    5 - If there is no text in the TextView then the placeholder text should reappear (for example the user deletes the text in the TV
    6 - It would be nice to be able to add the placeholder text in stroyboard
    7 - The resulting class should be easily added to an existing project using cocopods
    8 - Multiline placeholder text would be useful
    
    Approach
    Putting a centred UILabel in the middle of the TV seems to be the way to go.
    The uilabel can be toggled on and off by notifications on update of textview
 
 
 */

#import <UIKit/UIKit.h>


@interface BGSTextViewWithPlaceholder : UITextView

@property (strong, nonatomic) NSAttributedString *strPlaceholder; //  The placeholder text, an attributed string should allow more flexibility in content display
@property int intLines; // The maximum number of lines to use to display text
@property int intHeight; // Optional Height
@property int intWidth; // Optional Width

@property BOOL sizeLblToFit; // Optional size label to fit

- (void)clearPlaceholder; // Used when Textview is in edit mode and might already be populated

-(void)changePlaceholderSize;

@end
