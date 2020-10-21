//
//
//

    #import <Cordova/CDV.h>
    #import "Videotranscoder.h"
    #import "AsyncBlockOperation.h"

    @implementation Videotranscoder

    - (void)transcode:(CDVInvokedUrlCommand*)command
    {
        // Check command.arguments here.

        [self.commandDelegate runInBackground:^{


            //CDVPluginResult* pluginResult = nil;

            //NSString* fileuri = [command.arguments objectAtIndex:0];

            //MY
            NSLog(@"[transcode]: called");
            NSString *inputFile = [command.arguments objectAtIndex:0];
            NSString *outputName = @"outputName";

            // remove file:// from the inputFile path if it is there
            inputFile = [[inputFile stringByReplacingOccurrencesOfString:@"file://" withString:@""] mutableCopy];

            // check file exists
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            if(![fileMgr fileExistsAtPath:inputFile]){
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"input file does not exist"] callbackId:command.callbackId];
                return;
            }
            NSLog(@"[transcode]: inputFile path: %@", inputFile);

            NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            // videoDir
            NSString *videoDir = [cacheDir stringByAppendingPathComponent:@"mp4"];
            if ([fileMgr createDirectoryAtPath:videoDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO){
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"failed to create video dir"] callbackId:command.callbackId];
                return;
            }
            NSString *videoOutput = [videoDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", outputName, @"mp4"]];

            // audioDir
            NSString *audioDir = [cacheDir stringByAppendingPathComponent:@"m4a"];
            if ([fileMgr createDirectoryAtPath:audioDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO){
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"failed to create audio dir"] callbackId:command.callbackId];
                return;
            }
            NSString *audioOutput = [audioDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", outputName, @"m4a"]];

            // create an AVURLAsset
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:inputFile] options:nil];

            NSOperationQueue *renderQueue = [NSOperationQueue new];
            renderQueue.maxConcurrentOperationCount = 1;

            // videoOutput add to queue
            [renderQueue addAsyncOperationWithBlock:^(dispatch_block_t completionHandler){
                [self generateVideo: asset: videoOutput: ^{
                    completionHandler();
                }];
            }];

            // audioOutput add to queue
            [renderQueue addAsyncOperationWithBlock:^(dispatch_block_t completionHandler){
                [self generateAudio: asset: audioOutput: ^{
                    completionHandler();
                }];
            }];

            // add onComplete to queue
            [renderQueue addAsyncOperationWithBlock:^(dispatch_block_t completionHandler){
                NSLog(@"[ProcessVideo]: All tasks complete");
                // TODO: check all files exist
                // TODO: if not, return error
                //               - also delete temp files
                //NSMutableDictionary* outputs = [NSMutableDictionary dictionary];
                CDVPluginResult* pluginResult = nil;
                //[outputs setValue:jpgDir forKey:@"seq"];
                //[outputs setValue:thumbOutput forKey:@"thumb"];
                //[outputs setValue:audioOutput forKey:@"audio"];
                //[outputs setValue:videoOutput forKey:@"video"];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:videoOutput];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

                // NSArray *results = [NSArray arrayWithObjects:outputs, nil];
                // [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:results] callbackId:command.callbackId];
                // completionHandler();
            }];
            NSLog(@"[ProcessVideo]: Waiting for tasks to complete");





            //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:inputFile];


/*
            if (fileuri != nil && [fileuri length] > 0) {

                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:fileuri];


            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            }
*/
            //[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }

    /**
     * generateVideo
     *
     * Generates a video output from an asset.
     *
     * @param AVURLAsset asset
     * @param NSString videoOutput
     * @param block completionBlock
     * @return void
     */
    - (void) generateVideo:(AVURLAsset*)asset :(NSString*)videoOutput :(void(^)(void))completionBlock {
        // delete video output if exists
        if ([[NSFileManager defaultManager] fileExistsAtPath:videoOutput]) {
            [[NSFileManager defaultManager] removeItemAtPath:videoOutput error:nil];
        }

        NSLog(@"[generateVideo]: 3. Video output starting: %@", videoOutput);

        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:asset presetName: AVAssetExportPreset640x480];

        exportSession.outputURL = [NSURL fileURLWithPath:videoOutput];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = NO;

        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusCompleted:
                      NSLog(@"[ProcessVideo]: 3. Video Output export Complete %d %@", exportSession.status, exportSession.error);
                    break;
                case AVAssetExportSessionStatusFailed:
                      NSLog(@"[ProcessVideo]: 3. Video output export failed: %@", [[exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"[ProcessVideo]: 3. Video output export canceled");
                    break;
                default:
                    NSLog(@"[ProcessVideo]: 3. Video output export default in switch");
                    break;
            }
            NSLog(@"[ProcessVideo]: 3. Video output finished");
            completionBlock();
        }];
    };



    /**
     * generateAudio
     *
     * Generates an audio output from an asset.
     *
     * @param AVURLAsset asset
     * @param NSString audioOutput
     * @param block completionBlock
     * @return void
     */
    - (void) generateAudio:(AVURLAsset*)asset :(NSString*)audioOutput :(void(^)(void))completionBlock {
        NSLog(@"[ProcessVideo]: 4. Audio Output starting: %@", audioOutput);

        // make sure there is an audio track
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeAudio];
        if ([tracks count] == 0){
          NSLog(@"[ProcessVideo]: 4. No audio present in asset, exiting");
          completionBlock();
          return;
        }

        // delete audio output if exists
        if ([[NSFileManager defaultManager] fileExistsAtPath:audioOutput]) {
            [[NSFileManager defaultManager] removeItemAtPath:audioOutput error:nil];
        }

        AVAssetExportSession *exportSession=[AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
        exportSession.outputURL=[NSURL fileURLWithPath:audioOutput];
        exportSession.outputFileType = AVFileTypeAppleM4A;

        // set time range
        CMTime start = CMTimeMakeWithSeconds(0.0, 600);
        CMTime duration = CMTimeMakeWithSeconds(asset.duration.value, 600);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;

        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (exportSession.status == AVAssetExportSessionStatusFailed) {
                NSLog(@"[ProcessVideo]: Audio output failed");
            }
            else {
                NSLog(@"[ProcessVideo]: AudioLocation : %@", audioOutput);
            }
            completionBlock();
        }];
    };


    @end
