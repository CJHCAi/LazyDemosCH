//
//  HK_EnterpriseCertificationCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_FormCell.h"
#import "HK_UploadImagesModel.h"

@interface HK_FormCell () <UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIImageView *logoView;
@property (nonatomic, weak) UITextView *textView;
@end

@implementation HK_FormCell

- (UITextField *)textField {
    if (!_textField) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectZero];
        tf.delegate = self;
        tf.font = [UIFont fontWithName:PingFangSCRegular size:14.f];
        tf.textColor = RGB(102, 102, 102);
        tf.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:tf];
        self.textField = tf;
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(230);
            make.right.mas_equalTo(self.mas_right).offset(-16);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self);
        }];
        //KVO监听 textField 的 text 值变化,如果改变就重新赋值给 formModel 的 value
        [_textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _textField;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        UIImageView *logoView = [HKComponentFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@""] supperView:self.contentView];
        self.logoView = logoView;
        //布局
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-34);
        }];
    }
    return _logoView;
}

- (UITextView *)textView {
    if (!_textView) {
        UITextView *textView = [[UITextView alloc] init];
        textView.font = PingFangSCRegular15;
        textView.textColor = RGB(102, 102, 102);
        textView.delegate = self;
        [self.contentView addSubview:textView];
        self.textView = textView;
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.equalTo(self.contentView).offset(18);
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(152);
        }];
    }
    return _textView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:15.f];
        self.textLabel.textColor = RGB(51, 51, 51);
    }
    return self;
}

- (void)setFormModel:(HK_FormModel *)formModel {
    _formModel = formModel;
    //设置 textLabel 值
    self.textLabel.text = formModel.cellTitle;
    //设置 textfield 值
    if ([formModel isKindOfClass:[HK_TextFieldFormModel class]]) {
        HK_TextFieldFormModel *tfModel = (HK_TextFieldFormModel *)formModel;
        if (_formModel.value) {
            self.textField.text = _formModel.value; //给 formModel 赋值
        }
        self.textField.placeholder = tfModel.placeHolder;
    }
    //设置有选项的 cell 的值
    else if ([formModel isKindOfClass:[HK_SeclectFormModel class]]) {
        HK_SeclectFormModel *selectModel = (HK_SeclectFormModel *)formModel;
        self.detailTextLabel.text = selectModel.placeHolder;
        
        
    }
    //设置 图片 值
    else if ([formModel isKindOfClass:[HK_LogoFormModel class]]) {
        self.logoView.image = [UIImage imageNamed:@"mrlogo"];
        self.logoView.layer.cornerRadius = self.logoView.image.size.width/2;
        self.logoView.layer.masksToBounds = YES;
        HK_LogoFormModel *logoModel = (HK_LogoFormModel *)formModel;
        if (logoModel.hasImage) {
            if ([logoModel.value isKindOfClass:[HK_UploadImagesModel class]]) {
                HK_UploadImagesModel *model = logoModel.value;
                self.logoView.image = model.image;
            }
        }
    }
    //无法修改内容的 cell
    else if ([formModel isKindOfClass:[HK_UnableModifyFormModel class]]) {
        HK_UnableModifyFormModel *unableModifyFormModel = (HK_UnableModifyFormModel *)formModel;
        self.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:14];
        self.detailTextLabel.textColor = RGB(204,204,204);
        self.detailTextLabel.text = unableModifyFormModel.placeHolder;
    }
    //textview 类型的 cell
    else if ([formModel isKindOfClass:[HK_TextViewFormModel class]]) {
        HK_TextViewFormModel *tvModel = (HK_TextViewFormModel *)formModel;
        if (_formModel.value != nil) {
            self.textView.text = _formModel.value; //给 formModel 赋值
        }
        self.textView.placeholder = tvModel.placeHolder;
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"] && object == self.textField) {
        self.formModel.value = change[@"new"];
    }
}

- (void)dealloc {
    if ([self.formModel isKindOfClass:[HK_TextFieldFormModel class]]) {
        [self.textField removeObserver:self forKeyPath:@"text"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 键盘监听
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = [textField convertRect:self.textField.frame toView:nil];
    if ([self.delegate respondsToSelector:@selector(contentStartEditBlock:)]) {
        [self.delegate contentStartEditBlock:frame];
    }
}

#pragma mark UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark UITextDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.formModel.value = textView.text;
    return YES;
}


@end
