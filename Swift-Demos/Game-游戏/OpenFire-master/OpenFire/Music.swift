//
//  Music.swift
//  OpenFire
//
//  Created by targeter on 2019/3/12.
//  Copyright © 2019 targeter. All rights reserved.
//

import Foundation
import AVFoundation

struct Music {
    var bgmPlayer: AVAudioPlayer = {
        var player:AVAudioPlayer?
        let mp3Path = Bundle.main.path(forResource: "bgm", ofType: "mp3")
        let pathURL = NSURL.fileURL(withPath: mp3Path!)
        do {
            try player = AVAudioPlayer(contentsOf: pathURL)
        } catch {
            print(error)
        }
        return player!
    }()
    var bulletShoot:AVAudioPlayer = {
        var player : AVAudioPlayer?
        let mp3Path = Bundle.main.path(forResource: "direction", ofType: "mp3")
        let pathURL = NSURL.fileURL(withPath: mp3Path!)
        do {
            try player = AVAudioPlayer(contentsOf: pathURL)
        } catch {
            print(error)
        }
        return player!
    }()
    var explodedSound:AVAudioPlayer = {
        var player : AVAudioPlayer?
        let mp3Path = Bundle.main.path(forResource: "bomb", ofType: "mp3")
        let pathURL = NSURL.fileURL(withPath: mp3Path!)
        do {
            try player = AVAudioPlayer(contentsOf: pathURL)
        } catch {
            print(error)
        }
        return player!
    }()
    
    //MARK:play background music
    func playBGM() {
        bgmPlayer.numberOfLoops = Int(INT_MAX)
        bgmPlayer.play()
        bgmPlayer.volume = 0.2
    }
    //bullet shoot sound
    func bulletShootSound() {
        bulletShoot.play()
    }
    
    //MARK:exploded sound
    func bomb() {
        explodedSound.play()
    }
    
}
