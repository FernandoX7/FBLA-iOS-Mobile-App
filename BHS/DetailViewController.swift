//
//  DetailViewController.swift
//  BHS
//
//  Created by Fernando Ramirez
//  Copyright (c) 2014 oXpheen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var restaurantImageView:UIImageView!
    @IBOutlet var tableView:UITableView!

    var activityList:ActivityList!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.restaurantImageView.image = UIImage(data: activityList.image)
        
        // Set table view background color
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)

        // Remove extra separator
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Change separator color
        self.tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // Set navigation bar title
        title = self.activityList.name
        
        tableView.estimatedRowHeight = 36.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as DetailTableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        // Configure the cell...
        cell.mapButton.hidden = true

        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = activityList.name
        case 1:
            cell.fieldLabel.text = "Date"
            cell.valueLabel.text = activityList.date
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = activityList.location
            cell.mapButton.hidden = false
        case 3:
            cell.fieldLabel.text = "Contact"
            cell.valueLabel.text = activityList.contact
        case 4:
            cell.fieldLabel.text = "Time"
            cell.valueLabel.text = activityList.time
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
            
        }
        
        return cell
    }

    @IBAction func close(segue:UIStoryboardSegue) {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMap" {
            let destinationController = segue.destinationViewController as MapViewController
            destinationController.activityList = activityList
        }

    }

}
