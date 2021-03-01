//
//  ComposeTextParser.h
//  HTMLDescription
//
//  Created by 刘继新 on 2017/9/12.
//  Copyright © 2017年 TopsTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYText.h>

@protocol ComposeTextParserDelegate;
@interface ComposeTextParser : NSObject<YYTextParser>

@property (nonatomic, strong) NSString *parserURL;
@property (nonatomic, weak) id<ComposeTextParserDelegate> delegate;
@end

@protocol ComposeTextParserDelegate <NSObject>
- (void)composeTextParser:(ComposeTextParser *)parser discoverURL:(NSString *)url;
@end
