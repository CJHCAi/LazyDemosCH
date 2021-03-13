#import "UIImage+DDYExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

#define DDY_FOUR_CC(c1,c2,c3,c4) ((uint32_t)(((c4) << 24) | ((c3) << 16) | ((c2) << 8) | (c1)))
#define DDY_TWO_CC(c1,c2) ((uint16_t)(((c2) << 8) | (c1)))

@implementation UIImage (DDYExtension)

#pragma mark - 绘制
#pragma mark 绘制矩形图片
+ (UIImage *)ddy_RectImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 绘制矩形框
+ (UIImage *)ddy_RectBorderWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 绘制圆形图片
+ (UIImage *)ddy_CircleImageWithColor:(UIColor *)color radius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, radius*2.0, radius*2.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillEllipseInRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 绘制圆形框
+ (UIImage *)ddy_CircleBorderWithColor:(UIColor *)color radius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, radius*2.0, radius*2.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context, radius, radius, radius-1, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextStrokePath(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 绘制渐变色图片
+ (UIImage *)ddy_GradientImage:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    rect.size.height += 20;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(__bridge id)(startColor.CGColor), (__bridge id)(endColor.CGColor)];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path.CGPath);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    return image;
}

#pragma mark 获取图片类型
+ (DDYImageType)ddy_ImageDetectType:(NSData *)imageData {
    CFDataRef data = (__bridge CFDataRef)imageData;
    if (!data) return DDYImageTypeUnknown;
    uint64_t length = CFDataGetLength(data);
    if (length < 16) return DDYImageTypeUnknown;
    
    const char *bytes = (char *)CFDataGetBytePtr(data);
    
    uint32_t magic4 = *((uint32_t *)bytes);
    switch (magic4) {
        case DDY_FOUR_CC(0x4D, 0x4D, 0x00, 0x2A): { // big endian TIFF
            return DDYImageTypeTIFF;
        } break;
            
        case DDY_FOUR_CC(0x49, 0x49, 0x2A, 0x00): { // little endian TIFF
            return DDYImageTypeTIFF;
        } break;
            
        case DDY_FOUR_CC(0x00, 0x00, 0x01, 0x00): { // ICO
            return DDYImageTypeICO;
        } break;
            
        case DDY_FOUR_CC(0x00, 0x00, 0x02, 0x00): { // CUR
            return DDYImageTypeICO;
        } break;
            
        case DDY_FOUR_CC('i', 'c', 'n', 's'): { // ICNS
            return DDYImageTypeICNS;
        } break;
            
        case DDY_FOUR_CC('G', 'I', 'F', '8'): { // GIF
            return DDYImageTypeGIF;
        } break;
            
        case DDY_FOUR_CC(0x89, 'P', 'N', 'G'): {  // PNG
            uint32_t tmp = *((uint32_t *)(bytes + 4));
            if (tmp == DDY_FOUR_CC('\r', '\n', 0x1A, '\n')) {
                return DDYImageTypePNG;
            }
        } break;
            
        case DDY_FOUR_CC('R', 'I', 'F', 'F'): { // WebP
            uint32_t tmp = *((uint32_t *)(bytes + 8));
            if (tmp == DDY_FOUR_CC('W', 'E', 'B', 'P')) {
                return DDYImageTypeWebP;
            }
        } break;
    }
    
    uint16_t magic2 = *((uint16_t *)bytes);
    switch (magic2) {
        case DDY_TWO_CC('B', 'A'):
        case DDY_TWO_CC('B', 'M'):
        case DDY_TWO_CC('I', 'C'):
        case DDY_TWO_CC('P', 'I'):
        case DDY_TWO_CC('C', 'I'):
        case DDY_TWO_CC('C', 'P'): { // BMP
            return DDYImageTypeBMP;
        }
        case DDY_TWO_CC(0xFF, 0x4F): { // JPEG2000
            return DDYImageTypeJPEG2000;
        }
    }
    // JPG             FF D8 FF
    if (memcmp(bytes,"\377\330\377",3) == 0) return DDYImageTypeJPEG;
    // JP2
    if (memcmp(bytes + 4, "\152\120\040\040\015", 5) == 0) return DDYImageTypeJPEG2000;

    return DDYImageTypeUnknown;
}

#pragma mark 获取图片元数据
+ (NSDictionary *)ddy_ImageMetaData:(NSData *)imageData {
    if (!imageData) return nil;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    CFRelease(source);
    NSDictionary *metaDataInfo = CFBridgingRelease(imageMetaData);
    return metaDataInfo;
}

