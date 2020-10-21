//
// QR Code Generator - generates UIImage from NSString
//
// Copyright (C) 2012 http://moqod.com Andrew Kopanev <andrew@moqod.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
// of the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//

#import "QRCodeGenerator.h"

enum {
	qr_margin = 3
};

@implementation QRCodeGenerator

+ (void)drawQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size {
	unsigned char *data = 0;
	int width;
	data = code->data;
	width = code->width;
	float zoom = (double)size / (code->width + 2.0 * qr_margin);
	CGRect rectDraw = CGRectMake(0, 0, zoom, zoom);
	
	// draw
    
    UIColor * color = [UIColor blackColor];
//    UIColor * color = RGB(245, 148, 50);
    
	CGContextSetFillColor(ctx, CGColorGetComponents(color.CGColor));
	for(int i = 0; i < width; ++i) {
		for(int j = 0; j < width; ++j) {
			if(*data & 1) {
				rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
				CGContextAddRect(ctx, rectDraw);
			}
			++data;
		}
	}
	CGContextFillPath(ctx);
}

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size {
	if (![string length]) {
		return nil;
	}
	
	QRcode *code = QRcode_encodeString([string UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
	if (!code) {
		return nil;
	}
	
	// create context
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace, kCGImageAlphaPremultipliedLast);
	
	CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -size);
	CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, -1);
	CGContextConcatCTM(ctx, CGAffineTransformConcat(translateTransform, scaleTransform));
	
	// draw QR on this context	
	[QRCodeGenerator drawQRCode:code context:ctx size:size];
	
	// get image
	CGImageRef qrCGImage = CGBitmapContextCreateImage(ctx);
	UIImage * qrImage = [UIImage imageWithCGImage:qrCGImage];
	
	// some releases
	CGContextRelease(ctx);
	CGImageRelease(qrCGImage);
	CGColorSpaceRelease(colorSpace);
	QRcode_free(code);
	
	return qrImage;
}

