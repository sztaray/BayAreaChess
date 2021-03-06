//
//  TournamentInformation.swift
//  BayAreaChess
//
//  Created by Carlos Reyes on 7/1/15.
//  Copyright (c) 2015 Carlos Reyes. All rights reserved.
//

import AddressBook
import CoreLocation
import MapKit
import SwiftHTTP
import UIKit
import SwiftyJSON

class TournamentInformation: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var myDateLabel : UILabel?
    @IBOutlet var myDescriptionTextView : UITextView?
    @IBOutlet var myCaption: UILabel?
    @IBOutlet var myLocationLabel : UILabel?
    @IBOutlet var myTournamentNameLabel : UILabel?

    var myDate: String = String()
    var myEventName : String = String()
    var myIndex : Int = Int()
    var myLocation : String = String()
    var myLocationManager : CLLocationManager = CLLocationManager()
    var myRegistrationLink : String = String()
    var myTID : String = String()

    let regionRadius: CLLocationDistance = 15000
    let sanFrancisco = CLLocation(latitude: 37.71, longitude: -122.42)
    
    struct Event {
        let info : String?
        let flyer : String?
        let registration : String?
        let entries : String?
        let contact : String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTournamentData(myTID)
        mapView.delegate = self
        navigationController?.hidesBarsOnTap = true
        myTournamentNameLabel?.text = myEventName
        myDateLabel?.text = myDate
//        centerOnPlacemark(myLocation)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        checkLocationAuthorizationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.hidesBarsOnSwipe = false
        myCaption?.text = String(myIndex)
        self.mapView.zoomEnabled = false
        self.mapView.scrollEnabled = false
    }
    
    func getTournamentData(tid: String) {
        var request = HTTPTask()
        request.GET(Constants.URL.GENERAL_TOURNAMENTS + "/" + tid, parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                dispatch_async(dispatch_get_main_queue()) {
                    let json = JSON(data: data)
                    self.loadJSON(json)
                    self.centerOnPlacemark(self.myLocation)
//                    self.tableView.reloadData()
                }
            }
            })
    }
    
    func getLocation(json: JSON) -> String {
        var location : String? = json[Constants.Location.Location].string
        return location != nil ? location! : ""
        
    }
    
    func getDescription(json: JSON) -> String {
        var description : String? = json[Constants.Key.Description].string
        
        var m = description?.componentsSeparatedByString("\n")
        var c = toDictionary(m!)
        
        self.myRegistrationLink = (c[Constants.Key.Register] != nil ? c[Constants.Key.Register]! : "http://bayareachess.com/mtype/")
        
        return description != nil ? description! : ""
    }
    
    func toDictionary(array: Array<String>) -> Dictionary<String, String> {
        var dict : Dictionary<String, String> = Dictionary()
        
        for item in array {
            var obj = item.componentsSeparatedByString(": ")
            if (obj.count > 1) {
                dict[obj[0]] = obj[1]
            }
        }
        
        return dict
    }
    
    func loadJSON(json: JSON) {
        self.myLocation = self.getLocation(json)
        self.myLocationLabel?.text = self.myLocation
        self.myDescriptionTextView?.text = self.getDescription(json)
    }
    
    //Maps support
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerOnPlacemark(address: String) {
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                let location = placemark.location
                let coordinates = MKCoordinateRegionMakeWithDistance(location.coordinate, self.regionRadius * 2.0, self.regionRadius * 2.0)
                
                self.addEventAnnotation(coordinates, eventName: self.myEventName, city: placemark.addressDictionary[Constants.Location.City] as! String)
                self.mapView.setRegion(coordinates, animated: true)
                
            }
            else {
                self.centerMapOnLocation(self.sanFrancisco)
            }
        })
    }
    
    func addEventAnnotation (coordinate: MKCoordinateRegion, eventName: String, city: String) {
        let eventAnnotation : TournamentLocationAnnotation = TournamentLocationAnnotation(title: eventName, locationName: city, discipline: Constants.Location.Sculpture, coordinate: CLLocationCoordinate2D(latitude: coordinate.center.latitude, longitude: coordinate.center.longitude))
        
        mapView.addAnnotation(eventAnnotation)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            myLocationManager.requestWhenInUseAuthorization()
        }
    }
    
}