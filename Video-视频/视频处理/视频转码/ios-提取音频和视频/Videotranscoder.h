
    #import <Foundation/Foundation.h>
    #import <AVFoundation/AVFoundation.h>
    #import <AssetsLibrary/ALAssetsLibrary.h>
    #import <MediaPlayer/MediaPlayer.h>

    #import <Cordova/CDV.h>

    @interface Videotranscoder : CDVPlugin{
    }

    - (void) transcode:(CDVInvokedUrlCommand*)command;
    - (void) generateAudio:(AVURLAsset*)asset :(NSString*)audioOutput :(void (^)(void))completionBlock;
    - (void) generateVideo:(AVURLAsset*)asset :(NSString*)videoOutput :(void (^)(void))completionBlock;

    @end
