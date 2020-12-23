//
//  ViewController.m
//  Calculator1
//
//  Created by ruru on 16/4/12.
//  Copyright © 2016年 ruru. All rights reserved.
//  bug:1按下等号之后再按todo就不能正常运算了。例如按下"1+5=6+8"
//      2按下todo后按数字再按等号显示不正常，

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "historyTableViewCell.h"
#import "setViewController.h"

#define RGB(color)    [UIColor colorWithRed:(color>>16)/255.0 green:((color>>8)&0xff)/255.0 blue:(color&0xff)/255.0 alpha:1]
#define RGBA(color,opacity) [UIColor colorWithRed:(color>>16)/255.0 green:((color>>8)&0xff)/255.0 blue:(color&0xff)/255.0 alpha:opacity]

@interface ViewController ()

@end

@implementation ViewController{
    NSString * numberBefore;    //前个数字
    NSString * numberCurrent;   //当前数字
    NSString * actionType;      //当前存储的加减乘除动作  + - * /
    double result;
    BOOL  isActionTypeMove;     //加减乘除已经做了移位
    BOOL  isStatusEqual;        //是否按了等号
    BOOL isStatusDEG;
    NSMutableArray *historyData;
    NSIndexPath *secletIndexPath;
    int musicOn;
    
}
- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:YES];//隐藏导航栏
    historyData=[[NSMutableArray alloc]init];
    [super viewDidLoad];
    self.subKeyboardView.hidden=YES;
    self.subKeyboardView2.hidden=NO;
    isStatusDEG=YES;
    self.historyTableView.delegate=self;
    self.historyTableView.dataSource=self;
    [self clearDate];
    numberCurrent=@"0";
    [self performSelector:@selector(bindEvent) withObject:nil afterDelay:0.01];
    
    CGRect historyFrame = self.historyView.frame;
    historyFrame.origin.x=0;
    self.historyView.frame = historyFrame;
    self.historyView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    [self readHistoryData];
    
    
    CGRect keyboardNumberFrame = self.keyboardView.frame;
    keyboardNumberFrame.origin.x=self.view.frame.size.width;
    self.keyboardView.frame = keyboardNumberFrame;
    
    CGRect keyboardMathFrame = self.keyboardView2.frame;
    keyboardMathFrame.origin.x=self.view.frame.size.width*2;
    self.keyboardView2.frame = keyboardMathFrame;
    
    CGSize size = self.scrollerView.contentSize;
    size.width = self.keyboardView.frame.size.width*3;
    self.scrollerView.contentSize=size;
    
    CGPoint scrollContentOffset = self.scrollerView.contentOffset;
    scrollContentOffset.x= self.view.frame.size.width;
    self.scrollerView.contentOffset = scrollContentOffset;
}

