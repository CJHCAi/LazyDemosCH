//
//  SelwynFormItem.h
//  SelwynFormDemo
//
//  Created by BSW on 2017/6/24.
//  Copyright © 2017年 selwyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SelwynFormItem;

/* Values for SelwynFormCellType */
typedef NS_ENUM(NSInteger, SelwynFormCellType) {
    
    SelwynFormCellTypeNone = 0, //default
    SelwynFormCellTypeInput = 1, 
    SelwynFormCellTypeTextViewInput = 2,
    SelwynFormCellTypeSelect = 3,
};

typedef void(^FormItemSelectHandle)(SelwynFormItem *item);

@interface SelwynFormItem : NSObject

/* Type of cell */
@property (nonatomic, assign) SelwynFormCellType formCellType;

/* Form title */
@property (nonatomic, copy) NSString *formTitle;
@property (nonatomic, strong) NSAttributedString *formAttributedTitle;

/* Form detail */
@property (nonatomic, copy) NSString *formDetail;

/* Error message */
@property (nonatomic, copy) NSString *formError;

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;

/* Whether is required or must be selected */
@property (nonatomic, assign) BOOL required;

/* Whether can be edited */
@property (nonatomic, assign) BOOL editable;

/* KeyboardType */
@property (nonatomic, assign) UIKeyboardType keyboardType;

/* Select block */
@property (nonatomic, copy) FormItemSelectHandle selectHandle;

/* Word limit */
@property (nonatomic, assign) NSInteger maxInputLength; //default is 0 and 0 means no limit.

/* TextAlignment of textView content and placeholder */
@property (nonatomic, assign) NSTextAlignment textAlignment;




@end
