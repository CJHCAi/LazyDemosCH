//
//  ViewController.swift
//  UpdateAlert
//
//  Created by yuanzhihang on 2018/7/11.
//  Copyright © 2018年 aaaa1. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert(_ sender: UIButton) {
        updateVersion()
    }
}

// MARK: - 版本更新
extension ViewController{
    
    func updateVersion() {
        let url = "http://itunes.apple.com/lookup?id="+AppleAppID
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                let dic = JSON as! [String:Any]
                let array = dic["results"] as! [Any]
                let results = array[0] as! [String:Any]
                let appleversion = results["version"] as! String
                let releaseNotes = results["releaseNotes"] as! String
                let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                let applestoreversion = appleversion.replacingOccurrences(of: ".", with: "")
                let newBundleVersion = bundleVersion.replacingOccurrences(of: ".", with: "")
                if Int(applestoreversion)! > Int(newBundleVersion)! {
                    AppUpdateAlert.showUpdateAlert(version: appleversion, description: releaseNotes)
                }
            }
        }
    }
}