#pragma mark 获取JPG格式图片元数据
- (NSDictionary *)ddy_JpgMetaData{
    return [UIImage ddy_ImageMetaData:UIImageJPEGRepresentation(self, 1.0)];
}
#pragma mark 获取PNG格式图片元数据
- (NSDictionary *)ddy_PngmetaData {
    return [UIImage ddy_ImageMetaData:UIImagePNGRepresentation(self)];
}

#pragma mark 改变亮度、饱和度、对比度
- (UIImage *)ddy_changeBright:(CGFloat)b saturation:(CGFloat)s contrast:(CGFloat)c {
    UIImage *myImage = self;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:myImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:superImage forKey:kCIInputImageKey];
    // 修改亮度   -1---1   数越大越亮
    if (b>=-1 && b<=1) { [filter setValue:[NSNumber numberWithFloat:b] forKey:@"inputBrightness"]; }
    // 修改饱和度  0---2
    if (s>=0 && s<=2) { [filter setValue:[NSNumber numberWithFloat:s] forKey:@"inputSaturation"]; }
    // 修改对比度  0---4
    if (c>=0 && c<=4) { [filter setValue:[NSNumber numberWithFloat:c] forKey:@"inputContrast"]; }
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
    myImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return myImage;
}

#pragma mark 改变图片亮度 [-1, 1] 数越大越亮
- (UIImage *)ddy_ChangeBright:(CGFloat)bright {
    return [self ddy_changeBright:bright saturation:-2 contrast:-2];
}

#pragma mark 改变图片饱和度 [0, 2]
- (UIImage *)ddy_ChangeSaturation:(CGFloat)saturation {
    return [self ddy_changeBright:-2  saturation:saturation contrast:-2];
}

#pragma mark 改变图片对比度 [0, 4]
- (UIImage *)ddy_ChangeContrast:(CGFloat)contrast {
    return [self ddy_changeBright:-2 saturation:-2 contrast:contrast];
}

#pragma mark 拍照后图片旋转或者颠倒解决
- (UIImage *)ddy_fixOrientation {
    UIImage *orignalImage = self;
    if (orignalImage.imageOrientation == UIImageOrientationUp)
        return orignalImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orignalImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, orignalImage.size.width, orignalImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, orignalImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, orignalImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (orignalImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, orignalImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, orignalImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, orignalImage.size.width, orignalImage.size.height,
                                             CGImageGetBitsPerComponent(orignalImage.CGImage), 0,
                                             CGImageGetColorSpace(orignalImage.CGImage),
                                             CGImageGetBitmapInfo(orignalImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (orignalImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,orignalImage.size.height,orignalImage.size.width), orignalImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,orignalImage.size.width,orignalImage.size.height), orignalImage.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 通过cgimage创建一个ciimage，用于滤镜处理的蓝本
// CIImage* ci = [CIImage imageWithCGImage:[imageV.image CGImage]];
// 通过url地址来获取一张图片，并创建ciimage用于滤镜处理的蓝本
// CIImage* ci1 = [CIImage imageWithContentsOfURL:nil];
// 通过nsdata获取一张图片，并创建ciimage用于滤镜处理的蓝本
// CIImage* ci2 = [CIImage imageWithData:nil];
// 通过cvpixel取得每一帧的图片，用于视频使用滤镜功能
// CIImage* ci3 = [CIImage imageWithCVPixelBuffer:nil];
#pragma mark 根据coreImage 滤镜名称为原图加滤镜
- (UIImage *)ddy_FilterWithFilterName:(NSString *)filterName {
    CIImage *ciImage = [CIImage imageWithCGImage:self.CGImage]; // 直接img.CIImage 是nil
    if (!filterName) return self;
    CIFilter *filter = [CIFilter filterWithName:filterName];
    if (!filter) return self;
    [filter setDefaults];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    CIImage *currentImage = filter.outputImage;
    if (!currentImage || CGRectIsEmpty(currentImage.extent)) return self;
    
    // 使用gpu渲染
    // NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    // [options setObject:[NSNull null] forKey:kCIContextWorkingColorSpace];
    // CIContext* context = [CIContext contextWithEAGLContext:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] options:options];
    // 使用cpu渲染
    CIContext* context = [CIContext contextWithOptions:nil];
    // 通过cicontext渲染产生新的图片，ciimage的extent属性相当于bounds属性，代表图片的大小
    CGImageRef filterimge = [context createCGImage:currentImage fromRect:currentImage.extent];
    UIImage *endImage = [UIImage imageWithCGImage:filterimge];
    CGImageRelease(filterimge);
    return endImage;
}

@end
