//
//  LHEditViewController.m
//  LHRichEditor
//
//  Created by 刘昊 on 2018/5/9.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import "LHEditViewController.h"
#import "XDEditTextTool.h"
#import "XDRichTextView.h"
#import "XDRichTextModel.h"
#import "SqliteUtil.h"
#import "UIColor+HEX.h"
#import "UIView+Extension.h"
#import "NSAttributedString+Rich.h"
#import "NSString+JSON.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kAppFrameWidth      [[UIScreen mainScreen] bounds].size.width
#define kAppFrameHeight     [[UIScreen mainScreen] bounds].size.height
@interface LHEditViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    XDEditTextTool *_textTool;
    XDRichTextView *_textView;
    NSString *_text;
    XSIndexModel *_model;//索引的模型
    SqliteUtil *_db;
    SqliteUtil *_indexdb;

    NSString * _weatherType;
    BOOL _isShow;
    NSString *_time;
    NSString *_searchStr;
    UIImagePickerControllerSourceType _camtype;
    
}
@property (nonatomic ,strong) UIImage *image;
@end

@implementation LHEditViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //当退出做题控制器是开启侧滑，不然所有作业模块控制器全部不能侧滑退出
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //当进入做题的控制器时关闭侧滑
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self setUI];
    
    if (_model.type == 1) {
        //使用索引查询
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_works WHERE workId like '%%%@%%'",[NSString stringWithFormat:@"%@%@%@",_model.year,_model.moth,_model.day]];
        NSArray *workIdArr = [_db teacherAnwser:sql];
        if (workIdArr.count) {
            NSArray *arr = workIdArr.lastObject;
            NSMutableAttributedString * mutableAttributedStr=[[NSMutableAttributedString alloc]init];
            for (NSDictionary * dict in arr) {
                if (dict[@"image"]!=nil) {
                    //默认图片
                    NSData *decodedImageData = [[NSData alloc]
                                                initWithBase64EncodedString:dict[@"image"]  options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage *image = [UIImage imageWithData:decodedImageData];
                    CGSize  imgSize = image.size;
                    CGFloat newImgW = imgSize.width;
                    CGFloat newImgH = imgSize.height;
                    CGFloat textW   = kAppFrameWidth - (30);
                    
                    if (newImgW > textW) {
                        CGFloat ratio = textW / newImgW;
                        newImgW  = textW;
                        newImgH *= ratio;
                    }
                    
                    /*---------------添加内容 start-----------------*/
                    // 转换图片
                    NSTextAttachment *attachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
                    attachment.image = image;
                    attachment.bounds = CGRectMake(0, 0, newImgW, newImgH);
                    //Insert image image
                    [mutableAttributedStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]
                                                         atIndex:mutableAttributedStr.length];
                }
                NSString * plainStr=dict[@"title"];
                NSMutableAttributedString * attrubuteStr=[[NSMutableAttributedString alloc]initWithString:plainStr];
                //设置初始内容
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = [dict[@"lineSpace"] floatValue];// 字体的行间距
                
                UIColor *color = [UIColor colorWithHexString:dict[@"color"]];
                if(color == nil){
                    color = UIColorFromRGB(0x333333);
                }
                NSDictionary *attributes = @{
                                             NSParagraphStyleAttributeName:paragraphStyle,
                                             NSForegroundColorAttributeName: color,
                                             NSStrokeWidthAttributeName:([dict[@"bold"] boolValue]?@-3:@0),
                                             NSObliquenessAttributeName :([dict[@"obliq"] boolValue]?@0.3:@0),//斜体
                                             NSUnderlineStyleAttributeName:([dict[@"underline"] boolValue]?@1:@0), // 下划线
                                             NSUnderlineColorAttributeName:color,  // 下划线颜色
                                             NSFontAttributeName :[UIFont systemFontOfSize:[dict[@"font"] floatValue]]
                                             };
                //是否加粗
                [attrubuteStr addAttributes:attributes range:NSMakeRange(0, attrubuteStr.length)];
                [mutableAttributedStr appendAttributedString:attrubuteStr];
            }
            _textView.attributedText =mutableAttributedStr;
            [_textView setInitLocation];
            //设置光标到末尾
            _textView.selectedRange=NSMakeRange(_textView.attributedText.length, 0);
            
        }
    }else{//重新写
        [_textView becomeFirstResponder];
    }
}
- (void)initData{
  
    _db = [SqliteUtil sharedSqliteUtil];
    [_db creatTable:@"CREATE TABLE IF NOT EXISTS t_works (id integer PRIMARY KEY AUTOINCREMENT, contexText text  NOT NULL, workId text NOT NULL);"];
    _indexdb = [SqliteUtil sharedSqliteUtil];
    [_indexdb creatTable:@"CREATE TABLE IF NOT EXISTS t_index (id integer PRIMARY KEY AUTOINCREMENT, contexText text  NOT NULL, workId text NOT NULL);"];
    /**
     * 注册通知，监听键盘的弹出和收回
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)setUI{
    
    UIButton *backBtn = [UIButton new];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setTitleColor:UIColorFromRGB(0xff0000) forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self textViewConfig];
    [self  setTextTool];
}
- (void)textViewConfig {
    
    _textView = [[XDRichTextView alloc] initWithFrame:CGRectMake((10),64 +(20), kAppFrameWidth - (20), kAppFrameHeight - 64  -(43) -(20))];
    _textView.tintColor = UIColorFromRGB(0x949494);
    [self.view addSubview:_textView];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:(15)],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:UIColorFromRGB(0x333333)
                                 };
    _textView.typingAttributes = attributes;
    _textView.delegate = self;
    
    


    
    
    
    
    
    
}


- (void)setTextTool{
    
    _textTool = [[XDEditTextTool alloc]initWithFrame:CGRectMake(0,kAppFrameHeight -(43), kAppFrameWidth, (43))];
    [self.view addSubview:_textTool];
    __weak typeof(_textTool ) weakTextTool =_textTool;
    _textView.block = ^{
        [weakTextTool hiddenView];
    };
    __weak typeof (self)blockSelf = self;
    __weak typeof (_textView) weak_textView = _textView;
    //相机
    _textTool.addImageBlock = ^{
        [blockSelf alert];
    };
    //字体
    //撤销
    _textTool.undoBlock = ^{
        [weak_textView undo];
    };
    
    //恢复
    _textTool.restoreBlock = ^{
        [weak_textView redo];
    };
    
    // 改变颜色
    _textTool.changeTextColerBlock = ^(UIColor *coler) {
        weak_textView.color  = coler;
    };
    
    _textTool.changekeyboardBlock = ^(BOOL isHidden) {
        if (isHidden) {// 键盘弹起
            [weak_textView becomeFirstResponder];
        }else{//键盘落下
            [weak_textView resignFirstResponder];
        }
    };
    
    // 加粗
    _textTool.changeToBoldBlock = ^(BOOL isBold) {
        weak_textView.Bold  = isBold;
    };
    
    //斜体
    _textTool.changeToObliqueBlock = ^(BOOL isOblique) {
        weak_textView.Oblique  = isOblique;
    };
    //下划线
    _textTool.changeToUnderLineBlock = ^(BOOL isUnderLine) {
        weak_textView.UnderLine  = isUnderLine;
        
    };
    //字体
    _textTool.textFontBlock = ^(CGFloat textFont) {
        weak_textView.NextFont = textFont;
    };
    
    
}

#pragma mark --- XDEditHeardToolDelegate 天气点击

- (void)seledWeather:(NSString *)imag{
    
    _weatherType = imag;
    
}
- (void)clickWeatherBtn{
    [_textView resignFirstResponder];
    _textTool.isEdit = NO;
    [_textTool hiddenView];
    
}
#pragma mark ---  texetView 代理
- (void)textViewDidChange:(UITextView *)textView{
    
    [_textTool hiddenView];
    NSInteger len=textView.attributedText.length-_textView.locationStr.length;
    if (len>0) {
        _textView.isDelete = NO;
        _textView.newRange=NSMakeRange(_textView.selectedRange.location-len, len);
        _textView.newstr=[textView.text substringWithRange:_textView.newRange];
    }
    else
    {
        _textView.isDelete = YES;
    }
    bool isChinese;//判断当前输入法是否是中文
    
    if ([[[textView textInputMode] primaryLanguage]  isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    NSString *str = [[_textView text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [_textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [ _textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            
            [_textView setStyle];
            
        }else
        {
            NSLog(@"没有转化--%@",str);
            NSLog(@"%@",NSStringFromRange(_textView.selectedRange));//这是对的
        }
    }else{
        [_textView setStyle];
    }
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (range.length == 1)     // 回删
    {
        return YES;
    }
    else
    {
        // 超过长度限制
        if ([textView.text length] >= 2000+3)
        {
            return NO;
        }
    }
    
    
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    _textTool.isEdit = YES;
    [_textTool hiddenView];
}

#pragma mark -- 键盘显示的监听方法
-(void) keyboardWillShow:(NSNotification *) note
{
    // 获取键盘的位置和大小
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    [_textTool setFrame:CGRectMake(0, keyboardBounds.origin.y -(43),kAppFrameWidth,(43))]; // 50为工具栏高度
    _textView.height  = kAppFrameHeight - 64 -(12) -keyboardBounds.size.height -(43) -(20) -(5);
    
}

#pragma mark -- 键盘隐藏的监听方法
-(void) keyboardWillHide:(NSNotification *) note
{
    [_textTool setFrame:CGRectMake(0,kAppFrameHeight -(43), kAppFrameWidth, (43))];
    _textView.height = kAppFrameHeight - 64 -(12) -(43) -(20) -(5);
}

- (void)alert {
    
    __weak typeof(self)sjWeakself = self; // 弱化self
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sjWeakself cameraAction]; // 引用弱化self 调用相机
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sjWeakself photoAction]; // 引用弱化self 调用相册
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:takeAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)cameraAction{
    /**
     * 调用相机
     */
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self selectImage:UIImagePickerControllerSourceTypeCamera];
        
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"不支持相机" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"不支持相机");
    }
}

