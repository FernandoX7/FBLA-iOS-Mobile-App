//
//  AddTableViewController.swift
//  BHS
//
//  Created by Fernando Ramirez
//  Copyright (c) 2014 oXpheen. All rights reserved.
//

import UIKit
import CoreData

class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var typeTextField:UITextField!
    @IBOutlet weak var contactTextField:UITextField!
    @IBOutlet weak var timeTextField:UITextField!
    @IBOutlet weak var locationTextField:UITextField!
    @IBOutlet weak var imageView:UIImageView!
    
    var isItemCompleted = false
    
    var activityList:ActivityList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save() {
        
        // Check if the user has filled in all the fields before allowing them to save
        var errorField = ""
        
        if nameTextField.text == "" {
            errorField = "name"
        } else if locationTextField.text == "" {
            errorField = "location"
        } else if typeTextField.text == "" {
            errorField = "date"
        } else if contactTextField.text == "" {
            errorField = "contact information"
        } else if timeTextField.text == "" {
            errorField = "time"
        }
        
        if errorField != "" {
            
            let alertController = UIAlertController(title: "All fields are mandatory", message: "We can't proceed as you forget to fill in the activitys " + errorField + ".", preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // If all fields are correctly filled in, extract the field value
        // Create Activity List Object and save to data store
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            
            activityList = NSEntityDescription.insertNewObjectForEntityForName("ActivityList",
                inManagedObjectContext: managedObjectContext) as ActivityList
            activityList.name = nameTextField.text
            activityList.date = typeTextField.text
            activityList.time = timeTextField.text
            activityList.contact = contactTextField.text
            activityList.location = locationTextField.text
            activityList.image = UIImagePNGRepresentation(imageView.image)
            
            activityList.isCompleted = isItemCompleted
            
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
        
        // Execute the unwind segue and go back to the home screen
        performSegueWithIdentifier("unwindToHomeScreen", sender: self)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    func navigationController(navigationController: UINavigationController!, willShowViewController viewController: UIViewController!, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    }
}
