//
//  HomeCollectionViewCell.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/22.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self.nicknameLabel setFont:[UIFont fontWithName:@"HannotateSC-W5" size:16]];
    [self.nameLabel setFont:[UIFont fontWithName:@"HannotateSC-W5" size:18]];

    self.textView = [[HomeTextView alloc]initWithFrame:CGRectMake(0, 85, kScreenW - kMargin * 2 - 16, MAXFLOAT)];
    [self addSubview:self.textView];
}

-(void)setResult:(HomeResult *)result{
    _result = result;
    //headphoto访问不到，就用了icon
    //    NSURL *url = [NSURL URLWithString:result.work.user.headphoto];
    NSURL *url = [NSURL URLWithString:result.work.song.icon];
    [self.headphotoIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headphotoIV.image = [self circleImage:self.headphotoIV.image withParam:0];
    }];
//    self.headphotoIV.image = [self circleImage:self.headphotoIV.image withParam:0];
    //可能是太耗资源产生的bug
//    self.headphotoIV.layer.cornerRadius = self.headphotoIV.frame.size.width / 2;
//    self.headphotoIV.layer.masksToBounds = YES;
    
}

-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    
    CGContextSetLineWidth(context,2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
    
}
@end
