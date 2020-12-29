//
//  GroupViewController.swift
//  StepUp
//
//  Created by syfll on 15/4/21.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

import UIKit

let SEARCHBAR_HEIGHT:CGFloat = 20.0
class GroupViewController: UITableViewController {

    var cellDate:NSMutableArray!
    var searchBar :UISearchBar?
    var searchDisplay :UISearchDisplayController?
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: 设置标题栏(最顶上那一条有信号什么的东西)&标题为白色
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //初始化标题
        InitNaviTiem()
        
        
        cellDate = NSMutableArray(capacity: 10)
        loadCellDate()
        
        //初始化搜索栏
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.tableView.bounds.width, SEARCHBAR_HEIGHT))
        searchDisplay = UISearchDisplayController(searchBar: self.searchBar, contentsController: self)
        self.tableView.tableHeaderView = searchBar

        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        //loadSearch()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func loadCellDate(){
        
        for var i = 0 ; i < 10 ; ++i{
            var str = NSString(format: "学习群%d", i)
            cellDate!.addObject(str)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2;
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        switch section{
        case 0:
            var groupHeadView = UITableViewHeaderFooterView()
            
            //groupHeadView.contentView.backgroundColor = UIColor.clearColor()
            return groupHeadView
        case 1:
            var groupHeadView = UITableViewHeaderFooterView()
            groupHeadView.textLabel.text = "我的群"
            //groupHeadView.contentView.backgroundColor = UIColor.grayColor()
            return groupHeadView
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
        return cellDate!.count
        }else{
            return 1;
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 1){
            var cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as? GroupCell
            if  cell == nil {
                cell = GroupCell.createGroupCell()
            }
            cell!.GroupName.text = cellDate[indexPath.row] as! NSString as String
            return cell!
        }else{
            var cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as? UITableViewCell
            if cell == nil{
                cell = UITableViewCell()
            }
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.textLabel!.text = "群组动态"
            return cell!
        }

    }


    //MARK: 初始化NaviTiem
    func InitNaviTiem(){
        var title = UIButton()
        //设置标题字体大小
        title.titleLabel?.font = UIFont.systemFontOfSize(titleFontSize)
        //设置标题内容
        title.setTitle("群组", forState: UIControlState.Normal)
        title.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.navigationItem.titleView = title
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
