//
//  YIMEditerTextView.m
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <Availability.h>
#import <CoreText/CoreText.h>

#import "YIMEditerTextView.h"
#import "YIMEditerInputAccessoryView.h"
#include "HtmlElement.h"



@interface YIMEditerTextView()<YIMEditerInputAccessoryViewDelegate,UITextViewDelegate,YIMEditerStyleChangeDelegate>{
    
}
/**所有样式对象*/
@property(nonatomic,strong)NSMutableArray<id<YIMEditerStyleChangeObject>> *allObjects;
/**默认的绘制属性，emmmmmmm....没啥用的时候就用它就是了*/
@property(nonatomic,strong)YIMEditerDrawAttributes *defualtDrawAttributed;

@property(nonatomic,strong)NSMutableArray<id<YIMEditerTextViewDelegate>>* delegateList;

@end

@implementation YIMEditerTextView


#pragma override super
-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}
-(void)setUp{
    //注册苹果内置的两种中文字体
    YIMEditerFontFamilyManager *manager = [YIMEditerFontFamilyManager defualtManager];
    [manager regiestFont:@"PingFang SC"];
    [manager regiestFont:@"Heiti SC"];
    
    self.delegate = self;
    self.toNewWindowIsBecomeFirstResponder = true;
    self.delegateList = [NSMutableArray array];
    self.defualtDrawAttributed = [self createDefualtDrawAttributes];
    self.allObjects = [NSMutableArray array];
    
    YIMEditerInputAccessoryView *accessoryView = [[YIMEditerInputAccessoryView alloc]init];
    accessoryView.delegate = self;
    accessoryView.frame = CGRectMake(0, 0, self.frame.size.width, 38);
    self.inputAccessoryView = accessoryView;
    
    //添加默认字体编辑项
    DefualtFontItem *item = [[DefualtFontItem alloc]init];
    //添加默认段落编辑项
    DefualtParagraphItem *item1 = [[DefualtParagraphItem alloc]init];
    //撤回编辑项
    DefualtUndoTypingItem *item2 = [[DefualtUndoTypingItem alloc]init];
    item2.textView = self;
    
    self.menus = @[item,item1,item2];
    [self addStyleChangeObject:item.fontView];
    [self addStyleChangeObject:item1.paragraphView];
    [self addUserDelegate:item2];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.inputAccessoryView.frame;
    rect.size.width = CGRectGetWidth(self.frame);
    self.inputAccessoryView.frame = rect;
}
-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    NSAttributedString *s = self.attributedText;
    NSLog(@"%@",s);
    if (newWindow) {
        if(self.toNewWindowIsBecomeFirstResponder)
            [self becomeFirstResponder];
    }
}
-(void)setDelegate:(id<UITextViewDelegate>)delegate{
    if (delegate != self) {
        return;
    }
    [super setDelegate:delegate];
}


#pragma -mark get set
-(void)setMenus:(NSArray<YIMEditerAccessoryMenuItem *> *)menus{
    NSMutableArray* arr = [NSMutableArray array];
    [arr addObject:[[YIMEditerAccessoryMenuItem alloc]initWithImage:[UIImage imageNamed:@"yimediter.bundle/keyboard"]]];
    [arr addObjectsFromArray:menus];
    _menus = arr;
    ((YIMEditerInputAccessoryView*)self.inputAccessoryView).items = arr;
}
- (NSArray<id<YIMEditerStyleChangeObject>>*)styleObjects{
    return [NSArray arrayWithArray:self.allObjects];
}

