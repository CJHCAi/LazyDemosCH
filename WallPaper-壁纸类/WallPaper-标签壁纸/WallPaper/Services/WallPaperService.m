//
//  WallPaperService.m
//  WallPaper
//
//  Created by Never on 2017/2/10.
//  Copyright © 2017年 Never. All rights reserved.
//

#import "WallPaperService.h"
#import "WallPaper.h"
#import <AFNetworking.h>

@implementation WallPaperService

+(void)requestWallpapersFromURL:(NSURL *)url completion:(WallpapersCompletion)completion{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data.length && !connectionError) {
            
            NSArray *wallpapers = [self parse:data];
            
            completion(wallpapers,YES);
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取缩略图失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

            completion(nil,NO);
        }
    }];
}

+ (NSArray *)parse:(NSData *)data{

    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *thumbSection = [self stringByExtractingFrom:@"<section class=\"thumb-listing-page\">" to:@"</section>" in:html];
    NSArray *thumbStrings = [thumbSection componentsSeparatedByString:@"<li><figure"];
    NSMutableArray *wallpapers = [NSMutableArray array];
    
    for (NSString *thumbString in thumbStrings) {
        NSString *thumbnail = [self stringByExtractingFrom:@"data-src=\"" to:@"\"" in:thumbString];
        NSString *detail = [self stringByExtractingFrom:@"href=\"" to:@"\"" in:thumbString];
        if (thumbnail && detail) {
            //https://alpha.wallhaven.cc/wallpaper/69739
            //
            NSString *fullUrl = nil;
            if ([detail hasPrefix:@"https://alpha.wallhaven.cc/wallpaper/"]) {
                fullUrl = [NSString stringWithFormat:@"https://alpha.wallhaven.cc/wallpapers/full/wallhaven-%@.jpg",[detail substringFromIndex:37]];
            }
            WallPaper *wallpaper = [[WallPaper alloc] init];
            wallpaper.thumbnail = [NSURL URLWithString:thumbnail];
            wallpaper.detail = [NSURL URLWithString:detail];
            wallpaper.fullSize = [NSURL URLWithString:fullUrl];
            [wallpapers addObject:wallpaper];
        }
    }
    return [wallpapers copy];
}

+ (NSString *)stringByExtractingFrom:(NSString *)startString to:(NSString *)endString in:(NSString *)source{
    NSRange startRange = [source rangeOfString:startString];
    if (startRange.length) {
        NSUInteger location = startRange.length + startRange.location;
        NSRange endRange = [source rangeOfString:endString
                                         options:0
                                           range:NSMakeRange(location, source.length-location)];
        if (endRange.length) {
            return [source substringWithRange:NSMakeRange(location,endRange.location-location)];
        }
    }
    return nil;
}




@end
