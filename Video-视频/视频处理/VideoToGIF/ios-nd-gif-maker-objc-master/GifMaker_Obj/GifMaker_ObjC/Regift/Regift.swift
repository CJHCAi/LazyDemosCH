//
//  Regift.swift
//  GifMaker_ObjC
//
//  Modified by Gabrielle Miller-Messner on 3/2/16.
//  Created by Matthew Palmer on 27/12/2014.
//  Copyright (c) 2014 Matthew Palmer. All rights reserved.
//

import UIKit
import MobileCoreServices
import ImageIO
import AVFoundation

public typealias TimePoint = CMTime

/// Errors thrown by Regift
public enum RegiftError: NSInteger, Error {
    case destinationNotFound
    case sourceFormatInvalid
    case addFrameToDestination
    case destinationFinalize
}

// Convenience struct for managing dispatch groups.
private struct Group {
    let group = DispatchGroup()
    func enter() { group.enter() }
    func leave() { group.leave() }
    func wait() { group.wait(timeout: DispatchTime.distantFuture) }
}

/// Easily convert a video to a GIF. It can convert the whole thing, or you can choose a section to trim out.
///
/// Synchronous Usage:
///
///      let regift = Regift(sourceFileURL: movieFileURL, frameCount: 24, delayTime: 0.5, loopCount: 7)
///      print(regift.createGif())
///
///      // OR
///
///      let trimmedRegift = Regift(sourceFileURL: movieFileURL, startTime: 30, duration: 15, frameRate: 15)
///      print(trimmedRegift.createGif())
///
/// Asynchronous Usage:
///
///      let regift = Regift.createGIFFromSource(movieFileURL, frameCount: 24, delayTime: 0.5, loopCount: 7) { (result) in
///          print(result)
///      }
///
///      // OR
///
///      let trimmedRegift = Regift.createGIFFromSource(movieFileURL, startTime: 30, duration: 15, frameRate: 15) { (result) in
///          print(result)
///      }
///
@objc open class Regift: NSObject {
    
    // Constants removed from struct
    static let FileName = "regift.gif"
    static let TimeInterval: Int32 = 600
    static let Tolerance = 0.01
    
    
    // Static conversion methods, for convenient and easy-to-use API:
    
    /**
     Create a GIF from a movie stored at the given URL. This converts the whole video to a GIF meeting the requested output parameters.
     - parameters:
     - sourceFileURL: The source file to create the GIF from.
     - destinationFileURL: An optional destination file to write the GIF to. If you don't include this, a default path will be provided.
     - frameCount: The number of frames to include in the gif; each frame has the same duration and is spaced evenly over the video.
     - delayTime: The amount of time each frame exists for in the GIF.
     - loopCount: The number of times the GIF will repeat. This defaults to `0`, which means that the GIF will repeat infinitely.
     - completion: A block that will be called when the GIF creation is completed. The `result` parameter provides the path to the file, or will be `nil` if there was an error.
     */
    open static func createGIFFromSource(
        _ sourceFileURL: URL,
        destinationFileURL: URL? = nil,
        frameCount: Int,
        delayTime: Float,
        loopCount: Int = 0,
        completion: (_ result: URL?) -> Void) {
        let gift = Regift(
            sourceFileURL: sourceFileURL,
            destinationFileURL: destinationFileURL,
            frameCount: frameCount,
            delayTime: delayTime,
            loopCount: loopCount
        )
        
        completion(gift.createGif(caption: nil, font: nil))
    }
    
    /**
     Create a GIF from a movie stored at the given URL. This allows you to choose a start time and duration in the source material that will be used to create the GIF which meets the output parameters.
     - parameters:
     - sourceFileURL: The source file to create the GIF from.
     - destinationFileURL: An optional destination file to write the GIF to. If you don't include this, a default path will be provided.
     - startTime: The time in seconds in the source material at which you want the GIF to start.
     - duration: The duration in seconds that you want to pull from the source material.
     - frameRate: The desired frame rate of the outputted GIF.
     - loopCount: The number of times the GIF will repeat. This defaults to `0`, which means that the GIF will repeat infinitely.
     - completion: A block that will be called when the GIF creation is completed. The `result` parameter provides the path to the file, or will be `nil` if there was an error.
     */
    open static func createGIFFromSource(
        _ sourceFileURL: URL,
        destinationFileURL: URL? = nil,
        startTime: Float,
        duration: Float,
        frameRate: Int,
        loopCount: Int = 0,
        completion: (_ result: URL?) -> Void) {
        let gift = Regift(
            sourceFileURL: sourceFileURL,
            destinationFileURL: destinationFileURL,
            startTime: startTime,
            duration: duration,
            frameRate: frameRate,
            loopCount: loopCount
        )
        
        completion(gift.createGif(caption: nil, font: nil))
    }
    
    /// A reference to the asset we are converting.
    fileprivate var asset: AVAsset
    
    /// The url for the source file.
    fileprivate let sourceFileURL: URL
    
    /// The point in time in the source which we will start from.
    fileprivate var startTime: Float = 0
    
