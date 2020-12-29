//
//  InterfaceController.swift
//  SportFormWatch Extension
//
//  Created by liyuan on 10/14/15.
//  Copyright © 2015 zhengying. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import HealthKit

public enum DistanceUnit:Int {
    case Miles=0, Kilometers=1
}

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet weak var groupTop: WKInterfaceGroup!
    @IBOutlet weak var group: WKInterfaceGroup!
    @IBOutlet weak var groupCircleData: WKInterfaceGroup!
    @IBOutlet weak var valLabel: WKInterfaceLabel!
    @IBOutlet weak var ofLabel: WKInterfaceLabel!
    @IBOutlet weak var maxLabel: WKInterfaceLabel!
    @IBOutlet weak var unitLabel: WKInterfaceLabel!
    @IBOutlet weak var logInfoLabel: WKInterfaceLabel!
    @IBOutlet weak var distanceLabel: WKInterfaceLabel!
    @IBOutlet weak var durationLabel: WKInterfaceLabel!
    @IBOutlet weak var noRecordLabel: WKInterfaceLabel!
    @IBOutlet weak var supplyButton: WKInterfaceButton!
    
    @IBOutlet weak var groupBottom: WKInterfaceGroup!
    @IBOutlet weak var workoutTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var workoutValueLabel: WKInterfaceLabel!
    @IBOutlet weak var calorieTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var calorieValueLabel: WKInterfaceLabel!
    @IBOutlet weak var durationTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var durationValueLabel: WKInterfaceLabel!
    @IBOutlet weak var distanceTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var distanceValueLabel: WKInterfaceLabel!
    @IBOutlet weak var speedAvgTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var speedAvgValueLabel: WKInterfaceLabel!
    
    let duration = 1.2
    var _levelProcess = 0
    var bLogin:Bool = false

    let healthKitManager = HealthKitManager.instance
    var workouts = [HKWorkout]()
    let durationFormatter = NSDateComponentsFormatter()
    let energyFormatter = NSEnergyFormatter()
    let distanceFormatter = NSLengthFormatter()
    var distanceUnit = DistanceUnit.Miles

    lazy var dateFormatter:NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .MediumStyle
        return formatter;
        
        }()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "action_notification_supplyRecord:", name: "notification_supplyRecord", object: nil)
        
        // Activate the session on both sides to enable communication.
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self // conforms to WCSessionDelegate
            session.activateSession()
        }
        
        self.resetAllControls()
        self.checkLoginInfo()
    }
    
    func action_notification_supplyRecord(notification:NSNotification) {
        
        print("phone button touched")
        self.checkLoginInfo()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Activate the session on both sides to enable communication.
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self // conforms to WCSessionDelegate
            session.activateSession()
        }
        
        self.authorizeHealthKit()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        healthKitManager.stopQueries()
    }
    
    // =========================================================================
    // MARK: - authorHealthkit and workout session
    func authorizeHealthKit() {
        // Healthy Manager
        healthKitManager.authorizeHealthKit { [weak self] (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
                self!.getHealthWorkoutData()
            }
            else
            {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
                
                self!.showAlertController()
            }
        }
    }
    
    func getHealthWorkoutData() {
        let now = NSDate()
        var weekBefore = NSDate(timeInterval: -7*24*60*60, sinceDate: now)
        self.workouts.removeAll()
        
        if let strWorkoutTime = NSUserDefaults.standardUserDefaults().objectForKey("LatestWorkoutTime") as? String {
            let lastWorkout = NSDate(timeIntervalSince1970: Double(strWorkoutTime)!)
            print(lastWorkout)
            let diffBeforeBetween = lastWorkout.timeIntervalSinceDate(weekBefore)
            let diffNowBetween = lastWorkout.timeIntervalSinceDate(now)
            
            if(diffBeforeBetween > 0 && diffNowBetween < 0)
            {
                weekBefore = lastWorkout
            }
        }
        
        healthKitManager.readRecentlyWeekRunningWorkOuts(weekBefore.toUTC(), endDate:now.toUTC(), completion:{ [weak self] (results, error) -> Void in
            if( error != nil )
            {
                print("Error reading workouts: \(error.localizedDescription), \(error.code)")
                
                if(error.code == 5)
                {
                    self!.showAlertController()
                }
                
                return;
            }
            else
            {
                print("Workouts read successfully!!")
            }
            
            // keep workouts and refresh tableview in main thread
            self!.workouts = results as! [HKWorkout]
            
            // GCD - Present on the screen
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if(self!.workouts.count > 0)
                {
                    let workout = self!.workouts.first
                    print(workout)
                    self!.setWorkoutControls(workout!)
                }
                else
                {
                    self!.setWorkoutControls(nil)
                }
            }
        })
    }

    func setWorkoutControls(workout:HKWorkout?) {
        if(workout != nil)
        {
            let nMonth = workout!.startDate.month
            let nDay = workout!.startDate.day
            let nStartHour = workout!.startDate.hour
            let nStartSecond = workout!.startDate.minute
            let nEndHour = workout!.endDate.hour
            let nEndSecond = workout!.endDate.minute
            
            noRecordLabel.setHidden(true)
            
            if(workout!.workoutActivityType == HKWorkoutActivityType.Running)
            {
                workoutTitleLabel.setText(String(format: "%02d/%02d 体能训练-跑步", nMonth, nDay))
            }
            else if(workout!.workoutActivityType == HKWorkoutActivityType.Walking)
            {
                workoutTitleLabel.setText(String(format: "%02d/%02d 体能训练-步行", nMonth, nDay))
            }
            else
            {
                workoutTitleLabel.setText(String(format: "%02d/%02d 体能训练", nMonth, nDay))
            }
            
            workoutValueLabel.setText(String(format: "%02d:%02d - %02d:%02d", nStartHour, nStartSecond, nEndHour, nEndSecond))
            
            let energyBurned = workout!.totalEnergyBurned!.doubleValueForUnit(HKUnit.kilocalorieUnit())
            calorieValueLabel.setText(String(format: "%d卡", Int(energyBurned)))
            
            durationValueLabel.setText(self.durationFormatter.stringFromTimeInterval(workout!.duration)!)
            
            let distanceInKM = workout!.totalDistance!.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo))
            distanceValueLabel.setText(String(format: "%.2f公里", distanceInKM))
            
            let nSpeedSet:Int = Int(workout!.duration / distanceInKM)
            speedAvgValueLabel.setText(String(format: "%ld' %ld'' 公里", nSpeedSet / 60, nSpeedSet % 60))
            
            distanceLabel.setText(String(format: "%.2f公里", distanceInKM))
            
            durationLabel.setText(self.durationFormatter.stringFromTimeInterval(workout!.duration)!)
            
