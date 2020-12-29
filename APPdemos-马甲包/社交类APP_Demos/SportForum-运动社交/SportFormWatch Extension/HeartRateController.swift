//
//  HeartRateController.swift
//  SportForum
//
//  Created by liyuan on 10/16/15.
//  Copyright © 2015 zhengying. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class HeartRateController: WKInterfaceController,WCSessionDelegate {
    @IBOutlet weak var group: WKInterfaceGroup!
    @IBOutlet weak var imgGroupActivity: WKInterfaceImage!
    @IBOutlet weak var btnGroup: WKInterfaceButton!
    @IBOutlet weak var imgActivity: WKInterfaceImage!
    @IBOutlet weak var heartAvgLabel: WKInterfaceLabel!
    @IBOutlet weak var tips1Label: WKInterfaceLabel!
    @IBOutlet weak var tips2Label: WKInterfaceLabel!

    
    let duration = 0.8
    var heartRateAvg:Int = 0
    var strRecordId:String = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        
        var tipDictionary = context as! [String:String]
        
        if let val = tipDictionary["heartRate"] {
            heartRateAvg = Int(val)!
        }
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self // conforms to WCSessionDelegate
            session.activateSession()
        }
        
        self.actionPublishRecord(tipDictionary)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func popToParentController()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("notification_supplyRecord", object:nil, userInfo:nil)
        self.popController()
    }
    
    private func showAlertErrorController(strError:String) {
        
        let defaultAction = WKAlertAction(
            title: "确认",
            style: WKAlertActionStyle.Default) {[weak self] () -> Void in
                self!.popToParentController()
        }
        let actions = [defaultAction]
        
        self.presentAlertControllerWithTitle(
            "请求失败",
            message: "您请求的服务失败，请重新尝试,错误描述:\(strError)",
            preferredStyle: WKAlertControllerStyle.Alert,
            actions: actions)
    }
    
    private func showAlertHeartRateController(bOk:Bool) {
        
        let defaultAction = WKAlertAction(
            title: "确认",
            style: WKAlertActionStyle.Default) {[weak self] () -> Void in
                self!.popToParentController()
        }
        let actions = [defaultAction]
        
        self.presentAlertControllerWithTitle(
            "发送心跳",
            message: bOk ? "发送心跳成功！" : "发送心跳失败！",
            preferredStyle: WKAlertControllerStyle.Alert,
            actions: actions)
    }
    
    private func showAlertErrorDescController(strError:String) {
        
        let defaultAction = WKAlertAction(
            title: "确认",
            style: WKAlertActionStyle.Default) {[weak self] () -> Void in
                self!.popToParentController()
        }
        let actions = [defaultAction]
        
        self.presentAlertControllerWithTitle(
            "请求失败",
            message: "\(strError)",
            preferredStyle: WKAlertControllerStyle.Alert,
            actions: actions)
    }
    
    @IBAction func sendHeartReat() {
        group.stopAnimating()
        
        self.animateWithDuration(0.5, animations:{
            [weak self] in
            if let strongSelf = self {
                strongSelf.btnGroup.setEnabled(false)
                strongSelf.group.setBackgroundImage(nil)
                
                strongSelf.imgGroupActivity.setHidden(false)
                strongSelf.imgGroupActivity.setImageNamed("spinner")
                strongSelf.imgGroupActivity.startAnimatingWithImagesInRange(NSMakeRange(1, 42), duration: 1.2, repeatCount: 0)
                
                let message = ["sendHeartRate": strongSelf.strRecordId]
                WCSession.defaultSession().sendMessage(
                    message, replyHandler: { (replyMessage) -> Void in
                        let nErrorCode = replyMessage["ErrorCode"] as! Int
                        strongSelf.imgGroupActivity.stopAnimating()
                        strongSelf.imgGroupActivity.setHidden(true)
                        
                        if(nErrorCode == 0)
                        {
                            strongSelf.showAlertHeartRateController(true)
                        }
                        else
                        {
                            strongSelf.showAlertHeartRateController(false)
                        }
                    }) { (error) -> Void in
                        print(error.localizedDescription)
                        self!.showAlertErrorDescController(error.localizedDescription)
                }

            }
        })
    }
    
    func actionPublishRecord(reCord:[String:String]) {
        btnGroup.setHidden(true)
        group.setHidden(true)
        imgGroupActivity.setHidden(true)
        heartAvgLabel.setHidden(true)
        tips1Label.setHidden(true)
        tips2Label.setHidden(true)
        
        imgActivity.setHidden(false)
        imgActivity.setImageNamed("spinner")
        imgActivity.startAnimatingWithImagesInRange(NSMakeRange(1, 42), duration: 1.2, repeatCount: 0)
        
        let message = ["publishRecord": reCord]
        WCSession.defaultSession().sendMessage(
            message, replyHandler: { [weak self] (replyMessage) -> Void in
                let nErrorCode = replyMessage["ErrorCode"] as! Int
                self!.imgActivity.stopAnimating()
                self!.imgActivity.setHidden(true)
                
                if(nErrorCode == 0)
                {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self!.strRecordId = replyMessage["recordId"] as! String
                        self!.btnGroup.setHidden(false)
                        self!.group.setHidden(false)
                        self!.heartAvgLabel.setHidden(true)
                        
                        if(self!.heartRateAvg > 0) {
                            self!.heartAvgLabel.setHidden(false)
                            self!.heartAvgLabel.setText(String(format: "平均心率:%d次/分", Int(self!.heartRateAvg)))
                        }
                        
                        self!.tips1Label.setHidden(false)
                        self!.tips2Label.setHidden(false)
                        
                        self!.group.setBackgroundImageNamed("heart-beat-")
                        self!.group.startAnimatingWithImagesInRange(NSMakeRange(1, 7), duration: self!.duration, repeatCount: 0)
                    }
                    
                    NSUserDefaults.standardUserDefaults().setObject(reCord["endTime"], forKey: "LatestWorkoutTime")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSNotificationCenter.defaultCenter().postNotificationName("notification_supplyRecord", object:nil, userInfo:nil)
                }
                else
                {
                    let strError = replyMessage["ErrorDesc"] as! String
                    self!.showAlertErrorController(strError)
                }
            }) { [weak self] (error) -> Void in
                self!.imgActivity.stopAnimating()
                self!.imgActivity.setHidden(true)
                print(error.localizedDescription)
                self!.showAlertErrorDescController(error.localizedDescription)
        }
    }
}

//        let filePath = NSBundle.mainBundle().pathForResource("Heartbeat4", ofType: "wav")!
//        let audioUR1L = NSBundle.mainBundle().URLForResource("Heartbeat4", withExtension: "wav")
//        print(audioUR1L?.description)
//
//        let url = NSBundle.mainBundle().pathForResource("Heartbeat4", ofType: "wav")!
//        print(url)
//
//        if let audioURL = NSBundle.mainBundle().URLForResource("Heartbeat4", withExtension: "wav") {
//            let asset = WKAudioFileAsset(URL: audioURL)
//            let playerItem = WKAudioFilePlayerItem(asset: asset)
//            let player = WKAudioFilePlayer(playerItem: playerItem)
//
//            switch player.status {
//            case WKAudioFilePlayerStatus.ReadyToPlay:
//                player.play()
//            case WKAudioFilePlayerStatus.Failed:
//                print(player.error)
//            case WKAudioFilePlayerStatus.Unknown:
//                print("unknown")
//                player.play()
//            }
//        }