#pragma -mark public method
//添加一个Object时
-(void)addStyleChangeObject:(id<YIMEditerStyleChangeObject>)styleChangeObj{
    //设置样式变更的代理
    styleChangeObj.styleDelegate = self;
    [self.defualtDrawAttributed updateAttributed:[styleChangeObj.defualtStyle outPutAttributed]];
    [self.allObjects addObject:styleChangeObj];
}
-(void)addUserDelegate:(id<YIMEditerTextViewDelegate>)del{
    [self.delegateList addObject:del];
}
-(void)updateObjectsUI{
    YIMEditerDrawAttributes *attributes = nil;
    //如果有选中文字，获取选中文字的样式
    if (self.selectedRange.length) {
        attributes = [self attributedFromRange:self.selectedRange];
    }else{
        //当前没有文字 使用默认样式
        if(self.text.length == 0){
            attributes = self.defualtDrawAttributed;
        }else if(self.selectedRange.location > 0){
            //通常取光标前一个字符的属性为当前样式
            //但是如果前一个字符是换行符时，需要取换行符后面的字符样式为当前样式。因为换行符的属性属于上一个段落的，而当前光标位置并不希望得到上一个段落的样式
            if ([self.text characterAtIndex:(self.selectedRange.location + self.selectedRange.length - 1)] == '\n') {
                //如果光标后面还有字符，取后一个字符，否则使用默认样式
                if (self.text.length > self.selectedRange.location + self.selectedRange.length) {
                    attributes = [self attributedFromRange:NSMakeRange(self.selectedRange.location, 1)];
                }else{
                    attributes = [self defualtDrawAttributed];
                }
            }else{
                //使用光标前一个字符的属性
                attributes = [self attributedFromRange:NSMakeRange(self.selectedRange.location - 1, 1)];
            }
        }else{
            attributes = [[YIMEditerDrawAttributes alloc]init];
        }
    }
    //通知所有object更新UI
    for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
        [obj updateUIWithTextAttributes:attributes];
    }
    //更新默认文字属性
    self.defualtDrawAttributed = attributes;
    //设置下一个字符的属性
    [self setTypingWithAttributed:attributes];
}







-(NSString*)outPutHtmlString{
    NSMutableString* htmlString = [NSMutableString string];
    
    BOOL isNewParagraph = true;
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < self.text.length) {
        
        NSDictionary *attributes = [self.attributedText attributesAtIndex:effectiveRange.location+effectiveRange.length effectiveRange:&effectiveRange];
        
        YIMEditerDrawAttributes *drawAttributes = [[YIMEditerDrawAttributes alloc]initWithAttributeString:attributes];
        
        //字符的html style
        NSMutableString *htmlStyleString = [NSMutableString string];
        //字符的html tag
        NSMutableArray<NSString*>* htmlAttributes = [NSMutableArray array];
        //段落的html style
        NSMutableString *paragraphHtmlStyleString = [NSMutableString string];
        //段落的html tag
        NSMutableArray<NSString*>* paragraphHtmlAttributes = [NSMutableArray array];
        for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
            YIMEditerStyle *style = [obj styleUseAttributed:drawAttributes];
            if(style.isParagraphStyle){
                [paragraphHtmlStyleString appendString:[style htmlStyle]];
                [paragraphHtmlAttributes addObjectsFromArray:[style htmlAttributed]];
            }else{
                [htmlStyleString appendString:[style htmlStyle]];
                [htmlAttributes addObjectsFromArray:[style htmlAttributed]];
            }
        }
        
        //根据换行符分段
        NSArray<NSString*>* strs = [[self.text substringWithRange:effectiveRange] componentsSeparatedByString:@"\n"];
        for (int i = 0; i < strs.count; i++) {
            NSString *str = strs[i];
            if (str.length) {
                //新的段落
                if (isNewParagraph) {
                    [htmlString appendFormat:@"<p style=\"%@\">",paragraphHtmlStyleString];
                    for (NSString* htmlAttr in paragraphHtmlAttributes) {
                        [htmlString appendFormat:@"<%@>",htmlAttr];
                    }
                    isNewParagraph = false;
                }
                [htmlString appendFormat:@"<font style=\"%@\">",htmlStyleString];
                for (NSString* htmlAttr in htmlAttributes) {
                    [htmlString appendFormat:@"<%@>",htmlAttr];
                }
                [htmlString appendString:str];
                if (i !=  strs.count - 1) {
                    [htmlString appendString:@"\n"];
                }
                for (NSString* htmlAttr in [htmlAttributes reverseObjectEnumerator]) {
                    [htmlString appendFormat:@"</%@>",htmlAttr];
                }
                [htmlString appendString:@"</font>"];
            }
            //只要不是最后一段，则说明前面有一个换行符，则结束段落，开始新的段落
            if (i !=  strs.count - 1) {
                [htmlString appendString:@"</p>"];
                isNewParagraph = true;
            }
        }
    }
    [htmlString appendString:@"</p>"];
    return htmlString;
}
-(void)setHtml:(NSString *)htmlString{
    const char *c_html = [htmlString UTF8String];
    long index = 0;
    unsigned int count = 0;
    char *content = malloc(strlen(c_html));
    struct HtmlElement *elements = analy_html(c_html, &index, &count, content);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
    for (int i = 0; i < count; i++) {
        YIMEditerDrawAttributes *paragraphAttributes = [[YIMEditerDrawAttributes alloc]init];
        for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
            NSString* content = @"";
            [paragraphAttributes updateAttributed:[obj attributesUseHtmlElement:elements[i] isParagraphElement:true content:&content]];
        }
        for (int j = 0; j < elements[i].sub_elecount; j++) {
            YIMEditerDrawAttributes *textAttributes = [[YIMEditerDrawAttributes alloc]init];
            [textAttributes updateAttributed:paragraphAttributes];
            NSString* elementContent = @"";
            for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
                NSString* content = @"";
                [textAttributes updateAttributed:[obj attributesUseHtmlElement:elements[i].sub_elements[j] isParagraphElement:false content:&content]];
                if(content.length){
                    elementContent = content;
                }
            }
            [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:elementContent attributes:textAttributes.textAttributed]];
        }
    }
    self.attributedText = attributedString;
    
    HtmlElementRelease(elements, count);
}

