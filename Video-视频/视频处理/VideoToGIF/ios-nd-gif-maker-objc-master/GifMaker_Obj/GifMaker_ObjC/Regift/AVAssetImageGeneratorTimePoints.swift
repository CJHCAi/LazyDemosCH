//
//  AVAssetImageGeneratorTimePoints.swift
//  GifMaker_ObjC
//
//  Created by Matthew Palmer on 27/12/2014.
//  Copyright (c) 2014 Matthew Palmer. All rights reserved.
//

import AVFoundation

public extension AVAssetImageGenerator {
    public func generateCGImagesAsynchronouslyForTimePoints(_ timePoints: [TimePoint], completionHandler: @escaping AVAssetImageGeneratorCompletionHandler) {
        let times = timePoints.map {timePoint in
            return NSValue(time: timePoint)
        }
        self.generateCGImagesAsynchronously(forTimes: times, completionHandler: completionHandler)
    }
}
