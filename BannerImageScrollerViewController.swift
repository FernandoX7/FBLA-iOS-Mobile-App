//
//  BannerImageScrollerViewController.swift
//  BHS
//
//  Created by Fernando Ramirez
//  Copyright (c) 2015 oXpheen. All rights reserved.
//

import UIKit

class BannerImageScrollerViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControlDots: UIPageControl!
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageImages =
            [UIImage(named:"activity_image")!,
            UIImage(named:"activity_image1")!,
            UIImage(named:"activity_image2")!,
            UIImage(named:"activity_image3")!,
            UIImage(named:"activity_image4")!]
        
        let pageCount = pageImages.count
        
        pageControlDots.currentPage = 0
        pageControlDots.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        
        loadPagesIntoView()
    }
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            return
        }
        
        if let pageView = pageViews[page] {
            // View's already loaded so nothing to do
        } else {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    
    func removePageFromView(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // Outside so don't do anything
            return
        }
        
        // Out a page && reset counter
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
        
    }
    
    func loadPagesIntoView() {
    
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Page dots should refer to the current page
        pageControlDots.currentPage = page
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        for var index = 0; index < firstPage; ++index {
            removePageFromView(index)
        }
        
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        for var index = lastPage+1; index < pageImages.count; ++index {
            removePageFromView(index)
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        loadPagesIntoView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
