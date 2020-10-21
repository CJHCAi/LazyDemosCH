# XMTextView
XMTextView是UITextView的扩展的类，加入了placeholder，placeholderColor属性和文字数量的功能，

UITextView也可以直接使用placeholder和placeholderColor属性大大节省开发的时间，让开发变得更简单。

![Platform](https://wx2.sinaimg.cn/mw690/e067b31fgy1ftf4sf5xedj20af0mk759.jpg)

# 一，使用步骤
1，导入XMTextView文件夹

2，引用#import "XMTextView.h"头文件

3，使用方法：

//  XMTextView的使用
    XMTextView *tv = [[XMTextView alloc] initWithFrame:CGRectMake(16, 10, self.view.frame.size.width-2*16, 200)];
    [scrollView addSubview:tv];
    tv.textViewListening = ^(NSString *textViewStr) {
        NSLog(@"监听输入的内容：%@",textViewStr);
    };
    
    // UITextView可以直接使用placeholder和placeholderColor属性
    UITextView *tv3 = [[UITextView alloc] init];
    tv3.frame = CGRectMake(16, CGRectGetMaxY(tv2.frame)+20, self.view.frame.size.width-2*16, 200);
    tv3.placeholder = @"UITextView可以直接使用placeholder和placeholderColor属性";
    tv3.placeholderColor = [UIColor purpleColor];
    tv3.textColor = [UIColor redColor];
    tv3.font = [UIFont systemFontOfSize:20];
    [scrollView addSubview:tv3];

   
# 二，主要属性设置


    /** 文字最多字符数量显示类型 **/

    typedef enum {
        XMMaxNumStateNormal = 0,  // 默认模式（0/200）
        XMMaxNumStateDiminishing = 1,  // 递减模式（200）
    } XMMaxNumState;

     /** 是否设置边框 （默认 Yes） */
    @property (nonatomic, assign) BOOL isSetBorder;

    /** 上边距 (默认8)*/
    @property (nonatomic, assign) CGFloat topSpace;

    /** 左 右 边距 (默认8)*/
    @property (nonatomic, assign) CGFloat leftAndRightSpace;

    /** 边框线颜色 */
    @property (nonatomic, strong) UIColor *borderLineColor;

    /** 边宽线宽度 */
    @property (nonatomic, assign) CGFloat borderLineWidth;

    /** textView的内容 */
    @property (nonatomic, copy) NSString *text;

    /** textView 文字颜色 (默认黑色) */
    @property (nonatomic, strong) UIColor *textColor;

    /** textView 字体大小 (默认14) */
    @property (nonatomic, strong) UIFont *textFont;

    /** 占位文字 (默认：请输入内容) */
    @property (nonatomic, copy) NSString *placeholder;

    /** placeholder 文字颜色 (默认[UIColor grayColor]) */
    @property (nonatomic, strong) UIColor *placeholderColor;

    /** 文字最多数量 (默认200个字符)*/
    @property (nonatomic, assign) int textMaxNum;

    /** Num 文字颜色 (默认黑色) */
    @property (nonatomic, strong) UIColor *maxNumColor;

    /** Num 字体大小 (默认12) */
    @property (nonatomic, strong) UIFont *maxNumFont;

    /** Num 样式 （默认 0/200） */
    @property (nonatomic, assign) XMMaxNumState maxNumState;

    /** 返回输入监听内容 */
    @property (nonatomic, copy) XMBackText textViewListening;

# 四，注意事项
使用XMTextView时，frame设置一定要在设置其他属性之前

# 五，版本记录

- 2018-06-30　　初版
- 2018-07-19　　性能优化
- 2018-07-26　　解决崩溃问题


# 六，更多

1，如果觉得可以，请给个星星✨✨✨✨✨，谢谢🙏

1，如果您发现了bug请尽可能详细地描述系统版本、手机型号和复现步骤等信息 提一个issue.

3，你如果还有什么功能需求，也直接 提一个issue.

4，我的简书https://www.jianshu.com/p/e9c08ad811b3


