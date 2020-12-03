//
//  ViewController.m
//  MaoAttributedString
//
//  Created by 毛韶谦 on 16/8/19.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *myFirstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 440, 50)];
    [self.view addSubview:myFirstLabel];
    /**
     NSMutableAttributedString 初始化
     */
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"MaoAttributedString蓝翔技校" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    /**
     *  添加属性
     为某一范围内文字设置多个属性
     - (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range;
     为某一范围内文字添加某个属性
     - (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
     为某一范围内文字添加多个属性
     - (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range;
     移除某范围内的某个属性
     - (void)removeAttribute:(NSString *)name range:(NSRange)range;
     */
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSBackgroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(0, 2)];
    [attributedString addAttributes:@{NSStrikethroughStyleAttributeName:@(9)} range:NSMakeRange(2, 5)];
    [attributedString addAttributes:@{NSStrikethroughStyleAttributeName:@(2),NSStrikethroughColorAttributeName:[UIColor greenColor]} range:NSMakeRange(9, 3)];
    [attributedString addAttributes:@{NSStrokeColorAttributeName:[UIColor orangeColor],NSStrokeWidthAttributeName:@(2),NSFontAttributeName:[UIFont systemFontOfSize:30]} range:NSMakeRange(13, 4)];
    [attributedString addAttributes:@{NSStrokeColorAttributeName:[UIColor cyanColor],NSStrokeWidthAttributeName:@(-2),NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(17, 3)];
    [attributedString addAttributes:@{NSExpansionAttributeName:@(1),NSObliquenessAttributeName:@(1)} range:NSMakeRange(20, 2)];
    
    [attributedString addAttributes:@{NSKernAttributeName:@(30)} range:NSMakeRange(20, 1)];
    /**
     *
     *
     *    具体属性；
     *
     *
     */
    
    /**
     *  
     字体：NSFontAttributeName
     该属性所对应的值是一个 UIFont 对象。该属性用于改变一段文本的字体。如果不指定该属性，则默认为12-point Helvetica(Neue)。
     
     段落格式：NSParagraphStyleAttributeName
     该属性所对应的值是一个 NSParagraphStyle 对象。该属性在一段文本上应用多个属性。如果不指定该属性，则默认为 NSParagraphStyle 的defaultParagraphStyle 方法返回的默认段落属性。
      
     字体颜色：NSForegroundColorAttributeName
     该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的字体颜色。如果不指定该属性，则默认为黑色。
     
     * NSForegroundColorAttributeName 设置的颜色与 UILabel 的 textColor 属性设置的颜色在地位上是相等的，与 NSBackgroundColorAttributeName 地位上也相等，谁最后赋值，最终显示的就是谁的颜色，但是textColor属性可以与 NSBackgroundColorAttributeName 属性可叠加。
     
     
     背景颜色：NSBackgroundColorAttributeName
     该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的背景颜色。如果不指定该属性，则默认无背景色。
     
     删除线格式 ：
     NSStrikethroughStyleAttributeName 设置删除线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值：
     •	NSUnderlineStyleNone 不设置删除线
     •	NSUnderlineStyleSingle 设置删除线为细单实线
     •	NSUnderlineStyleThick 设置删除线为粗单实线
     •	NSUnderlineStyleDouble 设置删除线为细双实线
     ￼
     •	虽然使用了枚举常量，但是枚举常量的本质仍为整数，所以同样必须先转化为 NSNumber 才能使用
     •	删除线和下划线使用相同的枚举常量作为其属性值
     •	目前iOS中只有上面列出的4中效果，虽然我们能够在头文件中发现其他更多的取值，但是使用后没有任何效果
     
     另外，删除线属性取值除了上面的4种外，其实还可以取其他整数值，有兴趣的可以自行试验，取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
     
     下划线格式：NSUnderlineStyleAttributeName
     该属性所对应的值是一个 NSNumber 对象(整数)。该值指定是否在文字上加上下划线，该值参考“Underline Style Attributes”。默认值是NSUnderlineStyleNone。
     下划线除了线条位置和删除线不同外，其他的都可以完全参照删除线设置。
     
     删除线颜色：NSStrikethroughColorAttributeName
     NSStrikethroughColorAttributeName 设置删除线颜色，取值为 UIColor 对象，默认值为黑色
     
     删除线宽度：NSStrokeWidthAttributeName
     
     阴影：NSShadowAttributeName
     该属性所对应的值是一个 NSShadow 对象。默认为 nil。单独设置不好使，和这三个任意一个都可以，NSVerticalGlyphFormAttributeName，NSObliquenessAttributeName，NSExpansionAttributeName
     
     字间距：NSKernAttributeName(字间距)
     NSKernAttributeName 设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
     
     边线颜色：NSStrokeColorAttributeName(边线颜色) 和 NSStrokeWidthAttributeName(边线宽度)
     NSStrokeWidthAttributeName 这个属性所对应的值是一个 NSNumber 对象(小数)。该值改变笔画宽度（相对于字体 size 的百分比），负值填充效果，正值中空效果，默认为 0，即不改变。正数只改变描边宽度。负数同时改变文字的描边和填充宽度。例如，对于常见的空心字，这个值通常为 3.0。
     同时设置了空心的两个属性，并且 NSStrokeWidthAttributeName 属性设置为整数，文字前景色就无效果了
     
     字体倾斜：NSObliquenessAttributeName(字体倾斜)
     
     文本扁平化：NSExpansionAttributeName (文本扁平化)
     */
    
    
    /**
     *  添加方法
     */
    myFirstLabel.attributedText = attributedString;
    
    UITextField *myFirstTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, 400, 60)];
    [self.view addSubview:myFirstTextField];
    myFirstTextField.attributedText = attributedString;
    
    UITextView *myFirstTextView = [[UITextView alloc] initWithFrame:CGRectMake(60, 300, 300, 60)];
    [self.view addSubview:myFirstTextView];
    myFirstTextView.attributedText = attributedString;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
