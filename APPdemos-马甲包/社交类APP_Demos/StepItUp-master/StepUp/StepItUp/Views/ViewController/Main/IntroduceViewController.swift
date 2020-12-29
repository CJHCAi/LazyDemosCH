//
//  IntroduceViewController.swift
//  StepUp
//
//  Created by syfll on 15/4/21.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

import UIKit

class IntroduceViewController: UIViewController,ABCIntroViewDelegate {

    var defaults = NSUserDefaults.standardUserDefaults()
    var introView:ABCIntroView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //MARK: 测试的时候用来跳过导航页面
        self.performSegueWithIdentifier("goMainViewController", sender: self)
        
        
//        let isIntroScreenLoad = defaults.objectForKey("intro_screen_viewed") as? NSString
//        if (isIntroScreenLoad != "YES"){
//            introView = ABCIntroView(frame: self.view.frame)
//            introView?.delegate = self;
//            introView?.backgroundColor = UIColor.greenColor()
//            self.view.addSubview(self.introView!)
//        }
//        
//        let isLogin = defaults.objectForKey("Logined") as? NSString
//        // MARK: 检查登陆
//        if (isLogin != "YES"){
//            self.navigationController?.performSegueWithIdentifier("goMainViewController", sender: self)
//        }
        introView = ABCIntroView(frame: self.view.frame)
        introView?.delegate = self;
        introView?.backgroundColor = UIColor.greenColor()
        self.view.addSubview(self.introView!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:  ABCIntroViewDelegate Methods
    
    func onDoneButtonPressed(){
        //    Uncomment so that the IntroView does not show after the user clicks "DONE"
        defaults.setObject("YES", forKey: "intro_screen_viewed")
        defaults.synchronize()
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.introView!.alpha = 0
            }) { (Bool finished) -> Void in
                self.introView!.removeFromSuperview()
        }
        self.performSegueWithIdentifier("goMainViewController", sender: self)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle{
        return UIStatusBarStyle.LightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
