//
//  XDRichTextView.h
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/21.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDRichTextView : UITextView
/**插入图片*/
- (void)addImage:(UIImage *)image;
/**加粗*/
@property (nonatomic ,assign)   BOOL  Bold;
/**斜体*/
@property (nonatomic ,assign)   BOOL  Oblique;
/**下划线*/
@property (nonatomic ,assign)   BOOL  UnderLine;
/**字体*/
@property (nonatomic ,assign) CGFloat  NextFont;
@property (nonatomic,strong)  UIColor * color;
@property (nonatomic,assign) BOOL isDelete;        //是否是回删
@property (nonatomic,copy) NSString *newstr;
@property (nonatomic,assign) NSRange newRange;
@property (nonatomic,strong) NSMutableAttributedString * locationStr;
- (void)undo;
//恢复
- (void)redo;


@property (nonatomic,copy) void(^block)(void);

-(void)setInitLocation;
- (void)setStyle;
@end
