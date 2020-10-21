//
//  GCImageData.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 6/7/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCImageData : NSObject

@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSString *extension;

- (id)initWithData:(NSData *)data extension:(NSString *)extension;

+ (instancetype)imageData:(NSData *)data extension:(NSString *)extension;
+ (instancetype)dataWithUIImage:(UIImage *)image;

@end
