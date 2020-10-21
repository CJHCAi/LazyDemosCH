//
//  Gif.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/4/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface Gif : NSObject <NSCoding>

@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *caption;
@property (nonatomic) UIImage *gifImage;
@property (nonatomic) NSURL *videoURL;
@property (nonatomic) NSData *gifData;

-(instancetype)initWithGifURL: (NSURL*)url videoURL:(NSURL*)videoURL caption:(NSString*)caption;
-(instancetype)initWithName:(NSString*)name;
@end
