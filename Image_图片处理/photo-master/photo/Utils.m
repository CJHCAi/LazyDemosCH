//
//  Utils.m
//  ColorfulFan-iOS
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 ihunuo. All rights reserved.
//

#import "Utils.h"
#define PI 3.1415926
#define WIDTHNUM 140
#define HEIGHTNUM 24
#define RADIUS 20
@implementation Utils
+ (void*)getImageData:(UIImage*)image
{
    void* imageData;
    if (imageData == NULL)
        imageData = malloc(4 * image.size.width * image.size.height);
    
    CGColorSpaceRef cref = CGColorSpaceCreateDeviceRGB();
    CGContextRef gc = CGBitmapContextCreate(imageData,
                                            image.size.width,image.size.height,
                                            8,image.size.width*4,
                                            cref,kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(cref);
    UIGraphicsPushContext(gc);
    
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    
    UIGraphicsPopContext();
    CGContextRelease(gc);
    
    return imageData;
}

+ (UIColor*) getImageColorFromPostion:(UIImage *)img :(CGPoint)point{
    NSInteger w = img.size.width;  // 图片宽
    // 图片高
    // 获取图片的像素数据
    CGImageRef imageRef = [img CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytePerPiexl = 4;
    long bytesPerRow = bytePerPiexl * width;
    int bitsPerComponent = 8;
    
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    unsigned char* pixelData = rawData;
    NSInteger y = (width/w)*point.x;
    NSInteger x = (width/w)*(img.size.height - point.y);
    UInt8 red = pixelData[(x * width + y) * 4];
    UInt8 gree = pixelData[(x * width + y) * 4+1];
    UInt8 blue = pixelData[(x * width + y) * 4+2];
    UInt8 alpha = pixelData[(x * width + y) * 4+3];
    NSLog(@"r=%d,g=%d,b=%d",red,gree,blue);
    UIColor* color = [[UIColor alloc] initWithRed:red green:gree blue:blue alpha:alpha];
    return color;
}


+ (NSNumber*) getImageColorDataFromPostion:(UIImage *)img :(CGPoint)point{
    NSInteger w = img.size.width;  // 图片宽
    // 图片高
    // 获取图片的像素数据
    CGImageRef imageRef = [img CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytePerPiexl = 4;
    long bytesPerRow = bytePerPiexl * width;
    int bitsPerComponent = 8;
    
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    unsigned char* pixelData = rawData;
    NSInteger y = (width/w)*point.x;
    NSInteger x = (width/w)*(img.size.height - point.y);
    UInt8 red = pixelData[(x * width + y) * 4];
    UInt8 gree = pixelData[(x * width + y) * 4+1];
    UInt8 blue = pixelData[(x * width + y) * 4+2];
    //UInt8 alpha = pixelData[(x * width + y) * 4+3];
    NSLog(@"r=%d,g=%d,b=%d",red,gree,blue);
    //UIColor* color = [[UIColor alloc] initWithRed:red green:gree blue:blue alpha:alpha];
    NSNumber* data = [self switchUint8:red :gree :blue];
    CFRelease(rawData);
    CFRelease(pixelData);
    return data;
}

+ (UIColor*) getRandomColor{
    UIColor* color;
    NSArray *colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor],[UIColor yellowColor],[UIColor whiteColor],[UIColor orangeColor],[UIColor magentaColor]];
    color = colors[arc4random()%7];
    return color;
}

+ (NSMutableArray*) getDotsColorFromImageInFan:(CGSize)size : (UIImage*)img
{
    NSMutableArray* pointColors = [[NSMutableArray alloc] init];
    CGPoint centerPoint = CGPointMake(size.width/2, size.height/2);
    float r = size.height/2;
    for (int i = 0; i < WIDTHNUM; i++) {
        for (int j = 0; j < HEIGHTNUM; j++) {
            float R = RADIUS + j*(r-RADIUS)/HEIGHTNUM;
            float radian = (2*PI/WIDTHNUM)*i;
            float angle = (PI/180)*radian;
            float x = cosf(radian)*R;
            float y = -sinf(radian)*R;
            CGPoint p1 = CGPointMake(x, y);
            CGPoint p = [self toAddPoint:p1 :centerPoint];
            UIColor* colorData = [self getImageColorFromPostion:img :p];
            [pointColors addObject:colorData];
        }
    }
    return pointColors;
}

+ (CGPoint) toAddPoint: (CGPoint) point1 : (CGPoint) point2{
    return CGPointMake(point1.x+point2.x, point2.y+point1.y);
}

#pragma mark 生成image

+ (UIImage *)makeImageWithView:(UIView *)view

{
    
    CGSize s = view.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (void) removeAllChildrenFromView:(UIView *)view{
    for(UIView *v in [view subviews])
    {
        [v removeFromSuperview];
    }
}

+ (NSNumber*) switchUint8:(int)r :(int)g :(int)b
{
    NSNumber* num;
    uint8_t data = 0;
//    NSNumber* numr = 256/r
    data = data|([[self colorToByte:b] intValue]<<0);
    data = data|([[self colorToByte:g] intValue]<<1);
    data = data|([[self colorToByte:r] intValue]<<2);
    num = [NSNumber numberWithInt:data];
    return num;
}

+ (NSNumber*) colorToByte:(int)color{
    NSNumber* num;
    if (color>=(256/2)) {
        num = [NSNumber numberWithInt:1];
    }else{
        num = [NSNumber numberWithInt:0];
    }
    return num;
}



+ (UInt8) change8Byte:(UInt8) data
{
    if (data>=(256/2)) {
        data = 255;
    }else{
        data = 0;
    }
    return data;
}




// Return a bitmap context using alpha/red/green/blue byte values
CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space");
        return NULL;
    }
    
    // allocate the bitmap & create context
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        printf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData, pixelsWide,pixelsHigh, 8, bitmapBytesPerRow,
                                     colorSpace, kCGImageAlphaPremultipliedLast);
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}


