//
//  KeyboardViewController.m
//  key
//
//  Created by 姬拉～ on 2016/12/22.
//  Copyright © 2016年 姬拉～. All rights reserved.
//

#import "KeyboardViewController.h"
#import "KeyView.h"
@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) NSTimer*timer;
@end

@implementation KeyboardViewController
{
    BOOL isdo;
    KeyView*_keyView;
    NSString*poststr;
    NSInteger count;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    count=0;
    
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
    [self.view addSubview:self.nextKeyboardButton];
    [self.nextKeyboardButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.nextKeyboardButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    KeyView*keyView=[[KeyView alloc]initWithFrame:CGRectMake(0, 0, 375, 220)];
    [self.view addSubview:keyView];
    _keyView=keyView;
    
    [keyView.beginbutton addTarget:self action:@selector(todo:) forControlEvents:UIControlEventTouchDown];
    [keyView.beginbutton2 addTarget:self action:@selector(todo2:) forControlEvents:UIControlEventTouchDown];
}

-(void)todo2:(UIButton*)sender
{
    [self advanceToNextInputMode];
}

-(void)todo:(UIButton*)sender
{
    [self.textDocumentProxy insertText:@"\n"];
    return;
    if (isdo) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer=nil;
        }
        isdo=NO;
    }else{
        poststr=_keyView.textstr.text.length<=0?@"你看我打字快不快？":_keyView.textstr.text;
         self.timer= [NSTimer scheduledTimerWithTimeInterval:0.5/_keyView.value target:self selector:@selector(post) userInfo:nil repeats:YES];
        isdo=YES;
    }
    NSString *buttontitle=isdo?@"奔跑中":@"奔跑吧姬拉";
    [sender setTitle:buttontitle forState:UIControlStateNormal];
    [sender setTitle:buttontitle forState:UIControlStateHighlighted];
}
-(void)post{
    count++;
    if (count%2==0) {
        [self.textDocumentProxy insertText:poststr];
        
    }else{
        
        [self.textDocumentProxy insertText:@"\n"];
    }
}
- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
