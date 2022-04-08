//
//  landingViewController.swift
//  WeatherNow
//
//  Created by Mwangi Gituathi on 4/8/22.
//

import UIKit
import CoreLocation

class landingViewController: UIViewController, ServiceCallDelegate {

    var db = InternalDB()
    let service = ServiceCall()
    var locationManager = CLLocationManager()
    
    var lat = "", long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        service.delegate = self
        
        //MARK: Getting user's co-ordinates
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            print(currentLoc.coordinate.latitude)
            print(currentLoc.coordinate.longitude)
            lat = String(format: "%f", currentLoc.coordinate.latitude)
            long = String(format: "%f", currentLoc.coordinate.longitude)
        }
        
        service.fetchcurrentweather(lat: lat, long: long)
    }
    
    func serviceCallStringResponse(ResultFromServer: String, RequestType: String) {
        parseResult(res: ResultFromServer, type: RequestType)
    }

    func parseResult(res: String, type: String){
         do{
             let data = res.data(using: String.Encoding.utf8)
    
             
//             if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any> {
//
//
//             }
         }
    }

    

}