+(UIImage*)qrImageForString:(NSString *)string imageSize:(CGFloat)size Topimg:(UIImage *)topimg withPointType:(QRPointType)pointType withPositionType:(QRPositionType)positionType withPositionColor:(UIColor *)positionColor withCenterColor:(UIColor *)centerColor{
    
    if (![string length]) {
        return nil;
    }
    
    QRcode *code = QRcode_encodeString([string UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    if (!code) {
        return nil;
    }
    
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -size);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, -1);
    CGContextConcatCTM(ctx, CGAffineTransformConcat(translateTransform, scaleTransform));
    
    // draw QR on this context
    [QRCodeGenerator drawQRCode:code context:ctx size:size withPointType:pointType withPositionType:positionType withPositionColor:positionColor withCenterColor:centerColor];
    
    // get image
    CGImageRef qrCGImage = CGBitmapContextCreateImage(ctx);
    UIImage * qrImage = [UIImage imageWithCGImage:qrCGImage];
    
    if(topimg)
    {
        UIGraphicsBeginImageContext(qrImage.size);
        
        //Draw image2
        [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
        
        //Draw image1
        float r=qrImage.size.width*35/240;
        [topimg drawInRect:CGRectMake((qrImage.size.width-r)/2, (qrImage.size.height-r)/2 ,r, r)];
        
        qrImage=UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    // some releases
    CGContextRelease(ctx);
    CGImageRelease(qrCGImage);
    CGColorSpaceRelease(colorSpace);
    QRcode_free(code);
    
    return qrImage;
    
}

+ (void)drawQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size withPointType:(QRPointType)pointType withPositionType:(QRPositionType)positionType withPositionColor:(UIColor *)positionColor withCenterColor:(UIColor *)centerColor{
    unsigned char *data = 0;
    int width;
    data = code->data;
    width = code->width;
    float zoom = (double)size / (code->width + 2.0 * qr_margin);
    CGRect rectDraw = CGRectMake(0, 0, zoom, zoom);
    
    // draw
    const CGFloat *components;
    if (positionColor) {
        
        components = CGColorGetComponents(positionColor.CGColor);
    }else {
        components = CGColorGetComponents([UIColor blackColor].CGColor);
    }
    
    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], 1.0);
   // NSLog(@"aad :%f  bbd :%f   ccd:%f",components[0],components[1],components[2]);
    
    //加方法中调用减方法需要实例化
    QRCodeGenerator * qrCode = [[QRCodeGenerator alloc] init];
    
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                                
                if (positionType == QRPositionNormal) {
                    if ((i>=0 && i<=6 && j>=0 && j<=6) || (i>=0 && i<=6 && j>=width-7-1 && j<=width-1) || (i>=width-7-1 && i<=width-1 && j>=0 && j<=6)) {
                        
                        if (![qrCode compareRGBAColor1:positionColor withColor2:centerColor]) {
                            
                            components = CGColorGetComponents(positionColor.CGColor);
                            CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], 1.0);
                            CGContextAddRect(ctx, rectDraw);
                            CGContextFillRect(ctx, rectDraw);
                            
                        }else{
                            
                            CGContextAddRect(ctx, rectDraw);
                        }
                       
                        
                    }else {
                        
                        switch (pointType) {
                            case QRPointRect:
                                
                                if (![qrCode compareRGBAColor1:positionColor withColor2:centerColor]) {
                                    
                                    components = CGColorGetComponents(centerColor.CGColor);
                                    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], 1.0);
                                    CGContextAddRect(ctx, rectDraw);
                                    CGContextFillRect(ctx, rectDraw);
                                    
                                }else{
                                    
                                    CGContextAddRect(ctx, rectDraw);
                                }
                                
                                break;
                            case QRPointRound:
                                
                                if (![qrCode compareRGBAColor1:positionColor withColor2:centerColor]) {
                                   
                                    components = CGColorGetComponents(centerColor.CGColor);
                                    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], 1.0);
                                    CGContextAddEllipseInRect(ctx, rectDraw);
                                    CGContextFillEllipseInRect(ctx, rectDraw);
                                }
                                else{
                                    
                                    CGContextAddEllipseInRect(ctx, rectDraw);
                                }
                                
                                break;
                            default:
                                break;
                        }
                        
                    }
                }else if(positionType == QRPositionRound) {
                    
                    if ((i>=0 && i<=6 && j>=0 && j<=6) || (i>=0 && i<=6 && j>=width-7-1 && j<=width-1) || (i>=width-7-1 && i<=width-1 && j>=0 && j<=6)) {
                        
                        if (![qrCode compareRGBAColor1:positionColor withColor2:centerColor]) {
                            
                            components = CGColorGetComponents(positionColor.CGColor);
                            CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], 1.0);
                            CGContextAddEllipseInRect(ctx, rectDraw);
                            CGContextFillEllipseInRect(ctx, rectDraw);
                        }else{
                            
                            CGContextAddEllipseInRect(ctx, rectDraw);
                        }
                        
                    }else {
                        
                        switch (pointType) {
                            case QRPointRect:
            
                                if (![qrCode compareRGBAColor1:positionColor withColor2:centerColor]) {
                                    
                                    components = CGColorGetComponents(centerColor.CGColor);
                                    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], 1.0);
                                    CGContextAddRect(ctx, rectDraw);
                                    CGContextFillRect(ctx, rectDraw);
                                }else{
                                    
                                   CGContextAddRect(ctx, rectDraw);
                                }
                                
                                break;
                            case QRPointRound:
                                
                                if(![qrCode compareRGBAColor1:positionColor withColor2:centerColor]) {
                                    
                                    components = CGColorGetComponents(centerColor.CGColor);
                                    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], 1.0);
                                    CGContextAddEllipseInRect(ctx, rectDraw);
                                    CGContextFillEllipseInRect(ctx, rectDraw);
                                }else{
                                    
                                    CGContextAddEllipseInRect(ctx, rectDraw);
                                }
                                
                                break;
                            default:
                                break;
                        }
                        
                    }
                }
            }
            ++data;
        }
    }
    
    CGContextFillPath(ctx);
}

- (BOOL)compareRGBAColor1:(UIColor *)color1 withColor2:(UIColor *)color2 {
    
    CGFloat red1,red2,green1,green2,blue1,blue2,alpha1,alpha2;
    //取出color1的背景颜色的RGBA值
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    //取出color2的背景颜色的RGBA值
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
//    NSLog(@"1:%f %f %f %f",red1,green1,blue1,alpha1);
//    NSLog(@"2:%f %f %f %f",red2,green2,blue2,alpha2);
    
    if ((red1 == red2)&&(green1 == green2)&&(blue1 == blue2)&&(alpha1 == alpha2)) {
        return YES;
    } else {
        return NO;
    }
}

@end
