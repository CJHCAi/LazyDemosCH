//
//    Copyright (c) Scott Ban
//    https://github.com/reference/ComponentFactory
//
//
//    Permission is hereby granted, free of charge, to any person obtaining a
//    copy of this software and associated documentation files (the "Software"),
//    to deal in the Software without restriction, including without limitation
//    the rights to use, copy, modify, merge, publish, distribute, sublicense,
//    and/or sell copies of the Software, and to permit persons to whom the
//    Software is furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//    IN THE SOFTWARE.
//

#import "HKComponentFactory.h"

@implementation HKComponentFactory

+ (UIView *)viewWithFrame:(CGRect)frame supperView:(UIView *)view
{
    UIView *v = [[UIView alloc] initWithFrame:frame];
    v.backgroundColor = [UIColor clearColor];
    if (view) {
        [view addSubview:v];
    }
    return v;
}

+ (UITextView *)textViewWithFrame:(CGRect)frame
                             font:(UIFont *)font textColor:(UIColor*)color placeHolder:(NSString *)placeHolder
                       supperView:(UIView *)view;
{
    UITextView *tv = [[UITextView alloc] initWithFrame:frame];
    if (font) {
        tv.font = font;
        tv.placeholderLabel.font = font;
    }
    if (color) {
        tv.textColor = color;
    }
    tv.placeholder = placeHolder;
    if (view) {
        [view addSubview:tv];
    }
    return tv;
}

+ (UITableViewCell *)cellInTableView:(UITableView *)tbv identifier:(NSString *)identifier cellType:(UITableViewCellStyle)type
{
    UITableViewCell *cell = [tbv dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:type reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//label
+ (UILabel *)labelWithFrame:(CGRect)frame
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font
                       text:(NSString *)text
                 supperView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (color) {
        label.textColor = color;
    }
    label.text = text;
    if (font) {
        label.font = font;
    }
    if (alignment) {
        label.textAlignment = alignment;
    }
    label.backgroundColor = [UIColor clearColor];
    if (view) {
        [view addSubview:label];
    }
    return label;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                              image:(UIImage *)image
                         supperView:(UIView *)view
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = image;
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    if (view) {
        [view addSubview:imgView];
    }
    return imgView;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame
                        placeHolder:(NSString *)placeHolder
                    clearButtonMode:(UITextFieldViewMode)clearButtonMode
                               text:(NSString *)text
                          textColor:(UIColor *)color
                      textAlignment:(NSTextAlignment)alignment
           contentVerticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment
                               font:(UIFont *)font
                         backGround:(UIImage*)image
                    backgroundColor:(UIColor *)backgroundColor
                           delegate:(id<UITextFieldDelegate>)delegate
                          isSecurty:(BOOL)securty
                         supperView:(UIView *)view
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.clearButtonMode = clearButtonMode;
    textField.backgroundColor = backgroundColor;
    textField.placeholder = placeHolder;
    textField.text = text;
    if (color) {
        textField.textColor = color;
    }
    textField.textAlignment = alignment;
    if (font) {
        textField.font = font;
    }
    textField.contentVerticalAlignment = verticalAlignment;
    textField.background = image;
    textField.secureTextEntry = securty;
    textField.delegate = delegate;
    if (view) {
        [view addSubview:textField];
    }
    return textField;
}

+ (HKTextField *)hkTextFieldWithFrame:(CGRect)frame
                          placeHolder:(NSString *)placeHolder
                      clearButtonMode:(UITextFieldViewMode)clearButtonMode
                                 text:(NSString *)text
                            textColor:(UIColor *)color
                        textAlignment:(NSTextAlignment)alignment
             contentVerticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment
                                 font:(UIFont *)font
                           backGround:(UIImage*)image
                      backgroundColor:(UIColor *)backgroundColor
                             delegate:(id<UITextFieldDelegate>)delegate
                            isSecurty:(BOOL)securty
                           supperView:(UIView *)view
{
    HKTextField *textField = [[HKTextField alloc] initWithFrame:frame];
    textField.clearButtonMode = clearButtonMode;
    textField.backgroundColor = backgroundColor;
    textField.placeholder = placeHolder;
    textField.text = text;
    if (color) {
        textField.textColor = color;
    }
    textField.textAlignment = alignment;
    if (font) {
        textField.font = font;
    }
    textField.contentVerticalAlignment = verticalAlignment;
    textField.background = image;
    textField.secureTextEntry = securty;
    textField.delegate = delegate;
    if (view) {
        [view addSubview:textField];
    }
    return textField;
}

+ (UIButton *)buttonWithType:(UIButtonType)type
                       frame:(CGRect)frame
                       taget:(id)target
                      action:(SEL)selector
                  supperView:(UIView *)view
{
    UIButton *b = [UIButton buttonWithType:type];
    b.frame = frame;
    [b addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (view) {
        [view addSubview:b];
    }
    return b;
}

+ (UIButton *)buttonWithType:(UIButtonType)type
                       frame:(CGRect)frame
                       title:(NSString *)title
                        font:(UIFont *)font
                       taget:(id)target
                      action:(SEL)selector
                  supperView:(UIView *)view
{
    UIButton *b = [UIButton buttonWithType:type];
    b.frame = frame;
    [b addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [b setTitle:title forState:UIControlStateNormal];
    if (font) {
        b.titleLabel.font = font;
    }
    if (view) {
        [view addSubview:b];
    }
    return b;
}

+ (UIButton *)buttonWithType:(UIButtonType)type
                       frame:(CGRect)frame
                       title:(NSString *)title
                        font:(UIFont *)font
                  titleColor:(UIColor *)titleColor
                      radius:(CGFloat)radius
             backgroundColor:(UIColor *)backgroundColor
                       taget:(id)target
                      action:(SEL)selector
                  supperView:(UIView *)view
{
    UIButton *b = [UIButton buttonWithType:type];
    b.frame = frame;
    [b addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [b setTitle:title forState:UIControlStateNormal];
    if (titleColor) {
        [b setTitleColor:titleColor forState:UIControlStateNormal];
    }
    b.layer.cornerRadius = radius;
    b.layer.masksToBounds = YES;
    if (backgroundColor) {
        b.backgroundColor = backgroundColor;
    }
    if (font) {
        b.titleLabel.font = font;
    }
    if (view) {
        [view addSubview:b];
    }
    return b;
}

+ (UITableView *)tableViewWithFrame:(CGRect)frame
                              style:(UITableViewStyle)style
                           delegate:(id<UITableViewDelegate>)delegate
                         dataSource:(id<UITableViewDataSource>)dataSource
                         supperView:(UIView *)view
{
    UITableView *table = [[UITableView alloc] initWithFrame:frame style:style];
    table.delegate = delegate;
    table.dataSource = dataSource;
    table.backgroundColor = [UIColor whiteColor];
    table.backgroundView = nil;
    table.showsVerticalScrollIndicator = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (view) {
        [view addSubview:table];
    }
    return table;
}

+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame
                          contentSize:(CGSize)contentSize
                             delegate:(id <UIScrollViewDelegate>)delegate
                           supperView:(UIView *)view
{
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:frame];
    sc.delegate = delegate;
    sc.showsVerticalScrollIndicator = NO;
    sc.showsHorizontalScrollIndicator = NO;
    sc.contentSize = contentSize;
    
    if (view) {
        [view addSubview:sc];
    }
    
    return sc;
}

+ (UIWebView *)webViewWithFrame:(CGRect)frame delegate:(id<UIWebViewDelegate>)delegate supperView:(UIView *)supperView
{
    UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
    web.scalesPageToFit = YES;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.showsVerticalScrollIndicator = NO;
    web.delegate = delegate;
    
    //隐藏滚动条和上下滚动时出边界的后面的黑色的背景
    web.backgroundColor=[UIColor clearColor];
    for (UIView *aView in [web subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
            
            for (UIView *shadowView in aView.subviews)
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                }
            }
        }
    }
    
    if (supperView) {
        [supperView addSubview:web];
    }
    return web;
}

+ (UIButton *)blueStyleButtonWithWidth:(CGFloat)width
                                origin:(CGPoint)point
                                 title:(NSString *)title
                                 taget:(id)target
                                action:(SEL)action
                                inView:(UIView*)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(point.x, point.y, width, 40);
    [button setTitle:title  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //button.backgroundColor = COLOR_LIGHT_BULUE;
    button.layer.cornerRadius = 5;
    //    button.layer.borderWidth = 1;
    //    button.layer.borderColor = COLOR_RGBA(213.0, 213.0, 213.0, 1.0).CGColor;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (view) {
        [view addSubview:button];
    }
    return button;
}

