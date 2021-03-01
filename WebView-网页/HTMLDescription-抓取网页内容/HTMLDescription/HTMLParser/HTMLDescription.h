//
//  HTMLDescription.h
//  TopsTechLoop
//
//  Created by 刘继新 on 2017/9/12.
//  Copyright © 2017年 TopsTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParser.h"

@interface HTMLModel : NSObject

- (instancetype)initWithHTMLParser:(HTMLParser *)parser url:(NSURL *)url;

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *coverURL;

@end


@interface HTMLDescription : NSObject

+ (void)captureHTMLDescriptionWithURL:(NSURL *)url complete:(void (^)(HTMLModel *data, NSError *error))complete;

@end