//            if(self.bLogin)
//            {
//                distanceLabel.setHidden(false)
//                durationLabel.setHidden(false)
//                supplyButton.setHidden(false)
//                supplyButton.setEnabled(self.bLogin)
//            }
//            else
//            {
//                distanceLabel.setHidden(true)
//                durationLabel.setHidden(true)
//                supplyButton.setHidden(true)
//                supplyButton.setEnabled(self.bLogin)
//            }
        }
        else
        {
            distanceLabel.setText("")
            durationLabel.setText("")

            workoutTitleLabel.setText("体能训练")
            workoutValueLabel.setText("--")
            calorieTitleLabel.setText("活动时消耗的卡路里")
            calorieValueLabel.setText("--")
            durationTitleLabel.setText("时间总计")
            durationValueLabel.setText("--")
            distanceTitleLabel.setText("距离总计")
            distanceValueLabel.setText("--")
            speedAvgTitleLabel.setText("平均配速")
            speedAvgValueLabel.setText("--")

//            if(self.bLogin)
//            {
//                self.noRecordLabel.setHidden(false)
//                self.distanceLabel.setText("")
//                self.durationLabel.setText("")
//                self.distanceLabel.setHidden(true)
//                self.durationLabel.setHidden(true)
//                self.supplyButton.setEnabled(false)
//            }
//            else
//            {
//                self.noRecordLabel.setHidden(true)
//                self.distanceLabel.setHidden(true)
//                self.durationLabel.setHidden(true)
//                self.supplyButton.setHidden(true)
//                self.supplyButton.setEnabled(self.bLogin)
//            }
        }
        
        self.updateControlsWhenLoginChanged(self.bLogin)
    }

    // =========================================================================
    // MARK: - checkout LoginInfo session
    
    // =========================================================================
    // MARK: - Actions
    
    func checkLoginInfo() {
        let message = ["request": "checkLoginInfo"]
        WCSession.defaultSession().sendMessage(
            message, replyHandler: { [weak self] (replyMessage) -> Void in
                let bLoginState = replyMessage["LoginState"] as! Bool
                
                if(bLoginState == true) {
                    let levelProcess = replyMessage["LevelProcess"] as! Int
                    let currentScore = replyMessage["CurrentScore"] as! Int
                    let levelTotal = replyMessage["LevelTotal"] as! Int
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self!.valLabel.setText(String(currentScore))
                        self!.maxLabel.setText(String(levelTotal))
                        var nStart = self!._levelProcess
                        
                        if(levelProcess < self!._levelProcess)
                        {
                            nStart = 0
                        }
                        
                        if(levelProcess == 0)
                        {
                            self!.group.setBackgroundImageNamed("singleArc0")
                        }
                        else if(nStart != levelProcess)
                        {
                            self!.group.setBackgroundImageNamed("singleArc")
                            self!.group.startAnimatingWithImagesInRange(NSMakeRange(nStart, levelProcess), duration: (levelProcess - nStart) > 50 ? self!.duration : self!.duration / 2, repeatCount: 1)
                        }
                        
                        self!._levelProcess = levelProcess
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self!.updateControlsWhenLoginChanged(bLoginState)
                }
            }) {[weak self] (error) -> Void in
                print(error.localizedDescription)
                self!.showAlertErrorDescController(error.localizedDescription)
        }
    }

    func updateControlsWhenLoginChanged(bLogin:Bool) {
        var distanceInKM:Double = 0.0
        
        if(self.workouts.count > 0)
        {
            let workout = self.workouts.first
            distanceInKM = workout!.totalDistance!.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo))
        }
        
        if(bLogin == true)
        {
            if(distanceInKM > 0)
            {
                self.distanceLabel.setHidden(false)
                self.durationLabel.setHidden(false)
                self.noRecordLabel.setHidden(true)
                self.supplyButton.setEnabled(true)
            }
            else
            {
                self.distanceLabel.setHidden(true)
                self.durationLabel.setHidden(true)
                self.noRecordLabel.setHidden(false)
                self.supplyButton.setEnabled(false)
            }
            
            self.supplyButton.setHidden(false)
            self.groupCircleData.setHidden(false)
            self.logInfoLabel.setHidden(true)
        }
        else
        {
            self.distanceLabel.setHidden(true)
            self.durationLabel.setHidden(true)
            self.noRecordLabel.setHidden(true)
            self.supplyButton.setHidden(true)
            
            self.group.setBackgroundImage(nil)
            self.groupCircleData.setHidden(true)
            self.logInfoLabel.setHidden(false)
            
            _levelProcess = 0
        }
        
        self.bLogin = bLogin
    }

    // =========================================================================
    // MARK: - WCSessionDelegate
    
    func sessionWatchStateDidChange(session: WCSession) {
        print(__FUNCTION__)
        print(session)
        print("reachable:\(session.reachable)")
    }
    
    // Received message from iPhone
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        if let val = message["UpdateProcessToWatch"] {
            let levelProcess = val["LevelProcess"] as! Int
            let currentScore = val["CurrentScore"] as! Int
            let levelTotal = val["LevelTotal"] as! Int
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.valLabel.setText(String(currentScore))
                self.maxLabel.setText(String(levelTotal))
                
                var nStart = self._levelProcess
                
                if(levelProcess < self._levelProcess)
                {
                    nStart = 0
                }
                
                if(levelProcess == 0)
                {
                    self.group.setBackgroundImageNamed("singleArc0")
                }
                else if(nStart != levelProcess)
                {
                    self.group.setBackgroundImageNamed("singleArc")
                    self.group.startAnimatingWithImagesInRange(NSMakeRange(nStart, levelProcess), duration: (levelProcess - nStart) > 50 ? self.duration : self.duration / 2, repeatCount: 1)
                }
                
                self._levelProcess = levelProcess
                self.updateControlsWhenLoginChanged(true)
            }
            
            //replyHandler(["Reslut":"Ok"])
        }
        else if let val = message["LoginState"] {
            let bLoginState = val as! Bool
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.updateControlsWhenLoginChanged(bLoginState)
            }
        }
    }
    
    @IBAction func sendHeartAfterSupply() {
        if(self.workouts.count > 0)
        {
            let workout = self.workouts.first
            
            self.healthKitManager.fetchAvagageHeartRateHandle(workout!.startDate , endDate:workout!.endDate, completionHandler: { [weak self] (result, error) -> Void in
                if( error != nil )
                {
                    print("Error reading workouts: \(error!.localizedDescription)")
                    
                    if(error!.code == 5)
                    {
                        self!.showAlertHeartController()
                        return
                    }
                }
                else
                {
                    print("Workouts read successfully!!")
                }
                
                let strSource = workout!.sourceRevision.source.name
                let fBeginTime = workout!.startDate.timeIntervalSince1970
                let fEndTime = workout!.endDate.timeIntervalSince1970
                let fDuration = workout!.duration
                let fDistance = workout!.totalDistance!.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.None))

                var valueHeart = ["source":strSource, "beginTime":String(format:"%d",Int(fBeginTime)), "endTime":String(format:"%d",Int(fEndTime)), "duration":String(format:"%d",Int(fDuration)), "distance":String(format:"%d",Int(fDistance))]
                
                if(result > 0)
                {
                    valueHeart["heartRate"] = String(format:"%d",Int(result!))
                }
                
                self!.pushControllerWithName("HeartRate", context: valueHeart)
            })
        }
    }
    
    private func showAlertController() {
        
        let defaultAction = WKAlertAction(
            title: "授权访问健康App",
            style: WKAlertActionStyle.Default) { () -> Void in
        }
        let actions = [defaultAction]
        
        self.presentAlertControllerWithTitle(
            "未授权访问健康App",
            message: "您未授权健康App读写数据，可以在Iphone【健康App>数据来源】应用程序中授权访问。",
            preferredStyle: WKAlertControllerStyle.Alert,
            actions: actions)
    }
    
    private func showAlertHeartController() {
        
        let defaultAction = WKAlertAction(
            title: "确认",
            style: WKAlertActionStyle.Default) { () -> Void in
        }
        let actions = [defaultAction]
        
        self.presentAlertControllerWithTitle(
            "未授权访问健康App",
            message: "您未授权健康App读写心率权限，可以在Iphone【健康App>数据来源】应用程序中授权访问。",
            preferredStyle: WKAlertControllerStyle.Alert,
            actions: actions)
    }
    
    private func showAlertErrorDescController(strError:String) {
        
        let defaultAction = WKAlertAction(
            title: "确认",
            style: WKAlertActionStyle.Default) { () -> Void in
        }
        let actions = [defaultAction]
        
        self.presentAlertControllerWithTitle(
            "请求失败",
            message: "\(strError)",
            preferredStyle: WKAlertControllerStyle.Alert,
            actions: actions)
    }
    
    func resetAllControls() {
        valLabel.setText("--")
        ofLabel.setText("目标")
        maxLabel.setText("--")
        unitLabel.setText("分")
        distanceLabel.setText("--")
        durationLabel.setText("--")
        noRecordLabel.setHidden(true)
        supplyButton.setEnabled(false)
        
        workoutTitleLabel.setText("体能训练")
        workoutValueLabel.setText("--")
        calorieTitleLabel.setText("活动时消耗的卡路里")
        calorieValueLabel.setText("--")
        durationTitleLabel.setText("时间总计")
        durationValueLabel.setText("--")
        distanceTitleLabel.setText("距离总计")
        distanceValueLabel.setText("--")
        speedAvgTitleLabel.setText("平均配速")
        speedAvgValueLabel.setText("--")
        
        logInfoLabel.setHidden(false)
        distanceLabel.setHidden(true)
        durationLabel.setHidden(true)
        supplyButton.setHidden(true)
        group.setBackgroundImageNamed(nil)
        groupCircleData.setHidden(true)
        
        _levelProcess = 0
        bLogin = false
    }
}

