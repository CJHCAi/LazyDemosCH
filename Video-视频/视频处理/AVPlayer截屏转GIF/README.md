# AVPlayerDemo
This is a Demo about AVPlayer. It can get the thumbnil image for the AVPlayer at the current time;
If you want to realize the function, you can do like this:

1  when you prepare something for play video With AVPlayer, you need to do something like following:

    //create playerItem

    playerItem  = [[AVPlayerItem alloc]initWithURL:url];

    //prepare parameter dictionary

    NSDictionary *settings = @{(id)kCVPixelBufferPixelFormatTypeKey: 
                                   [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                               };
    //creat the AVPlayerItemVideoOutput
    videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:settings];
    //add AVPlayerItemVideoOutput to playerItem
    [playerItem addOutput:videoOutput];
Next, you can get thumnil image follow this:

2  when you will get the thumbnil image for the AVPlayer which is palying ,just do like this

    if(player.currentItem.status == AVPlayerStatusReadyToPlay){
          //get the current time
          CMTime currentTime = player.currentItem.currentTime;
          //get the bufferRef for the current time
          CVPixelBufferRef buffer = [videoOutput copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
          //creat CIImage with the buffer
          CIImage *ciImage = [CIImage imageWithCVPixelBuffer:buffer];
          //create CGImage with the CIImage and the buffer
          CIContext *temporaryContext = [CIContext contextWithOptions:nil];
          CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(buffer), CVPixelBufferGetHeight(buffer))];
          //get the UIImage
          UIImage *image = [UIImage imageWithCGImage:videoImage];
          //add the image to the array which is prepared for creating GIF
           [self.thumbnailArray addObject:image];
     }
Besides,how to get the GIF with the thumbnil images for AVPlayer? please clone or download this demo.