-(void)viewWillAppear:(BOOL)animated{
    musicOn=[[Common configGet:@"key_music_on"]intValue];
    NSDictionary *themeDic=[Common configGetTheme:@"key_setting_theme"];
    NSString *isStateDefine=[Common configGet:@"theme_Define_background"];
    int DefineInt=[isStateDefine intValue];
    if (DefineInt) {
        self.backView.hidden=NO;
        [self setDenfineBackground];
        [self setBackgroundBeffect];
    }else if ([[themeDic objectForKey:@"theme_background_color"] isKindOfClass:[NSArray class]]) {
        self.backView.hidden=YES;
        NSString *color = [[themeDic objectForKey:@"theme_background_color"] objectAtIndex:0 ];
        long int colorInt =strtoul([color UTF8String],0,16);//字符串转成
        self.view.backgroundColor=RGB(colorInt);
    }else if([[themeDic objectForKey:@"theme_background_color"] isKindOfClass:[NSString class]]){
        self.backView.hidden=NO;
        [self setImageBackground];
        [self setBackgroundBeffect];
    }
        [self SetButtonColor];
}
-(void)setDenfineBackground{
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"backgroundImage.png"];
    UIImage *saveDefineImage=[[UIImage alloc] initWithContentsOfFile:fullPath];
    UIImageView * back = (UIImageView *)[self.backView subviews][0];
    [back setImage:saveDefineImage];
}
-(void)setImageBackground{
    NSDictionary *themeDict=[Common configGetTheme:@"key_setting_theme"];
    NSString *backgroundImage=[themeDict objectForKey:@"theme_background_color"];
    UIImageView * back = (UIImageView *)[self.backView subviews][0];
    [back setImage:[UIImage imageNamed:backgroundImage]];
}
-(void)setBackgroundBeffect{
    UIView *subviews  = [self.backView viewWithTag:800];//使用viewWtihTag非常方便，可以通过父View的viewWtihTag获取到子View，但是前提是创建子View的时候要加tag，如：
    [subviews removeFromSuperview];
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *BeffectView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    BeffectView.frame = self.backView.bounds;
    BeffectView.tag=800;
    int bgBlurEffectSata=[[Common configGet:@"key_bg_lurEffect_on"]intValue];
    if (bgBlurEffectSata) {
        [self.backView addSubview:BeffectView];
    }else{
        if ([BeffectView isKindOfClass:[self.backView class]]) {
        }
    }
}
-(void)SetButtonColor{
    if (![Common configGetTheme:@"key_setting_theme"]) {
        return;
    }
    NSDictionary *themeDict=[Common configGetTheme:@"key_setting_theme"];
//    NSLog(@"themeDict======%@",themeDict);
    NSString *BtnBgColor=[[themeDict objectForKey:@"button_background_color"] objectAtIndex:0 ];
    long int BtnBgColorInt =strtoul([BtnBgColor UTF8String],0,16);//字符串转成
    NSString *BtnTitleColor=[[themeDict objectForKey:@"font-color"] objectAtIndex:0 ];
    long int BtnTitleColorInt =strtoul([BtnTitleColor UTF8String],0,16);//字符串转成
    
    int tag;
    for (tag=10; tag<=57; tag++) {
        UIButton *button = (UIButton *)[self.keyboardView viewWithTag:tag];
        UIButton *button1= (UIButton *)[self.keyboardView2 viewWithTag:tag];
        UIButton *button2 = (UIButton *)[self.subKeyboardView viewWithTag:tag];
        UIButton *button3 = (UIButton *)[self.subKeyboardView2 viewWithTag:tag];
        
        [button  setBackgroundColor:RGB(BtnBgColorInt)];
        [button1 setBackgroundColor:RGB(BtnBgColorInt)];
        [button2  setBackgroundColor:RGB(BtnBgColorInt)];
        [button3 setBackgroundColor:RGB(BtnBgColorInt)];
        [button setTitleColor:RGB(BtnTitleColorInt) forState:UIControlStateNormal];
        [button1 setTitleColor:RGB(BtnTitleColorInt) forState:UIControlStateNormal];
        [button2 setTitleColor:RGB(BtnTitleColorInt) forState:UIControlStateNormal];
        [button3 setTitleColor:RGB(BtnTitleColorInt) forState:UIControlStateNormal];
    }
    for (tag=20; tag<=22; tag++) {
        UIButton *button = (UIButton *)[self.keyboardView viewWithTag:tag];
        long int colorInt =strtoul([[[themeDict objectForKey:@"specialButton_bg_color"] objectAtIndex:0 ] UTF8String],0,16);//字符串转成
        [button  setBackgroundColor:RGB(colorInt)];
    }
    for (tag=23; tag<=27; tag++) {
        UIButton *button = (UIButton *)[self.keyboardView viewWithTag:tag];
        long int colorInt =strtoul([[[themeDict objectForKey:@"button_Key_color"] objectAtIndex:0 ] UTF8String],0,16);//字符串转成
        [button  setBackgroundColor:RGB(colorInt)];
    }
}
-(void)clearDate{
    numberBefore=nil;
    numberCurrent=@"0";
    actionType=nil;
    result=0;
    isActionTypeMove=NO;
    isStatusEqual=NO;
    self.resultLabel.text=@"0";
    self.mathLabel.text=@"";
}