// Return Image Pixel data as an RGBA bitmap
unsigned char *RequestImagePixelData(UIImage *inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    if (cgctx == NULL)
        return NULL;
    CGRect rect = {{0,0},{size.width, size.height}};
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = CGBitmapContextGetData (cgctx);
    CGContextRelease(cgctx);
    return data;
}




#pragma mark -
+ (UIImage*)blackWhite:(UIImage*)inImage
{
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    CGImageRef inImageRef = [inImage CGImage];
    unsigned long w = CGImageGetWidth(inImageRef);
    unsigned long h = CGImageGetHeight(inImageRef);
    int wOff = 0;
    int pixOff = 0;
    for(GLuint y = 0;y< h;y++)
    {
        pixOff = wOff;
        for (GLuint x = 0; x<w;x++)
        {
            //int alpha = (unsigned char)imgPixel[pixOff];
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            imgPixel[pixOff] = [self change8Byte:red];
            imgPixel[pixOff+1] = [self change8Byte:green];
            imgPixel[pixOff+2] = [self change8Byte:blue];
            pixOff += 4;
        }
             wOff += w * 4;
             }
             NSInteger dataLength = w*h* 4;
             CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
             
             // prep the ingredients
             int bitsPerComponent = 8;
             int bitsPerPixel = 32;
             long bytesPerRow = 4 * w;
             CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
             CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
             CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
             // make the cgimage
             CGImageRef imageRef = CGImageCreate(w,   h,   bitsPerComponent,    bitsPerPixel,   bytesPerRow,
                                                 colorSpaceRef,bitmapInfo,provider,NULL, NO, renderingIntent);
             UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
             CFRelease(imageRef);
             CGColorSpaceRelease(colorSpaceRef);
             CGDataProviderRelease(provider);
             return my_Image;
}

+(UIImage*)CropImage:(UIImage*)photoimage
{
    CGImageRef imgRef =photoimage.CGImage;
    CGImageRef finalImgRef=CGImageCreateWithImageInRect(imgRef,CGRectMake(0, photoimage.size.height/2, photoimage.size.width/2, photoimage.size.height/2));
    return [UIImage imageWithCGImage:finalImgRef];
}


@end