+ (UIButton *)textStyleButtonWithWidth:(CGFloat)width
                                origin:(CGPoint)point
                                 title:(NSString *)title
                                 taget:(id)target
                                action:(SEL)action
                                inView:(UIView*)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(point.x, point.y, width, 30);
    [button setTitle:title  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:97/255.f green:97/255.f blue:97/255.f alpha:1]
                 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    button.backgroundColor = [UIColor clearColor];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (view) {
        [view addSubview:button];
    }
    return button;
}

//+ (HK_LeSeeCityRewardView *)rewardViewWithFrame:(CGRect)frame supperView:(UIView *)v
//{
//    HK_LeSeeCityRewardView *rv = [[HK_LeSeeCityRewardView alloc] initWithFrame:frame];
//    [v addSubview:rv];
//    return rv;
//}

+ (UICollectionView *)collectionViewWithFrame:(CGRect)frame layout:(UICollectionViewLayout *)layout showsHorizontalScrollIndicator:(BOOL)sH showsVerticalScrollIndicator:(BOOL)sV delegate:(id <UICollectionViewDelegate>)delegate dataSource:(id <UICollectionViewDataSource>)dataSource supperView:(UIView *)v;
{
    UICollectionView *c = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    
    c.backgroundColor=[UIColor clearColor];
    c.showsHorizontalScrollIndicator=sH;
    c.showsVerticalScrollIndicator=sV;
    c.dataSource = dataSource;
    c.delegate = delegate;
    
    if (v) {
        [v addSubview:c];
    }
    return c;
}

@end
