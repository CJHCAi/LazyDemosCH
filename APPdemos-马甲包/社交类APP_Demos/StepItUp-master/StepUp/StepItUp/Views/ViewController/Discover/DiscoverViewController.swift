//
//  DiscoverViewController.swift
//  StepUp
//
//  Created by syfll on 15/4/21.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

import UIKit

let titleFontSize : CGFloat = 23.0
class DiscoverViewController: UITableViewController {
    
    let SomethingNewIdentifier = "showSomethingNewIdentifier"

    let dataKeyValue : [ String : String ] = ["关注动态":"found_dynamic", "热门计划":"found_plan","同城用户":"found_local","同城计划":"found_localplan","红人榜":"found_people"]
    let dataArray = [["关注动态"],["热门计划","同城用户","同城计划"],["红人榜"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: 设置标题栏(最顶上那一条有信号什么的东西)&标题为白色
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        InitNaviTiem()
        
        //tableView不能滑动
        //self.tableView.scrollEnabled = false
        //tableView颜色
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        //self.tableView.backgroundColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
//        var view:UIView? = UIView()
//        view!.backgroundColor = UIColor.clearColor()
//        self.tableView.tableFooterView = view!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return dataArray.count
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        var groupHeadView = UITableViewHeaderFooterView()
        
        //groupHeadView.contentView.backgroundColor = UIColor.clearColor()
        return groupHeadView
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataArray[section].count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "DiscoverCell");
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let titleName = dataArray[indexPath.section][indexPath.row]
        let imageName = dataKeyValue[titleName]
        cell.textLabel!.text = titleName
        cell.imageView!.image = UIImage(named: imageName!)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.row == 0 && indexPath.section == 0{
            self.performSegueWithIdentifier(SomethingNewIdentifier, sender: self)
        }else if indexPath.row == 0 && indexPath.section == 1{
            self.performSegueWithIdentifier("SomethingNewIdentifier", sender: self)
        }
        else {
            NSLog("row is:%D , section is :%D",indexPath.row,indexPath.section)
        }
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 15;
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 5;
    }
    //MARK: 初始化NaviTiem
    func InitNaviTiem(){
        var title = UIButton()
        //设置标题字体大小
        title.titleLabel?.font = UIFont.systemFontOfSize(titleFontSize)
        //设置标题内容
        title.setTitle("发现", forState: UIControlState.Normal)
        title.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.navigationItem.titleView = title

    }
    
    
}
