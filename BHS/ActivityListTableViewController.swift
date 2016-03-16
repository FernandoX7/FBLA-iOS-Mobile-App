//
//  ActivityListTableViewController.swift
//  BHS
//
//  Created by Fernando Ramirez
//  Copyright (c) 2015 oXpheen. All rights reserved.
//

import UIKit
import CoreData

class ActivityListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var activityList:[ActivityList] = []
    var fetchResultController:NSFetchedResultsController!
    var searchController: UISearchController!
    var searchResults:[ActivityList] = []
    
    // Activity Info which are loaded at first
    var activityName = ["BHS Graduation", "Black Light Pep Rally", "DECA", "FBLA", "First Home Game", "Gold Rush Fun Run", "Homecoming", "Intramurals", "Juniors ACT", "Mr.BHS", "Scholarship Deadline"]
    
    var activityDate = ["March 1, 2015", "March 7, 2015", "March 13, 2015", "March 14, 2015", "March 28, 2015", "April 6, 2015", "April 7, 2015", "April 18, 2015", "April 29, 2015", "May 4, 2015", "May 16, 2015"]
    
    var activityTime = ["1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
    
    var activityContact = ["(479) 246-0123", "(479) 246-0124", "(479) 246-0125", "(479) 246-0126", "(479) 246-0127", "(479) 246-0128", "(479) 246-0129", "(479) 246-0130", "(479) 246-0132", "(479) 246-0134", "(479) 246-0136"]
    
    var activityLocation = ["1801 Southeast J Street, Bentonville, AR", "2501 SE 14th St #5, Bentonville, AR", "108 E Central Ave, Bentonville, AR", "2702 N Walton Blvd, Bentonville, AR", "1502 N Walton Blvd, Bentonville, AR", "110 SE A St, Bentonville, AR", "1502 N Walton Blvd, Bentonville, AR", "1204 S Walton Blvd, Bentonville, AR", "100 Commercial Lane, Pineville, MO", "1702 south walton blvd, Bentonville, AR", "3404 SE Macy Rd #24, Bentonville, AR"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Launch walkthrough screens
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        
        if hasViewedWalkthrough == false {
            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
                
                self.presentViewController(pageViewController, animated: true, completion: nil)
            }
        }
        
        // Empty back button title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // Self Sizing Cells
        self.tableView.estimatedRowHeight = 120.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Retrieve content from persistent store
        var fetchRequest = NSFetchRequest(entityName: "ActivityList")
        // Sort the tableview by date
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            
            // Pre-Populate the table with activities
            let defaults = NSUserDefaults.standardUserDefaults()
            let addItemsIn = defaults.boolForKey("hasAddedItems")
            
            // Simple logic to see if it's already been populated
            if (addItemsIn == false) {
                addItems()
            }
            
            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            activityList = fetchResultController.fetchedObjects as [ActivityList]
            
            if result != true {
                println(e?.localizedDescription)
            }
        }
        
        // Do the search resulting
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = UIColor.blackColor() // Customize
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        // Make the search bar fit within the view
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    func addItems() {
        for var i = 0; i < 11; ++i {
            // Retrieve content from persistent store
            var fetchRequest = NSFetchRequest(entityName: "ActivityList")
            // Sort tableview by date
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
                fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                fetchResultController.delegate = self
                
                // If all fields are correctly filled in, extract the field value
                // Create Activity List Object and save to data store
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
                    
                    var activityList:ActivityList!
                    activityList = NSEntityDescription.insertNewObjectForEntityForName("ActivityList",
                        inManagedObjectContext: managedObjectContext) as ActivityList
                    activityList.name = activityName[i]
                    activityList.date = activityDate[i]
                    activityList.time = activityTime[i]
                    activityList.contact = activityContact[i]
                    activityList.location = activityLocation[i]
                    activityList.image = UIImagePNGRepresentation(UIImage(named: "default-placeholder"))
                    // Don't add these again
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: "hasAddedItems")
                    
                    var e: NSError?
                    if managedObjectContext.save(&e) != true {
                        println("insert error: \(e!.localizedDescription)")
                        return
                    }
                }
                
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if searchController.active {
            return searchResults.count
        } else {
            return self.activityList.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomTableViewCell
        
        // Configure the cell...
        let activityLists = (searchController.active) ? searchResults[indexPath.row] : activityList[indexPath.row]
        
        
        
        
        cell.nameLabel.text = activityLists.name
        cell.thumbnailImageView.image = UIImage(data: activityLists.image)
        cell.locationLabel.text = activityLists.location
        cell.typeLabel.text = activityLists.date
        cell.timeLabel.text = activityLists.time
        cell.contactLabel.text = activityLists.contact
        
        
        // Circular image
        cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        // Delete Button
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete",handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            // Delete the row from the data source
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
                
                let activityListToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as ActivityList
                managedObjectContext.deleteObject(activityListToDelete)
                
                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("delete error: \(e!.localizedDescription)")
                }
            }
            
        })
        
        deleteAction.backgroundColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1.0) // Red
        
        return [deleteAction]
    }
    
    // The action handler methods for the share button
    let shareToTwitterActionHandler = { (action:UIAlertAction!) -> Void in
        println("Sharing to Twitter")
        
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        default:
            tableView.reloadData()
        }
        
        activityList = controller.fetchedObjects as [ActivityList]
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.endUpdates()
    }
    
    // MARK: - Search Controller
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        filterContentForSearchText(searchText)
        
        tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        
        searchResults = activityList.filter({ ( activityLists: ActivityList) -> Bool in
            
            let nameMatch = activityLists.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            //            let locationMatch = activityList.location.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return nameMatch != nil //|| locationMatch != nil
            
        })
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "showActivityListDetail" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationController = segue.destinationViewController as DetailViewController
                destinationController.activityList = (searchController.active) ? searchResults[row] : activityList[row]
            }
        }
    }
    
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
    }
    
}