-(void)bindEvent{
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObjectsFromArray:self.keyboardView.subviews];
    [arr addObjectsFromArray:self.keyboardView2.subviews];
    [arr addObjectsFromArray:self.subKeyboardView.subviews];
    [arr addObjectsFromArray:self.subKeyboardView2.subviews];
    [arr addObjectsFromArray:self.view.subviews];
    for (UIButton *button in arr) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button addTarget:self action:@selector(pressDownAction:) forControlEvents:UIControlEventTouchDown ];
            [button addTarget:self action:@selector(pressUpAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(pressClearAction:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(pressClearAction:) forControlEvents:UIControlEventTouchCancel];//按下button是退出app
            
            CGRect frame = button.frame;
            frame.size.width+=0.5;frame.size.height+=0.5;
            button.frame = frame;
        }
    }
}
-(void)pressDownAction:(UIButton *)button{
    NSArray *array=[Common configGetClcikMusic:@"MusicKey"];
    NSLog(@"array%@",array);
    NSString *clickMusicStr=[array objectAtIndex:0];
    if (musicOn) {
        if ([clickMusicStr isEqualToString:@"Music1"]) {
            [self playSoundEffect:@"click.wav"];
        }else if([clickMusicStr isEqualToString:@"Music2"]){
            [self playSoundEffect:@"click1.wav"];
        }else if([clickMusicStr isEqualToString:@"Music3"]){
            [self playSoundEffect:@"click2.wav"];
        }else if([clickMusicStr isEqualToString:@"Music4"]){
            [self playSoundEffect:@"click3.wav"];
        }
    }
    NSLog(@"readmusic%@",[Common configGet:@"key_music_on"]);
    button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    button.alpha=0.6;
}
//取消按钮动作动画
-(void)pressClearAction:(UIButton *)button{
    button.transform = CGAffineTransformMakeScale(1, 1);
    button.alpha=1;
}
-(void)clearActionButton{
    int tag;
    for (tag=23; tag<=26; tag++) {
        UIButton * button = (UIButton *)[self.view viewWithTag:tag];
        [self pressClearAction:button];
    }
}
//抬起按钮的逻辑
-(void)pressUpAction:(UIButton *)button{
    [self pressClearAction:button];
    int buttonTag=(int)button.tag;
    switch (buttonTag) {
        case 10:[self numberGreate:0]; break; //0为实际参数
        case 11:[self numberGreate:1]; break;
        case 12:[self numberGreate:2]; break;
        case 13:[self numberGreate:3]; break;
        case 14:[self numberGreate:4]; break;
        case 15:[self numberGreate:5]; break;
        case 16:[self numberGreate:6]; break;
        case 17:[self numberGreate:7]; break;
        case 18:[self numberGreate:8]; break;
        case 19:[self numberGreate:9]; break;
        case 20:[self clearDate] ; break;
        case 21:[self actionInverse] ;break;
        case 22:[self actionPercent] ;break;
        case 23:[self actionTodo:button type:@"÷"] ;break;
        case 24:[self actionTodo:button type:@"×"] ;break;
        case 25:[self actionTodo:button type:@"-"] ;break;
        case 26:[self actionTodo:button type:@"+"] ;break;
        case 27:[self actionEqual] ;break;
        case 28:[self actionPoint] ;break;
            
        case 30:[self actionE]; break; //0为实际参数
        case 31:[self actionPi]; break;
        case 32:[self actionDEG]; break;
        case 33:[self actionChangeSubkeyboardView]; break;
        case 34:[self actionSinh]; break;
        case 35:[self actionConh]; break;
        case 36:[self actionTanh]; break;
        case 37:[self actionEPow]; break;
        case 38:[self actionSin]; break;
        case 39:[self actionCos]; break;
        case 40:[self actionTan] ; break;
        case 41:[self actionLn] ;break;
        case 42:[self actionSquareRoot] ;break;
        case 43:[self actionCubeRoot] ;break;
        case 44:[self actionTodo:button type:@"˟√y"] ;break;
        case 45:[self actionLog] ;break;
        case 46:[self actionSquare] ;break;
        case 47:[self actionCube] ;break;
        case 48:[self actionTodo:button type:@"y^x"] ;break;
        case 49:[self actionFactorials] ;break;
            
        case 50:[self actionArcsin] ;break;
        case 51:[self actionArccos] ;break;
        case 52:[self actionArctan] ;break;
        case 53:[self actionLog2] ;break;
        case 54:[self actionArcsinh] ;break;
        case 55:[self actionArcconh] ;break;
        case 56:[self actionArctanh] ;break;
        case 57:[self action2pow] ;break;
            
        default:break;
    }
    [self mathMode];
}
#pragma mark=======keyboardView2(math)
-(void)actionSquare{
    if (numberCurrent!=0) {
        double value=[numberCurrent doubleValue]*[numberCurrent doubleValue];
        numberCurrent=[self subString:value];
        [self setNumberDisplay:numberCurrent];
    }
}
-(void)actionCube{
    if (numberCurrent!=0) {
        double value=[numberCurrent doubleValue]*[numberCurrent doubleValue]*[numberCurrent doubleValue];
        numberCurrent=[self subString:value];
        [self setNumberDisplay:numberCurrent];
    }
}
-(void)actionFactorials{//阶乘
    double i; double fac=1;
    if ([numberCurrent doubleValue]==0||[numberCurrent doubleValue]==1) {
        numberCurrent=[NSString stringWithFormat:@"1"];
    }else if(numberCurrent>0){
        double j=[numberCurrent doubleValue];
        NSLog(@"j=%lf",j);
        for (i=2; i<=j; i++) {
            fac=fac*i;
        }
        numberCurrent=[self subString:fac];
    }
    [self setNumberDisplay:numberCurrent];
}
-(void)actionSquareRoot{
    if ([numberCurrent doubleValue]>=0) {
        double value=sqrt([numberCurrent doubleValue]);
        numberCurrent=[self subString:value];
        
    }
    [self setNumberDisplay:numberCurrent];
}
-(void)actionCubeRoot{
    double value=pow([numberCurrent doubleValue], 1.0/3);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionE{
    numberCurrent=[NSString stringWithFormat:@"2.718281828459"];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionPi{
    numberCurrent=[NSString stringWithFormat:@"3.1415926535898"];
    [self setNumberDisplay:numberCurrent];
    
}
-(void)changeDeg{
    if (!isStatusDEG) {
        double Value=[numberCurrent doubleValue]*(3.1415926535898/180);
        NSString *str=[self subString:Value];
        numberCurrent=str;
        //        isStatusDEG=YES;
    }
}
-(void)actionDEG{
    isStatusDEG=!isStatusDEG;
    if (isStatusDEG) {
        UIButton *button = (UIButton *)[self.view viewWithTag:32];
        [button setTitle:@"Deg" forState:UIControlStateNormal];
    }else{
        UIButton *button=(UIButton *)[self.view viewWithTag:32];
        [button setTitle:@"Rad" forState:UIControlStateNormal];
    }
    
}
-(void)actionSin{
    [self changeDeg];
    double value=sin([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionArcsin{
    [self changeDeg];
    double value=1/sin([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionCos{
    [self changeDeg];
    double value=cos([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionArccos{
    [self changeDeg];
    double value=1/cos([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionTan{
    [self changeDeg];
    double value=tan([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionArctan{
    [self changeDeg];
    double value=1/tan([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionSinh{
    [self changeDeg];
    double value=sinh([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionArcsinh{
    [self changeDeg];
    double value=1/sinh([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionConh{
    [self changeDeg];
    double value=cosh([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionArcconh{
    [self changeDeg];
    double value=1/cosh([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}

-(void)actionTanh{
    [self changeDeg];
    double value=tanh([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionArctanh{
    [self changeDeg];
    double value=1/tanh([numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}

-(void)actionEPow{//e^x
    double e=2.718281828459;
    double value=pow(e, [numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)action2pow{
    double value=pow(2,[numberCurrent doubleValue]);
    numberCurrent=[self subString:value];
    [self setNumberDisplay:numberCurrent];
}
-(void)actionLog{
    if ([numberCurrent doubleValue]>0) {
        double value=log10([numberCurrent doubleValue]);
        numberCurrent=[self subString:value];
    }
    [self setNumberDisplay:numberCurrent];
}
-(void)actionLn{
    if ([numberCurrent doubleValue]>0) {
        double value=log([numberCurrent doubleValue]);
        numberCurrent=[self subString:value];
    }
    [self setNumberDisplay:numberCurrent];
}
-(void)actionLog2{
    if ([numberCurrent doubleValue]>0) {
        double value=log2([numberCurrent doubleValue]);
        numberCurrent=[self subString:value];
    }
    [self setNumberDisplay:numberCurrent];
}
-(void)actionChangeSubkeyboardView{
    self.subKeyboardView.hidden=!self.subKeyboardView.hidden;
    self.subKeyboardView2.hidden=!self.subKeyboardView2.hidden;
}

-(void)actionInverse{    //取反
    if ([numberCurrent doubleValue]) {
        if (!isStatusEqual) {
            double doubleValue=-[numberCurrent doubleValue];
            numberCurrent=[self subString:doubleValue];
            [self setNumberDisplay:numberCurrent];
        }else{
            double Value=-result;
            NSString *str=[self subString:Value];
            [self setNumberDisplay:str];
            result=Value;
        }
    }
}
-(void)actionPercent{
    if ([numberCurrent doubleValue]) {
        if (!isStatusEqual) {
            double doubleValue=[numberCurrent doubleValue]/100;
            numberCurrent=[self subString:doubleValue];
            [self setNumberDisplay:numberCurrent];
        }else{
            double Value=result/100;
            NSString *str=[self subString:Value];
            [self setNumberDisplay:str];
            result=Value;
        }
    }
}
-(void)actionPoint{
    if ([self stringHasPoint:numberCurrent]) {
        return;
    }else{
        numberCurrent=[NSString stringWithFormat:@"%@.",numberCurrent];
        [self setNumberDisplay:numberCurrent];
    }
}
-(BOOL)stringHasPoint:(NSString *)string{
    NSRange rang=[string rangeOfString:@"."];
    if (rang.length>0) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark=======math Action
-(void)numberGreate:(int)number{//number形式参数
    if (isStatusEqual) {
        [self clearDate];
    }
    if (actionType&&!isActionTypeMove){
        numberBefore=numberCurrent;
        numberCurrent=@"0";
        isActionTypeMove=YES;
    }
    if ([numberCurrent isEqualToString:@"0"]) {
        numberCurrent=[NSString stringWithFormat:@"%d",number];
    }else if([self stringHasPoint:numberCurrent]||[[numberCurrent substringWithRange:NSMakeRange(0,1)]isEqualToString:@"-"]) {
        if (numberCurrent.length>=10) {
            return;
        }else{
            numberCurrent=[NSString stringWithFormat:@"%@%d",numberCurrent,number];
        }
    }else if (numberCurrent.length>=9) {
        return;
    }else{
        numberCurrent=[NSString stringWithFormat:@"%@%d",numberCurrent,number];
    }
    [self setNumberDisplay:numberCurrent];
    [self mathLabel];
}
-(void)actionTodo:(UIButton *)button type:(NSString *)type{
    isActionTypeMove=NO;
    if ([numberCurrent isEqualToString:@"0"]) {
        return;
    }
    if (numberBefore&&![numberCurrent isEqualToString:@""]&&actionType){
        if (isStatusEqual) {
            numberCurrent=[self subString:result];
            isStatusEqual=NO;
        }else{
            [self calculationType];
            numberCurrent=[self subString:result];
            [self setNumberDisplay:numberCurrent];
            NSLog(@"NU%@",numberCurrent);
        }
    }
    actionType=type;
}

-(void)mathMode{
    
    if (numberCurrent&&!actionType) {
        self.mathLabel.text=[self setNumber:numberCurrent];
    }else if(numberCurrent&&actionType&&!numberBefore){
        self.mathLabel.text=[NSString stringWithFormat:@"%@ %@",[self setNumber:numberCurrent],actionType];
    }else if(numberBefore&&![numberCurrent isEqualToString:@""]&&actionType&&!isStatusEqual){
        if (isActionTypeMove) {
            self.mathLabel.text=[NSString stringWithFormat:@"%@ %@ %@",[self setNumber:numberBefore],actionType,[self setNumber:numberCurrent]];
        }else{
            self.mathLabel.text=[NSString stringWithFormat:@"%@ %@",[self setNumber:numberCurrent],actionType];
        }
    }else if(numberCurrent&&actionType&&numberBefore){
        if (isStatusEqual) {
            self.mathLabel.text=[NSString stringWithFormat:@"%@ %@ %@ =",[self setNumber:numberBefore],actionType,[self setNumber:numberCurrent]];
        }
    }
}
-(void)actionEqual{
    if (!numberBefore) {
        return;
    }
    if (!isStatusEqual) {
        [self calculationType];
    }else{
        numberBefore=[self subString:result];
        [self calculationType];
    }
    NSString *resultStr=[self subString:result];
    [self setNumberDisplay:resultStr];
    [savehistoryData historyAdd: [self time] beforeNum:[self setNumber:numberBefore] operationType:actionType CurrentNub:[self setNumber:numberCurrent] result:[self setNumber:resultStr]];
    [self readHistoryData];
    
    isStatusEqual=YES;
}
-(void)calculationType{
    if ([actionType isEqualToString:@"+"]) {
        result=[numberBefore doubleValue]+[numberCurrent doubleValue];
    }else if([actionType isEqualToString:@"-"]){
        result=[numberBefore doubleValue]-[numberCurrent doubleValue];
    }else if([actionType isEqualToString:@"×"]){
        result=[numberBefore doubleValue]*[numberCurrent doubleValue];
    }else if([actionType isEqualToString:@"÷"]){
        result=[numberBefore doubleValue]/[numberCurrent doubleValue];
    }else if([actionType isEqualToString:@"y^x"]){
        result=pow([numberBefore doubleValue], [numberCurrent doubleValue]);
    }else if([actionType isEqualToString:@"˟√y"]){
        result=pow([numberBefore doubleValue], 1/[numberCurrent doubleValue]);
    }
}
-(void)setNumberDisplay:(NSString *)numberDisplay{
    self.resultLabel.text=[self setNumber:numberDisplay];
}
-(NSString *)setNumber:(NSString *)number{
    NSMutableString *strnumber=[[NSMutableString alloc]init];
    strnumber=[number mutableCopy];
    int length=(int)strnumber.length;
    int index;
    NSRange rang=[strnumber rangeOfString:@"."];
    if (rang.length>0) {
        for ( int j=0; j<=length; j++) {
            NSString *Char=[strnumber substringWithRange:NSMakeRange(j, 1)];
            if ([Char isEqualToString:@"."]) {
                index=j;
                break;
            }
        }if (3<index&&index<=9) {
            for (int i=index; i>3; i=i-3) {//找出小数点为位置i
                if ([[strnumber substringWithRange:NSMakeRange(i-4,1)]isEqualToString:@"-"]) {
                    break;
                }else{
                    [strnumber insertString:@"," atIndex:i-3];
                }
            }
        }
    } else if (3<length&&length<=9) {
        for (int i=length; i>3; i=i-3) {
            if ([[strnumber substringWithRange:NSMakeRange(i-4,1)]isEqualToString:@"-"]) {
                break;
            }else{
                [strnumber insertString:@"," atIndex:i-3];
            }
        }
    }
    else if(length>9){
        if ([[strnumber substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"-"]) {
            NSString *fisrtChar=[strnumber substringWithRange:NSMakeRange(1, 1)];
            NSString *afterPointChar=[strnumber substringWithRange:NSMakeRange(2, 5)];
            NSString *lengthStr=[NSString stringWithFormat:@"%lu",(unsigned long)strnumber.length];
            strnumber=[[NSString stringWithFormat:@"-%@.%@e%@",fisrtChar,afterPointChar,lengthStr]mutableCopy];
        }else{
            NSString *fisrtChar=[strnumber substringWithRange:NSMakeRange(0, 1)];
            NSString *afterPointChar=[strnumber substringWithRange:NSMakeRange(1, 5)];
            NSString *lengthStr=[NSString stringWithFormat:@"%lu",(unsigned long)strnumber.length];
            strnumber=[[NSString stringWithFormat:@"%@.%@e%@",fisrtChar,afterPointChar,lengthStr]mutableCopy];
        }
    }
    number=[strnumber copy];
    return number;
}
-(NSString*)subString:(double)value{   //截取字符串
    NSString *str=[NSString stringWithFormat:@"%lf",value];
    int index=(int) str.length;
    int i;
    for (i=(int)str.length;i>0;i--) {
        //      NSLog(@"i=%d str.length=%d",i,(int)str.length);
        NSString *lastChar=[str substringWithRange:NSMakeRange(i-1, 1)];
        if (![lastChar isEqualToString:@"0"]) {
            index=i;
            if ([lastChar isEqualToString:@"."]) {
                index--;
            }break;
        }
    }
    NSString *subString=[str substringWithRange:NSMakeRange(0, index)];
    return subString;
}
#pragma mark 音效实现函数

-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    SystemSoundID soundID=0;//获得系统声音ID
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesPlaySystemSound(soundID);//播放音效
}
#pragma mark ======historyView

#pragma mark 读取历史记录
-(void)readHistoryData{
    historyData=[savehistoryData seachHistoryData];
    [self.historyTableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return historyData.count;
}
-(UIViewController *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSDictionary *cellInfo=historyData[indexPath.row];
    return [[historyTableViewCell alloc]initWithData:cellInfo tableView:tableView];
}
-(NSString *)time{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a= [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%ld",(long)a];
    int currentTime=(int)a;
    NSLog(@"time%d",currentTime);
    return timeString;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    secletIndexPath = indexPath;
    UIActionSheet *mysheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清空所有",@"删除",@"使用结果",nil];
    [mysheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [savehistoryData deleteAllHistory];
            [self readHistoryData];
            break;
        case 1:
            [savehistoryData deleteSelectHistory:historyData[secletIndexPath.row][@"ID"]];
            [self readHistoryData];
            break;
        case 2:
            [self clearDate];
            numberCurrent = [historyData[secletIndexPath.row][@"ResultStr"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            [self setNumberDisplay:numberCurrent];
            
            CGPoint scrollerViewOffset = self.scrollerView.contentOffset;
            scrollerViewOffset.x = self.view.frame.size.width;
            [self.scrollerView setContentOffset:scrollerViewOffset animated:YES];
            break;
        default:break;
    }
}
- (IBAction)settingBtn:(id)sender {
    setViewController *page=[[setViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
@end