-(void)photoAction{
    /**
     * 调用本地相册
     */
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self selectImage:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"不支持相册" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

-(void)selectImage:(UIImagePickerControllerSourceType)type{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    picker.delegate = self;
    picker.allowsEditing = YES;
    _camtype = type;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    
 
  
     UIImage *newImage  = info[UIImagePickerControllerOriginalImage];


    CGSize  imgSize = newImage.size;
    CGFloat newImgW = imgSize.width;
    CGFloat newImgH = imgSize.height;
    CGFloat textW   = _textView.frame.size.width;
    UIGraphicsBeginImageContext(_image.size);
    if (newImgW > textW) {
        CGFloat ratio = textW / newImgW;
        newImgW  = textW;
        newImgH *= ratio;
        UIGraphicsBeginImageContext(CGSizeMake(newImgW, newImgH));
        [newImage drawInRect:CGRectMake(0, 0, newImgW, newImgH)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _image = image;
    }else{
        _image = newImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (_image) {
        [_textView addImage:_image];
        _image = nil;
    }
    
}

// 当实现取消的代理方法的时候，默认图片选取界面是不能放回的，必须在这个代理方法里面实现
// 如果这个方法不需要做其他操作，这个方法不用实现
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)backBtnClicked{
    if (_textView.attributedText.length) {
        NSArray *arr1 =  [_textView.attributedText getArrayWithAttributed];
        NSString *image = @"";
        for (NSDictionary * dict in arr1) {
            if (dict[@"image"]!=nil) {
                //默认图片
                image = dict[@"image"];
                break;
            }
        }
        
        NSString *wors = @"";
        for (NSDictionary * dict1 in arr1) {
            if (dict1[@"image"]!=nil || [dict1[@"title"] isEqualToString:@"\n"] || [dict1[@"title"] containsString:@"\n"] ) {
                
            }else{
                NSString *title = dict1[@"title"];
                NSString *newTitle = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                wors = [wors stringByAppendingString:newTitle];
                NSLog(@"%ld", wors.length);
            }
        }
        
        
        NSString *string = _textView.attributedText.string;
        NSArray *array = [string componentsSeparatedByString:@"\n"];
        NSString *content = @"";
        if (array.count) {
            content = array[0];
            if (!content.length) {
                for (NSString *str in array) {
                    content = [content stringByAppendingString:str];
                }
            }
        }else{
            content = string;
        }
        //字数
        NSInteger words = wors.length;
        //保存索引
        NSDictionary *dic = @{
                              @"day":_model.day,
                              @"type":@"1",
                              @"year":_model.year,
                              @"moth":_model.moth,
                              @"index":[NSString stringWithFormat:@"%ld",_model.index],
                              @"image":image,
                              @"words":[NSString stringWithFormat:@"%ld",words],
                              @"content":content
                              };
        
        NSString *conten = [NSString dicToString:dic];
        if (_model.type ==1) {//更新
            NSString *sql1 = [NSString stringWithFormat:@"update t_index set contexText = '%@' where workId = '%@'",conten,[NSString stringWithFormat:@"%@%@%@",_model.year, _model.moth,_model.day]];
            [_indexdb insertOrUpdateData:sql1];
        }else{//插入
            NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO t_index (contexText, workId) VALUES ('%@','%@');",conten,[NSString stringWithFormat:@"%@%@%@",_model.year, _model.moth,_model.day]];
            [_indexdb insertOrUpdateData:sql1];
        }
        NSString *sqlcontent = [NSString arrayToString:arr1];
        if (_model.type ==1) {//更新
            NSString *sql1 = [NSString stringWithFormat:@"update t_works set contexText = '%@' where workId = '%@'",sqlcontent,[NSString stringWithFormat:@"%@%@%@",_model.year, _model.moth,_model.day]];
            [_db insertOrUpdateData:sql1];
        }else{//插入
            NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO t_works (contexText, workId) VALUES ('%@','%@');",sqlcontent,[NSString stringWithFormat:@"%@%@%@",_model.year, _model.moth,_model.day]];
            [_db insertOrUpdateData:sql1];
        }
        
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resh" object:dic];
        
        
        NSArray *pushArr =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *documents = [pushArr lastObject];
        NSString *documentPath = [documents stringByAppendingPathComponent:@"arrayXML.xml"];
        NSArray *resultArray = [NSArray arrayWithContentsOfFile:documentPath];
        NSMutableArray *pushMarr = [NSMutableArray array];
        [pushMarr addObjectsFromArray:resultArray];
        [pushMarr addObject:[NSString stringWithFormat:@"%@%@%@",_model.year,_model.moth,_model.day]];
        [pushMarr writeToFile:documentPath atomically:YES];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
      
    }else{//如果啥都没有删除掉它
        NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM t_index WHERE workId = '%@'",[NSString stringWithFormat:@"%@%@%@",_model.year,_model.moth,_model.day]];
        [_indexdb deleteData:sql1];
        NSString *sql2 = [NSString stringWithFormat:@"DELETE FROM t_works WHERE workId = '%@'",[NSString stringWithFormat:@"%@%@%@",_model.year,_model.moth,_model.day]];
     
        [_indexdb deleteData:sql1];
        [_db deleteData:sql2];
     
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resh" object:nil];
    }

    [self.navigationController popViewControllerAnimated:YES];
    

    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textTool hiddenView];
}


@end
