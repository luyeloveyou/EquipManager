//
//  EquipImagePickerTableViewController.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/9.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class EquipImagePickerTableViewController: UITableViewController,UIAlertViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.separatorStyle  = .SingleLine
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            while(!NetworkOperation.sharedInstance().getThumbnailComplete){
                sleep(1)
            }
            dispatch_async(dispatch_get_main_queue()){
                self.clearAllNotice();
                self.tableView.reloadData();
            }
        }
        
        menuToolbar()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .Done, target: self, action: #selector(EquipImagePickerTableViewController.editImageCell))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //长按
    func longPressed(sender:UILongPressGestureRecognizer){
        // chose to do
    }
    
    //下拉刷新
    @IBAction func fresh(sender: UIRefreshControl) {
        self.tableView.reloadData();
        sender.endRefreshing();
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(DetailEquipViewController.data_source == nil){
            return 0
        }
        return DetailEquipViewController.data_source!.imageInfo.historyImage.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let equipImageCellIdentifier = "equipImageCell";
        var cell:EquipImageTableViewCell! = tableView.dequeueReusableCellWithIdentifier(equipImageCellIdentifier) as? EquipImageTableViewCell;
        if(cell == nil){
            cell = EquipImageTableViewCell(style: .Default, reuseIdentifier: equipImageCellIdentifier);
        }
        cell.imageInCell.image = DetailEquipViewController.data_source!.imageInfo.getImage(indexPath.row);
        cell.imageNameInCell.text = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getImageName(DetailEquipViewController.data_source!.equipIndex, imageIndex: indexPath.row) as String;
        return cell
    }
    
    
    
    func menuToolbar(){
        let backButton = UIBarButtonItem(image: UIImage.init(named:"back"), style: .Plain, target: self, action: #selector(EquipImagePickerTableViewController.backPressed))
        let flexItem = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let homeItem = UIBarButtonItem(image: UIImage.init(named: "home"), style: .Plain, target: self, action: #selector(EquipImagePickerTableViewController.homePressed))
        let menuItem = UIBarButtonItem(image: UIImage.init(named: "new"), style: .Plain, target: self, action: #selector(EquipImagePickerTableViewController.menuPressed))
        let items = [backButton, flexItem, homeItem, flexItem, flexItem, flexItem, menuItem]
        self.setToolbarItems(items, animated: true)
    }
    
    func backPressed(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func homePressed(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func menuPressed(){
        let imageAlertController:UIAlertController = UIAlertController(title: "图片操作", message: "选择一项操作", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        imageAlertController.addAction(UIAlertAction(title: "上传图片", style: UIAlertActionStyle.Default, handler: {(UIAlertAction)-> Void in self.uploadImage()}))
        
        imageAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
    }
    
    func uploadImage(){
        let uploadImageAlertController:UIAlertController = UIAlertController(title: "上传图片", message: "选择图片来源", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        uploadImageAlertController.addAction(UIAlertAction(title: "本地照片", style: UIAlertActionStyle.Default, handler: {(UIAlertAction)-> Void in self.imagePickerFromLocal()}))
        
        uploadImageAlertController.addAction(UIAlertAction(title: "拍照上传", style: UIAlertActionStyle.Default, handler: {(UIAlertAction)-> Void in self.imagePickerFromCamera()}))
        
        uploadImageAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
    }
    
    func imagePickerFromLocal(){
        //本地照片选择图片
    }
    
    func imagePickerFromCamera(){
        //拍照上传图片
    }
    
    func editImageCell(){
        //右上角的编辑按钮
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
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
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}