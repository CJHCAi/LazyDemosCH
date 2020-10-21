CSVideoReverse
==============

A simple Objective-C class for creating a reversed (silent) version of a video file. Reversal occurs in its own thread, input frames are read in passes to reduce memory usage, and a delegate can be called upon completion or error.

![Input video](https://github.com/chrissung/CSVideoReverse/blob/master/input.gif)

![Output video](https://github.com/chrissung/CSVideoReverse/blob/master/output.gif)

Usage Example
-------------
Create an instance of the class, set any custom reader settings, and call the main method with the `inputPath` of the video to be reversed, and the `outputPath` where the finished result will reside:

``` objective-c
NSString *inputPath = [[NSBundle mainBundle] pathForResource:@"input" ofType:@"mov"];

// create a path for our reversed output video
NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
outputPath = [documentsPath stringByAppendingFormat:@"/reversed.mov"];

// get instance of our reverse video class
CSVideoReverse *reverser = [[CSVideoReverse alloc] init];
reverser.delegate = self;

// if custom reader settings are desired
reverser.readerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey, nil];

// now start the reversal process
[reverser reverseVideoAtPath:inputPath outputPath:outputPath];
```

Then implement the delegate method of the class to get the result:

``` objective-c
#pragma mark CSVideoReverseDelegate Methods
- (void)didFinishReverse:(bool)success withError:(NSError *)error {
	if (!success) {
		NSLog(@"%s error: %@", __FUNCTION__, error.localizedDescription);
	}
	else {
		// show the reversed video located at outputPath
	}
}
```

Example Project
---------------
Build the XCode project at `example/CSVideoReverse.xcodeproj` to see it in action with reverse video playback - you may want to sub in your own .mov or .mp4 file in `example/CSVideoReverse/ViewController.m`.  At some point, I'll add a UIImagePickerController so you can simply choose from Camera Roll instead of having to reference an asset within the app bundle itself.

Licenses
--------

All source code is licensed under the [MIT-License](https://github.com/chrissung/CSVideoReverse/blob/master/LICENSE).

