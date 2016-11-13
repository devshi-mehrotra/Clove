//
//  CompanyListViewController.swift
//  YHackProject
//
//  Created by techbar on 11/11/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import Parse

//import CoreLocation

class CompanyListViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?

    var searchController: UISearchController?
    
    let locationManager = CLLocationManager()
    
    var compArray: [Company] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        //self.mapView.showsUserLocation = true
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // set initial location in Honolulu
        //let initialLocation = CLLocation(latitude: 41.31, longitude: -72.93)
        //centerMapOnLocation(location: initialLocation)
        
        /*let comp1 = Company.init(myName: "J Crew", myAddress: "29 Broadway, New Haven, CT 06511", myCoordinate: CLLocationCoordinate2DMake(41.311419, -72.930305))
        let comp2 = Company.init(myName: "Walgreens", myAddress: "88 York Street, New Haven, CT 06511", myCoordinate: CLLocationCoordinate2DMake(41.306132, -72.934032))
        let comp3 = Company.init(myName: "Apple", myAddress: "65 Broadway, New Haven, CT 06511", myCoordinate: CLLocationCoordinate2DMake(41.312002, -72.930683))
        let comp4 = Company.init(myName: "Foot Locker", myAddress: "832 Chapel Street, New Haven, CT 06511", myCoordinate: CLLocationCoordinate2DMake(41.305423, -72.924899))
        
        compArray = [comp1, comp2, comp3, comp4]
        */
        
        let query = PFQuery(className: "Company")
        
        query.findObjectsInBackground { (company: [PFObject]?, error: Error?) -> Void in
            if let company = company {
                for c in company {
                    var co = Company()
                    let name = (c["name"] as! String)
                    co.name = name
                    let coor = CLLocationCoordinate2DMake(c["lat"] as! CLLocationDegrees, c["long"] as! CLLocationDegrees)
                    co.coordinate = coor
                    co.image = (c["media"] as! PFFile)
                    self.compArray.append(co)
                    //print(co.name)
                    //print(co.coordinate)
                }
            } else {
                print(error?.localizedDescription)
            }
            
            var anotherDropPins: [MKPointAnnotation] = []
            
            print("before createPins called")
            
            anotherDropPins = self.createPins(companies: self.compArray)
            
            for pin in anotherDropPins {
                print("drop")
                self.mapView.addAnnotation(pin)
            }
            
        }

    }
    
    let regionRadius: CLLocationDistance = 10
    func centerMapOnLocation(locationCoord: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(locationCoord,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        print(location!)
        
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createPins(companies: [Company]) -> [MKPointAnnotation]{
        
        print("coordinates!")
        for c in companies {
            print(c.coordinate)
        }
        
        var dropPins: [MKPointAnnotation] = []
        
        for i in 0..<companies.count {
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = companies[i].coordinate!
            dropPin.title = companies[i].name
            //dropPin.subtitle = String(i)
            dropPins.append(dropPin)
        }
        
        return dropPins
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if (annotation is MKUserLocation)
        {
            return nil
        }
        if(annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "MapToPostSegue", sender: view.annotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let anno = sender as! MKPointAnnotation
        let title = anno.title as! String!
        //let index = Int(anno.subtitle!)
        let destinationVC = segue.destination as! CreatePostViewController
        destinationVC.compName = title
        //destinationVC.company = compArray[index!]
    }
    

}
// Handle the user's selection.
extension CompanyListViewController: GMSAutocompleteResultsViewControllerDelegate {
    /**
     * Called when a non-retryable error occurred when retrieving autocomplete predictions or place
     * details. A non-retryable error is defined as one that is unlikely to be fixed by immediately
     * retrying the operation.
     * <p>
     * Only the following values of |GMSPlacesErrorCode| are retryable:
     * <ul>
     * <li>kGMSPlacesNetworkError
     * <li>kGMSPlacesServerError
     * <li>kGMSPlacesInternalError
     * </ul>
     * All other error codes are non-retryable.
     * @param resultsController The |GMSAutocompleteResultsViewController| that generated the event.
     * @param error The |NSError| that was returned.
     */
    public func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController!,
                           didAutocompleteWith place: GMSPlace!) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        
        centerMapOnLocation(locationCoord: place.coordinate)
    }
    
    
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