#pragma -mark private method
/**从选中range中找到选中的段落range*/
-(NSRange)paragraphRangeWithSelectRange:(NSRange)range{
    NSInteger minRangIndex = range.location;
    for (; minRangIndex > 0 && [self.text characterAtIndex:minRangIndex - 1] != '\n'; minRangIndex--)
        ;
    NSInteger maxRangeIndex = range.location + range.length;
    for (; maxRangeIndex < self.text.length && [self.text characterAtIndex:MAX(maxRangeIndex - 1,0)] != '\n'; maxRangeIndex++)
        ;
    return NSMakeRange(minRangIndex, maxRangeIndex - minRangIndex);
}
-(void)setTypingWithAttributed:(YIMEditerDrawAttributes*)attr{
    self.typingAttributes = attr.textAttributed;
}
/**设置文字属性到指定区间*/
-(void)setTextWithAttributed:(YIMEditerDrawAttributes *)attr range:(NSRange)range{
    [self.textStorage setAttributes:attr.textAttributed range:range];
    NSRange paragraphRange = [self paragraphRangeWithSelectRange:range];
    [self.textStorage addAttributes:attr.paragraphAttributed  range:paragraphRange];
}
/**添加段落样式*/
-(void)addTextParagraphAttributed:(YIMEditerDrawAttributes *)attr range:(NSRange)range{
    NSRange paragraphRange = [self paragraphRangeWithSelectRange:range];
    [self.textStorage addAttributes:attr.paragraphAttributed range:paragraphRange];
}
/**从指定样式文字中提取绘制属性*/
-(YIMEditerDrawAttributes*)attributedFromAttributedText:(NSAttributedString*)text{
    NSRange range = {0,0};
    NSDictionary *attribute = [text attributesAtIndex:0 effectiveRange:&range];
    if (NSEqualRanges(NSMakeRange(0, text.string.length), range)) {
        return [[YIMEditerDrawAttributes alloc]initWithAttributeString:attribute];
    }
    return [self createDefualtDrawAttributes];
}
/**从指定区间提取绘制属性*/
-(YIMEditerDrawAttributes*)attributedFromRange:(NSRange)range{
    YIMEditerMutableDrawAttributes *attributes = [[YIMEditerMutableDrawAttributes alloc]init];
    //获取选中文字的属性
    NSDictionary *textAttributed = [self.textStorage attributesAtIndex:range.location longestEffectiveRange:NULL inRange:range];
    attributes.textAttributed = textAttributed;
    
    //获取选中段落
    NSRange paragraphRange = [self paragraphRangeWithSelectRange:range];
    //获取选中段落的属性
    NSDictionary *paragraphAttributed = [self.textStorage attributesAtIndex:paragraphRange.location longestEffectiveRange:NULL inRange:paragraphRange];
    attributes.paragraphAttributed = paragraphAttributed;
    return attributes;
}
/**创建一个默认属性*/
-(YIMEditerDrawAttributes*)createDefualtDrawAttributes{
    YIMEditerDrawAttributes *attr = [[YIMEditerDrawAttributes alloc]init];
    for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
        [attr updateAttributed:[obj.defualtStyle outPutAttributed]];
    }
    return attr;
}
/**获取当前属性，allObject的属性拼在一块儿得出的文字属性*/
-(YIMEditerDrawAttributes*)currentAttributes{
    YIMEditerDrawAttributes *attr = [[YIMEditerDrawAttributes alloc]init];
    for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
        [attr updateAttributed:[obj.currentStyle outPutAttributed]];
    }
    return attr;
}