    /// The desired duration of the gif.
    fileprivate var duration: Float
    
    /// The total length of the movie, in seconds.
    fileprivate var movieLength: Float
    
    /// The number of frames we are going to use to create the gif.
    fileprivate let frameCount: Int
    
    /// The amount of time each frame will remain on screen in the gif.
    fileprivate let delayTime: Float
    
    /// The number of times the gif will loop (0 is infinite).
    fileprivate let loopCount: Int
    
    /// The destination path for the generated file.
    fileprivate var destinationFileURL: URL?
    
    /**
     Create a GIF from a movie stored at the given URL. This converts the whole video to a GIF meeting the requested output parameters.
     - parameters:
     - sourceFileURL: The source file to create the GIF from.
     - destinationFileURL: An optional destination file to write the GIF to. If you don't include this, a default path will be provided.
     - frameCount: The number of frames to include in the gif; each frame has the same duration and is spaced evenly over the video.
     - delayTime: The amount of time each frame exists for in the GIF.
     - loopCount: The number of times the GIF will repeat. This defaults to `0`, which means that the GIF will repeat infinitely.
     */
    public init(sourceFileURL: URL, destinationFileURL: URL? = nil, frameCount: Int, delayTime: Float, loopCount: Int = 0) {
        self.sourceFileURL = sourceFileURL
        self.asset = AVURLAsset(url: sourceFileURL, options: nil)
        self.movieLength = Float(asset.duration.value) / Float(asset.duration.timescale)
        self.duration = movieLength
        self.delayTime = delayTime
        self.loopCount = loopCount
        self.destinationFileURL = destinationFileURL
        self.frameCount = frameCount
    }
    
    /**
     Create a GIF from a movie stored at the given URL. This allows you to choose a start time and duration in the source material that will be used to create the GIF which meets the output parameters.
     - parameters:
     - sourceFileURL: The source file to create the GIF from.
     - destinationFileURL: An optional destination file to write the GIF to. If you don't include this, a default path will be provided.
     - startTime: The time in seconds in the source material at which you want the GIF to start.
     - duration: The duration in seconds that you want to pull from the source material.
     - frameRate: The desired frame rate of the outputted GIF.
     - loopCount: The number of times the GIF will repeat. This defaults to `0`, which means that the GIF will repeat infinitely.
     */
    public init(sourceFileURL: URL, destinationFileURL: URL? = nil, startTime: Float, duration: Float, frameRate: Int, loopCount: Int = 0) {
        self.sourceFileURL = sourceFileURL
        self.asset = AVURLAsset(url: sourceFileURL, options: nil)
        self.destinationFileURL = destinationFileURL
        self.startTime = startTime
        self.duration = duration
        
        // The delay time is based on the desired framerate of the gif.
        self.delayTime = (1.0 / Float(frameRate))
        
        // The frame count is based on the desired length and framerate of the gif.
        self.frameCount = Int(duration * Float(frameRate))
        
        // The total length of the file, in seconds.
        self.movieLength = Float(asset.duration.value) / Float(asset.duration.timescale)
        
        self.loopCount = loopCount
    }
    
    /**
     Get the URL of the GIF created with the attributes provided in the initializer.
     - returns: The path to the created GIF, or `nil` if there was an error creating it.
     */
    
    open func createGif(caption : String?, font : UIFont?) -> URL? {
        
        let fileProperties = [kCGImagePropertyGIFDictionary as String:[
            kCGImagePropertyGIFLoopCount as String: NSNumber(value: Int32(loopCount) as Int32)],
                              kCGImagePropertyGIFHasGlobalColorMap as String: NSValue(nonretainedObject: true)
        ] as [String : Any]
        
        let frameProperties = [
            kCGImagePropertyGIFDictionary as String:[
                kCGImagePropertyGIFDelayTime as String:delayTime
            ]
        ]
        
        // How far along the video track we want to move, in seconds.
        let increment = Float(duration) / Float(frameCount)
        
        // Add each of the frames to the buffer
        var timePoints: [TimePoint] = []
        
        for frameNumber in 0 ..< frameCount {
            let seconds: Float64 = Float64(startTime) + (Float64(increment) * Float64(frameNumber))
            let time = CMTimeMakeWithSeconds(seconds, Regift.TimeInterval)
            
            timePoints.append(time)
        }
        
        do {
            
            if let caption = caption, let font = font {
                return try createGIFForTimePointsAndCaption(timePoints, fileProperties: fileProperties as [String : AnyObject], frameProperties: frameProperties as [String : AnyObject], frameCount: frameCount, caption: caption as NSString, font:font)
            }else{
                return try createGIFForTimePoints(timePoints, fileProperties: fileProperties as [String : AnyObject], frameProperties: frameProperties as [String : AnyObject], frameCount: frameCount)
            }
        } catch {
            return nil
        }
    }
    
    // Helper function
    open func createGif() -> URL? {
        return createGif(caption: nil, font: nil)
    }
    
