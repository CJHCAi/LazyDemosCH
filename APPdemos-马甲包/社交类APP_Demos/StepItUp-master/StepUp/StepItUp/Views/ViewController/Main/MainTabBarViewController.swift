//
//  MainTabBarViewController.swift
//  StepUp
//
//  Created by syfll on 15/4/21.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.blackColor()
        self.tabBar.tintColor = UIColor.whiteColor()
        loadAllViewController()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAllViewController(){
        
        
        var planViewController = UIStoryboard(name: "SIUToDoSB", bundle: nil).instantiateInitialViewController() as! UITabBarController
        planViewController.tabBarItem.image = UIImage(named: "multiply_button__calendar")
        planViewController.tabBarItem.title = "日程"
        
        
        var GroupViewController = UIStoryboard(name: "SIUGroupSB", bundle: nil).instantiateInitialViewController() as! UINavigationController
        GroupViewController.tabBarItem.image = UIImage(named: "multiply_button__group")
        GroupViewController.tabBarItem.title = "群组"
        
        
        
        var dynamicViewController = UIStoryboard(name: "SIUDiscoverSB", bundle: nil).instantiateInitialViewController() as! UINavigationController
        dynamicViewController.tabBarItem.image = UIImage(named: "multiply_button__find")
        dynamicViewController.tabBarItem.title = "发现"
        
        var meViewController = UIStoryboard(name: "SIUMeSB", bundle: nil).instantiateInitialViewController() as! UINavigationController
        meViewController.tabBarItem.image = UIImage(named: "multiply_button__personal")
        meViewController.tabBarItem.title = "账号"
        
        
        //        var contactViewController = UIStoryboard(name: "SIUContactSB", bundle: nil).instantiateInitialViewController() as UINavigationController
        //        contactViewController.tabBarItem.image = UIImage(named: "001")
        //        contactViewController.tabBarItem.selectedImage = UIImage(named:"002")
        //        contactViewController.tabBarItem.title = "联系人"
        
        
        //        var messageViewController = UIStoryboard(name: "SIUMessageSB", bundle: nil).instantiateInitialViewController() as UINavigationController
        //        messageViewController.tabBarItem.image = UIImage(named: "icon_message_normal")
        //        messageViewController.tabBarItem.selectedImage = UIImage(named:"icon_message_selected")
        //        //messageViewController.tabBarItem.title = "消息"
        
        
//        var somethingNewViewController = UIStoryboard(name: "SIUSomethingNewSB", bundle: nil).instantiateInitialViewController() as UINavigationController
//        somethingNewViewController.tabBarItem.image = UIImage(named: "001")
//        somethingNewViewController.tabBarItem.selectedImage = UIImage(named: "002")
        
        
        var tabBarViewControllers = [
            planViewController,
            GroupViewController,
            dynamicViewController,
            meViewController
        ]// TODO: ViewController init
        
        self.setViewControllers(tabBarViewControllers, animated: true)
        self.selectedIndex = 0
        
        
    }
    
        
    //    override func viewWillAppear(animated: Bool) {
    //        self.selectedViewController?.beginAppearanceTransition(true, animated: animated)
    //
    //    }
    //    override func viewWillDisappear(animated: Bool) {
    //        self.selectedViewController?.beginAppearanceTransition(false, animated: animated)
    //    }
    //    override func viewDidAppear(animated: Bool) {
    //        self.selectedViewController?.endAppearanceTransition()
    //        var loginC = IMSimpleLoginC(nibName: NSStringFromClass(IMSimpleLoginC), bundle: nil)
    //        var nav = UINavigationController(rootViewController: loginC)
    //        IMUIHelper.configAppearenceForNavigationBar(nav.navigationBar)
    //        self.navigationController?.presentViewController(nav, animated: false, completion: nil)
    //    }
    //    override func viewDidDisappear(animated: Bool) {
    //        self.selectedViewController?.endAppearanceTransition()
    //    }
}
