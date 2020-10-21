//
//  CSVideoReverse.h
//
//  Created by Chris Sung on 3/5/17.
//  Copyright © 2017 chrissung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol CSVideoReverseDelegate <NSObject>
@optional
- (void)didFinishReverse:(bool)success withError:(NSError *)error;
@end

@interface CSVideoReverse : NSObject {

}

/*---------------------------------------------------------------*/
// Properties
/*---------------------------------------------------------------*/

@property (weak, nonatomic) id<CSVideoReverseDelegate> delegate;

@property (readwrite, nonatomic) BOOL showDebug;

@property (strong, nonatomic) NSDictionary* readerOutputSettings;


/*---------------------------------------------------------------*/
// Methods
/*---------------------------------------------------------------*/

- (void)reverseVideoAtPath:(NSURL *)inputUrl outputPath:(NSString *)outputPath;

@end