    /**
     Create a GIF using the given time points in a movie file stored in this Regift's `asset`.
     
     - parameters:
     - timePoints: timePoints An array of `TimePoint`s (which are typealiased `CMTime`s) to use as the frames in the GIF.
     - fileProperties: The desired attributes of the resulting GIF.
     - frameProperties: The desired attributes of each frame in the resulting GIF.
     - frameCount: The desired number of frames for the GIF. *NOTE: This seems redundant to me, as `timePoints.count` should really be what we are after, but I'm hesitant to change the API here.*
     - returns: The path to the created GIF, or `nil` if there was an error creating it.
     */
    open func createGIFForTimePoints(_ timePoints: [TimePoint], fileProperties: [String: AnyObject], frameProperties: [String: AnyObject], frameCount: Int) throws -> URL {
        // Ensure the source media is a valid file.
        guard asset.tracks(withMediaCharacteristic: AVMediaCharacteristicVisual).count > 0 else {
            throw RegiftError.sourceFormatInvalid
        }
        
        var fileURL:URL?
        if self.destinationFileURL != nil {
            fileURL = self.destinationFileURL
        } else {
            let temporaryFile = (NSTemporaryDirectory() as NSString).appendingPathComponent(Regift.FileName)
            fileURL = URL(fileURLWithPath: temporaryFile)
        }
        
        guard let destination = CGImageDestinationCreateWithURL(fileURL! as CFURL, kUTTypeGIF, frameCount, nil) else {
            throw RegiftError.destinationNotFound
        }
        
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
        
        let generator = AVAssetImageGenerator(asset: asset)
        
        generator.appliesPreferredTrackTransform = true
        
        let tolerance = CMTimeMakeWithSeconds(Regift.Tolerance, Regift.TimeInterval)
        generator.requestedTimeToleranceBefore = tolerance
        generator.requestedTimeToleranceAfter = tolerance
        
        // Transform timePoints to times for the async asset generator method.
        var times = [NSValue]()
        for time in timePoints {
            times.append(NSValue(time: time))
        }
        
        // Create a dispatch group to force synchronous behavior on an asynchronous method.
        let gifGroup = Group()
        var dispatchError: Bool = false
        gifGroup.enter()
        
        generator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { (requestedTime, image, actualTime, result, error) in
            guard let imageRef = image, error == nil else {
                print("An error occurred: \(error), image is \(image)")
                dispatchError = true
                gifGroup.leave()
                return
            }
            
            CGImageDestinationAddImage(destination, imageRef, frameProperties as CFDictionary)
            
            if requestedTime == times.last?.timeValue {
                gifGroup.leave()
            }
        })
        
        // Wait for the asynchronous generator to finish.
        gifGroup.wait()
        
        // If there was an error in the generator, throw the error.
        if dispatchError {
            throw RegiftError.addFrameToDestination
        }
        
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
        
        // Finalize the gif
        if !CGImageDestinationFinalize(destination) {
            throw RegiftError.destinationFinalize
        }
        
        return fileURL!
    }


    
    /// Create a GIF using the given time points in a movie file stored at the URL provided and a caption to be overlayed.
    ///
    /// :param: timePoints An array of `TimePoint`s (which are typealiased `CMTime`s) to use as the frames in the GIF.
    /// :param: URL The URL of the video file to convert
    /// :param: fileProperties The desired attributes of the resulting GIF.
    /// :param: frameProperties The desired attributes of each frame in the resulting GIF.
    /// :param: caption
    ///
    open func createGIFForTimePointsAndCaption(_ timePoints: [TimePoint], fileProperties: [String: AnyObject], frameProperties: [String: AnyObject], frameCount: Int, caption: NSString, font: UIFont) throws -> URL {
        let temporaryFile = (NSTemporaryDirectory() as NSString).appendingPathComponent(Regift.FileName)
        let fileURL = URL(fileURLWithPath: temporaryFile)
        
        guard let destination = CGImageDestinationCreateWithURL(fileURL as CFURL, kUTTypeGIF, frameCount, nil) else {
            print("An error occurred.")
            throw RegiftError.destinationNotFound
        }
        
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
        
        let asset = AVURLAsset(url: sourceFileURL)
        let generator = AVAssetImageGenerator(asset: asset)
        
        generator.appliesPreferredTrackTransform = true
        
        let tolerance = CMTimeMakeWithSeconds(Regift.Tolerance, Regift.TimeInterval)
        generator.requestedTimeToleranceBefore = tolerance
        generator.requestedTimeToleranceAfter = tolerance
        
        for time in timePoints {
            do {
                let imageRef = try generator.copyCGImage(at: time, actualTime: nil)
                let imageRefWithCaption = addCaption(imageRef,text:caption, font:font)
                CGImageDestinationAddImage(destination, imageRefWithCaption, frameProperties as CFDictionary)
            } catch let error as NSError {
                print("An error occurred: \(error)")
                throw RegiftError.addFrameToDestination
            }
        }
        
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
        
        // Finalize the gif
        if !CGImageDestinationFinalize(destination) {
            throw RegiftError.destinationFinalize
        }
        
        return fileURL
    }
}
