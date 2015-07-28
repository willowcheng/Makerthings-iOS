//
//  StartViewController.swift
//  Makerthings
//
//  Created by Liu Cheng on 2015-07-28.
//  Copyright (c) 2015 Victor Belov. All rights reserved.
//

import UIKit
import Parse

class StartViewController: UIViewController, UIPickerViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var startButton: UIButton!
    
    var dataKeys = [String]()
    var dataValues = [String]()
    let defaults = NSUserDefaults.standardUserDefaults()
    var defaultURL: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        startButton.hidden = true
        pickerView.hidden = true
        
        var query = PFQuery(className:"Server")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.activityIndicator.hidden = true
                self.activityIndicator.startAnimating()
                self.startButton.hidden = false
                self.pickerView.hidden = false
            })
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.dataKeys.append(object.objectForKey("Name") as! String)
                        self.dataValues.append(object.objectForKey("URL") as! String)
                        println(object.objectForKey("Name"))
                        println(object.objectForKey("URL"))
                    }
                    self.defaults.setObject(self.dataValues[0], forKey: "default_URL")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.pickerView.reloadAllComponents()
                    })
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonPressed(sender: AnyObject) {
        println(pickerView.selectedRowInComponent(0))
        self.defaults.setObject(self.dataValues[pickerView.selectedRowInComponent(0)], forKey: "default_URL")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Set up picker view
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataKeys.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: dataKeys[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        println(pickerView.selectedRowInComponent(0))
        return attributedString
    }

}
