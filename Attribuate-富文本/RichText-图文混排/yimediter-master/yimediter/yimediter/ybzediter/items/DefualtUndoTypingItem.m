//
//  DefualtUndoTypingItem.m
//  yimediter
//
//  Created by ybz on 2017/12/4.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "DefualtUndoTypingItem.h"
#import "YIMEditerTextView.h"

@interface DefualtUndoTypingItem(){
    id first;
}

@property(nonatomic,strong)NSMutableArray<NSAttributedString*>* history;

@end

@implementation DefualtUndoTypingItem
-(instancetype)init{
    self.history = [NSMutableArray array];
    first = [[NSAttributedString alloc]initWithString:@""];
    [self.history addObject:first];
    return [self initWithImage:[UIImage imageNamed:@"yimediter.bundle/ctrlz"]];
}
-(BOOL)clickAction{
    if (self.history.count > 1) {
        NSAttributedString *last = self.history[self.history.count - 2];
        self.textView.attributedText = last;
        [self.history removeLastObject];
        [self.textView updateObjectsUI];
    }
    return false;
}
-(void)textView:(YIMEditerTextView *)textView styleDidChange:(YIMEditerStyle *)style{
    if (textView.selectedRange.length || style.isParagraphStyle) {
        [self pushAttributedString:textView.attributedText];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    [self pushAttributedString:textView.attributedText];
}

-(void)pushAttributedString:(NSAttributedString*)string{
    if (self.history.count > 100) {
        [self.history removeObject:self.history.firstObject];
    }
    [self.history addObject:string];
}

@end
