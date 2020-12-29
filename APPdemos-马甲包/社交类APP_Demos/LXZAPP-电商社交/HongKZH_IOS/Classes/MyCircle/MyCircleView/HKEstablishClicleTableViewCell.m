//
//  HKEstablishClicleTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEstablishClicleTableViewCell.h"
#import "BGSTextViewWithPlaceholder.h"
#import "HKHKEstablishClicleParameters.h"
@interface HKEstablishClicleTableViewCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *categotyName;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet BGSTextViewWithPlaceholder *desc;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *verification;

@end

@implementation HKEstablishClicleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.desc.placeholder = @"请输入圈子简介";
    self.desc.delegate = self;
    [self.name addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    // Initialization code
}
-(void)textViewDidChange:(UITextView *)textView{
    self.parmeeter.introduction = textView.text;
}
-(void)passConTextChange:(UITextField*)textField{
    self.parmeeter.circleName = textField.text;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selecticon:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selctImage)]) {
        [self.delegate selctImage];
    }
}
- (IBAction)channel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectChannel)]) {
        [self.delegate selectChannel];
    }
}
- (IBAction)joinmode:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectJoin)]) {
        [self.delegate selectJoin];
    }
}
-(void)setParmeeter:(HKHKEstablishClicleParameters *)parmeeter{
    _parmeeter = parmeeter;
    self.categotyName.text = parmeeter.categoryName;
    self.name.text = parmeeter.circleName;
    self.desc.text = parmeeter.introduction;
    if (parmeeter.isValidate) {
        self.verification.text = @"需经过圈主同意";
    }else{
         self.verification.text = @"任何人可加入";
    }
    
    
}
-(void)setImage:(UIImage *)image{
    _image = image;
    self.iconImage.image = image;
}
@end
