
#import "MIMovieVideoSampleAccessor.h"
#import "MICMSampleBuffer.h"

// Maximu number sample steps before we create a new AVAssetReader.
static const NSInteger kMaxNumberOfSteps = 35;


#pragma mark Private Interface

@interface MIMovieVideoSampleAccessor ()

@property (assign) CMTime assetDuration;
// Updated for each new sample. Overloading public readonly versions
@property (assign) CMTime currentTime;
@property (strong) MICMSampleBuffer *currentBuffer;

// Is valid
@property (readonly) BOOL isReady;

// Captures initializations.

@property (copy, readonly) AVURLAsset *_movie;
@property (copy, readonly) NSArray *_tracks; // [AVAssetTracks]
@property (copy, readonly) NSDictionary *_videoSettings;
@property (copy, readonly) AVVideoComposition *_videoComposition;

// Recreated whenever needed.
@property (strong) AVAssetReader *_reader;
@property (strong) AVAssetReaderOutput *_readerOutput;

@property (readonly, assign) Float64 _frameDuration;

// Returns YES on success otherwise NO.
- (BOOL)_updateAssetReaderStartingWithTime:(CMTime)startTime;

// Determines the frame duration, taking the smallest frame duration of all tracks.
+ (Float64)_frameDurationTracks:(NSArray *)tracks;

@end

#pragma mark Local helper functions

#if TARGET_OS_IPHONE
NSDictionary *DefaultVideoSettings()
{
    static NSDictionary *videoSettings;
    if (!videoSettings)
    {
        videoSettings = @{
          (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
          (id)kCVPixelBufferCGImageCompatibilityKey : @YES,
          (id)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES
                        };
    }
    return videoSettings;
}
#else
NSDictionary *DefaultVideoSettings()
{
    static NSDictionary *videoSettings;
    if (!videoSettings)
    {
        videoSettings = @{
        (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32ARGB),
        (id)kCVPixelBufferCGImageCompatibilityKey : @YES,
        (id)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES
                          };
    }
    return videoSettings;
}
#endif

#pragma mark -
#pragma mark CLASS MIMovieVideoSampleAccessor implementation

@implementation MIMovieVideoSampleAccessor

#pragma mark Private Class Methods

+ (Float64)_frameDurationTracks:(NSArray *)tracks
{
    AVAssetTrack *first = tracks.firstObject;
    Float64 nominalRate = first.nominalFrameRate;
    for (AVAssetTrack *track in tracks)
    {
        Float64 tempRate = track.nominalFrameRate;
        if (tempRate > nominalRate)
        {
            nominalRate = tempRate;
        }
    }
    Float64 durationInSeconds = 1.0 / nominalRate;
    return durationInSeconds;
}

#pragma mark Private Instance Methods

- (BOOL)_updateAssetReaderStartingWithTime:(CMTime)startTime
{
    self.currentBuffer = nil;
    if (self._reader)
    {
        [self._reader cancelReading];
    }
    self._reader = nil;
    self._readerOutput = nil;
    
    if (!self->__movie)
    {
        return NO;
    }
    
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:self._movie
                                                           error:nil];
    if (!reader)
    {
        return NO;
    }
    
    AVAssetReaderVideoCompositionOutput *vidComp;
    vidComp = [AVAssetReaderVideoCompositionOutput
               assetReaderVideoCompositionOutputWithVideoTracks:self._tracks
               videoSettings:self._videoSettings];
    
    vidComp.videoComposition = self._videoComposition;
    if ([reader canAddOutput:vidComp])
    {
        [reader addOutput:vidComp];
    }
    else
    {
        // Not been able to add outputs when all inputs look good. Mark broken.
        self->__movie = nil;
        return NO;
    }
    
    // If the start time is at the end of the movie, then perhaps the user
    // just wants the very last frame. But copy next sample buffer will
    // not return a sample buffer if the reading time is at the end of the
    // movie. If that is the case remove the duration of one sample from
    // the start time. This will provide access to the very last frame.
    CMTimeRange timeRange;
    if (CMTimeCompare(startTime, self._movie.duration) == 0)
    {
        startTime = CMTimeSubtract(startTime,
                        CMTimeMakeWithSeconds(self._frameDuration, 9000));
    }
    
    timeRange = CMTimeRangeFromTimeToTime(startTime, self._movie.duration);
    reader.timeRange = timeRange;
    if ([reader startReading])
    {
        self._reader = reader;
        self._readerOutput = vidComp;
    }
    else
    {
        // Not been able to read samples when all inputs look good. Mark broken.
        self->__movie = nil;
    }
    return self.isReady;
}

#pragma mark Public Instance Methods

- (instancetype)initWithMovie:(AVURLAsset *)movie
             firstSampleTime:(CMTime)firstTime
                      tracks:(NSArray *)tracks
               videoSettings:(NSDictionary *)videoSettings
            videoComposition:(AVVideoComposition *)composition
{
    self = [super init];
    if (!self)
    {
        return self;
    }

    if (!movie)
    {
        self = nil;
        return self;
    }

    CMTimeRange movieTimeRange = CMTimeRangeMake(kCMTimeZero, movie.duration);
    if (!CMTimeRangeContainsTime(movieTimeRange, firstTime))
    {
        self = nil;
        return self;
    }

    if (!tracks)
    {
        tracks = [movie tracksWithMediaType:AVMediaTypeVideo];
    }
    
    if (!(tracks && [tracks isKindOfClass:[NSArray class]] && tracks.count))
    {
        self = nil;
        return self;
    }

    if (!videoSettings)
    {
        videoSettings = DefaultVideoSettings();
    }
    
    if (!composition)
    {
        composition = [AVVideoComposition
                                videoCompositionWithPropertiesOfAsset:movie];
    }

    self.assetDuration = movie.duration;
    
    self->__movie = movie.copy;
    self->__tracks = tracks.copy;
    self->__videoSettings = videoSettings.copy;
    self->__videoComposition = composition.copy;
    self->_currentTime = firstTime;
    Float64 duration = [MIMovieVideoSampleAccessor _frameDurationTracks:tracks];
    self->__frameDuration = duration;
    return self;
}

