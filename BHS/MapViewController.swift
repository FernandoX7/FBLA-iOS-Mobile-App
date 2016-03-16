//
//  MapViewController.swift
//  BHS
//
//  Created by Fernando Ramirez
//  Copyright (c) 2014 oXpheen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView:MKMapView!
    
    var activityList:ActivityList!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(activityList.location, completionHandler: { placemarks, error in
            if error != nil {
                println(error)
                return
            }
            
            if placemarks != nil && placemarks.count > 0 {
                let placemark = placemarks[0] as CLPlacemark
                
                // Add Annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.activityList.name
                annotation.subtitle = self.activityList.location
                annotation.coordinate = placemark.location.coordinate
                
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
                
            }
            
        })
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        leftIconView.image = UIImage(data: activityList.image)
        annotationView.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
