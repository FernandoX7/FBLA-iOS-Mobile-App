//
//  PageContentViewController.swift
//  BHS
//
//  Created by Fernando Ramirez
//  Copyright (c) 2014 oXpheen. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var subHeadingLabel:UILabel!
    @IBOutlet weak var contentImageView:UIImageView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var getStartedButton:UIButton!
    @IBOutlet weak var forwardButton:UIButton!

    var index : Int = 0
    var heading : String = ""
    var imageFile : String = ""
    var subHeading : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
        pageControl.currentPage = index
        
        getStartedButton.hidden = (index == 2) ? false : true
        forwardButton.hidden = (index == 2) ? true: false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func close(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "hasViewedWalkthrough")

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextScreen(sender: AnyObject) {
        let pageViewController = self.parentViewController as PageViewController
        pageViewController.forward(index)
    }

}