- (void)dealloc
{
    if (self->__reader)
    {
        [self->__reader cancelReading];
    }
}

- (BOOL)isReady
{
    return self._reader && self._readerOutput && self._movie &&
           self._tracks && self._videoSettings && self._videoComposition;
}

- (BOOL)isBroken
{
    return !(self._movie && self._tracks && self._videoSettings &&
             self._videoComposition);
}

- (BOOL)equalTracks:(NSArray *)tracks // [AVAssetTrack]
{
    if (!(tracks && [tracks isKindOfClass:[NSArray  class]]))
    {
        return NO;
    }
    
    if (tracks.count != self._tracks.count)
    {
        return NO;
    }

    // Not just same tracks, but the track order must be the same in both.
    size_t index = 0;
    for (AVAssetTrack *localTrack in self._tracks)
    {
        AVAssetTrack *track = tracks[index++];
        if (localTrack.trackID != track.trackID)
            return NO;
    }
    return YES;
}

- (MICMSampleBuffer *)nextSampleBuffer
{
    self.currentBuffer = nil;
    if (!self.isReady)
    {
        if (CMTIME_IS_INVALID(self.currentTime))
        {
            return nil;
        }
        
        if (![self _updateAssetReaderStartingWithTime:self.currentTime])
        {
            // make sample accessor broken.
            self->__movie = nil;
            return nil;
        }
    }
    
    CMSampleBufferRef sample = [self._readerOutput copyNextSampleBuffer];
    if (!sample)
    {
        self._reader = nil;
        self._readerOutput = nil;
        self->__movie = nil; // Invalidate the frane accessor.
        return nil;
    }

    MICMSampleBuffer *buffer;
    buffer = [[MICMSampleBuffer alloc] initWithCMSampleBuffer:sample];
    self.currentTime = CMSampleBufferGetPresentationTimeStamp(sample);
    CFRelease(sample);
    self.currentBuffer = buffer;
    return buffer;
}

- (MICMSampleBuffer *)sampleBufferAtTime:(CMTime)time
{
    self.currentBuffer = nil;
    if (CMTIME_IS_INVALID(time))
    {
        return nil;
    }

    // We have no use for a negative time.
    if (CMTimeCompare(time, kCMTimeZero) == -1)
    {
        return nil;
    }

    // If we don't have enough info to create a new reader then bail.
    if (self.isBroken)
    {
        return nil;
    }

    // We have no use for a time after the end of the movie.
    if (CMTimeCompare(time, self._movie.duration) == 1)
    {
        return nil;
    }

    // If the asset reader is not setup then try and set it up.
    if (!self.isReady)
    {
        if (!self.isBroken)
        {
            if ([self _updateAssetReaderStartingWithTime:time])
            {
                return [self nextSampleBuffer];
            }
        }
        return nil;
    }
    
    // If the current time is invalid, then try updating asset reader.
    if (CMTIME_IS_INVALID(self.currentTime))
    {
        if ([self _updateAssetReaderStartingWithTime:time])
        {
            return [self nextSampleBuffer];
        }
        return nil;
    }

    // If sample time requested is before current time then update asset reader
    if (CMTimeCompare(time, self.currentTime) == -1)
    {
        if ([self _updateAssetReaderStartingWithTime:time])
        {
            return [self nextSampleBuffer];
        }
        return nil;
    }
    
    // If the request time is too far in the future using current asset reader.
    // Create a new asset reader starting with the requested time.
    Float64 timeDiff = CMTimeGetSeconds(CMTimeSubtract(time, self.currentTime));
    int steps = timeDiff / self._frameDuration;
    if (steps > kMaxNumberOfSteps)
    {
        if ([self _updateAssetReaderStartingWithTime:time])
        {
            return [self nextSampleBuffer];
        }
        return nil;
    }
    
    // In case the current sample buffer is the one we want, return it.
    if (self.isReady && CMTimeCompare(time, self.currentTime) == 0 &&
        self.currentBuffer)
    {
        return self.currentBuffer;
    }
    
    MICMSampleBuffer *buffer = [self nextSampleBuffer];
    if (!buffer)
    {
        return nil;
    }

    // If current time is greater or equal to desired then we've got it.
    // Greater than or equal to is the same as not less than.
    // If current time is not less than time requested then we've got it. Return.
    if (!(CMTimeCompare(self.currentTime, time) == -1))
    {
        return buffer;
    }

    CMTime frameDuration = CMTimeMakeWithSeconds(self._frameDuration, 9000);

    // The plan is to iterate through max twice the number of estimated steps
    // and then break when we find the first sample which is at the same time
    // or immediately after the sample we want.
    steps *= 2;
    while (steps > 0)
    {
        steps--;
        MICMSampleBuffer *newBuf = [self nextSampleBuffer];
        if (!newBuf)
        {
            // If we failed to get a sample then relax requirements on previous
            // buffer, just in case it was immediately before the frame we needed.
            CMTime temp = CMTimeAdd(self.currentTime, frameDuration);
            if (!(CMTimeCompare(temp, time) == -1))
            {
                return buffer;
            }
            else
            {
                return nil;
            }
        }

        // If current time is equal to or after time then return the buffer.
        // greater than or equal to is the same as not less than.
        if (!(CMTimeCompare(self.currentTime, time) == -1))
        {
            return newBuf;
        }
        buffer = newBuf;
    }
    
    return nil;
}

@end
