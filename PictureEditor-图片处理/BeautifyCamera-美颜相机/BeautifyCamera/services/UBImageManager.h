//
//  UBImageManager.h
//  BeautifyCamera
//
//  Created by sky on 2017/1/18.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UBImageManager : NSObject
+(instancetype) manager;

-(NSString *) storeImage:(UIImage *) image;

-(NSArray *) listImageFilePath;

-(NSString *)storePath;

-(UIImage *) loadImage:(NSString *) name;

-(BOOL) deleteImage: (NSString *) filename;
@end
