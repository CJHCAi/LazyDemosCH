//
//  ImgViewController.h
//  WYMultimediaDemo
//
//  Created by Mac mini on 16/7/21.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgViewController : UIViewController

/**
 *  1. 针对我们通常使用的 iPhone 相册里几百K的图片, 我们使用 UIImageJPEGRepresentation(源图片, 0.5) 对图片进行压缩基本上已经能够满足要求了, 这里压缩系数选择 0.5 的话, 压缩后图片的大小大概会变为原来的 1 / 10, 而清晰度几乎看不出变化.
    2. 但是这种压缩方法有一个缺点就是存在压缩下限, 也就是说如果有一张很大的图片比如说 10 几兆的图片, 那么无论压缩系数写多小, 压缩图片在达到压缩下限的时候就不会再压缩了, 得到的结果很可能是压缩图片的大小有 2, 3 兆, 还是达不到我们的要求. 那么针对这种情况, 我们还有一种图片压缩的方法, 就是通过 img 的一个 drawInRect 的方法来改变这个图片的原始分辨率来达到压缩图片的效果, 具体的代码如下 : 
 
         // 传进去源图片和目标横向分辨率
         - (UIImage *)compressImgWithSourceImg:(UIImage *)sourceImg
                                   TargetWidth:(CGFloat)targetWidth {
         
             // 源图片的分辨率
             CGSize sourceImgSize = sourceImg.size;
             CGFloat sourceImgWidth = sourceImgSize.width;
             CGFloat sourceImgHeight = sourceImgSize.height;
             
             // 压缩图片的分辨率
             CGFloat compressImgWidth = targetWidth;
             CGFloat compressImgHeight = (targetWidth / sourceImgWidth) * sourceImgHeight;
             
             // 压缩图片
             // 把预设的图片分辨率设置为当前图片上下文
             UIGraphicsBeginImageContext(CGSizeMake(compressImgWidth, compressImgHeight));
             // drawInRect 改变图片的像素
             [sourceImg drawInRect:CGRectMake(0, 0, compressImgWidth, compressImgHeight)];
             // 从当前图片上下文中创建新图片
             UIImage *compressImg = UIGraphicsGetImageFromCurrentImageContext();
             // 使当前图片上下文出堆栈
             UIGraphicsEndImageContext();
             
             return compressImg;
         }
 */


@end