#pragma -mark delegate functions
/**样式切换时*/
-(void)style:(id)sender didChange:(YIMEditerStyle *)newStyle{
    //获取当前文字属性
    YIMEditerDrawAttributes *currentAttributes = [self currentAttributes];
    //更新变更的属性
    [currentAttributes updateAttributed:[newStyle outPutAttributed]];
    //如果是段落样式，则应该是添加样式避免修改文本样式
    if (newStyle.isParagraphStyle) {
        [self addTextParagraphAttributed:[newStyle outPutAttributed] range:self.selectedRange];
    }else{
        //修改选中文字属性
        [self setTextWithAttributed:currentAttributes range:self.selectedRange];
    }
    //修改下一个字符属性
    [self setTypingWithAttributed:currentAttributes];
    
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textView:styleDidChange:)]) {
            [del textView:self styleDidChange:newStyle];
        }
    }
}


/**AccessoryView选择时*/
-(BOOL)YIMEditerInputAccessoryView:(YIMEditerInputAccessoryView*)accessoryView clickItemAtIndex:(NSInteger)index{
    BOOL returnValue = [self.menus[index] clickAction];
    if (returnValue) {
        //把inputView设置为菜单item对象返回的inputView
        self.inputView = [self.menus[index] menuItemInputView];
        //刷新inputView
        [self reloadInputViews];
    }
    //执行菜单item对象的点击方法
    return returnValue;
}


#pragma -mark TextView Delegate Functions
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"ShouldBeginEditing");
    bool returnValue = true;
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
            if(![del textViewShouldBeginEditing:textView]){
                returnValue = false;
            }
        }
    }
    return returnValue;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"ShouldEndEditing");
    bool returnValue = true;
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textViewShouldEndEditing:)]) {
            if(![del textViewShouldEndEditing:textView]){
                returnValue = false;
            }
        }
    }
    return returnValue;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"DidBeginEditing");
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textViewDidBeginEditing:)]) {
            [del textViewDidBeginEditing:textView];
        }
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"DidEndEditing");
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textViewDidEndEditing:)]) {
            [del textViewDidEndEditing:textView];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"shouldChangeTextInRange");
    YIMEditerDrawAttributes *attributes = [[YIMEditerDrawAttributes alloc]init];
    //获取所有Object上的当前样式
    for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
        [attributes updateAttributed:[obj.currentStyle outPutAttributed]];
    }
    //把样式更新到下一个字符属性
    [self setTypingWithAttributed:attributes];
    self.defualtDrawAttributed = attributes;
    
    
    bool returnValue = true;
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            if(![del textView:textView shouldChangeTextInRange:range replacementText:text]){
                returnValue = false;
            }
        }
    }
    return returnValue;
}
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"DidChange");
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textViewDidChange:)]) {
            [del textViewDidChange:textView];
        }
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"DidChangeSelection");
    [self updateObjectsUI];
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textViewDidChangeSelection:)]) {
            [del textViewDidChangeSelection:textView];
        }
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0){
    NSLog(@"shouldInteractWithURL");
    bool returnValue = true;
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:interaction:)]) {
            if(![del textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction]){
                returnValue = false;
            }
        }
    }
    return returnValue;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0){\
    NSLog(@"shouldInteractWithTextAttachment");
    bool returnValue = true;
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:interaction:)]) {
            if(![del textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction]){
                returnValue = false;
            }
        }
    }
    return returnValue;
}

#else
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    bool returnValue = true;
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
            if(![del textView:textView shouldInteractWithURL:URL inRange:characterRange]){
                returnValue = false;
            }
        }
    }
    return returnValue;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    bool returnValue = true;
    for (id<YIMEditerTextViewDelegate> del in self.delegateList) {
        if ([del respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
            if(![del textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange]){
                returnValue = false;
            }
        }
    }
    return returnValue;
}
#endif
@end
