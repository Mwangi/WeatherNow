//
//  landingViewController.swift
//  WeatherNow
//
//  Created by Mwangi Gituathi on 4/8/22.
//

import UIKit
import CoreLocation

class landingViewController: UIViewController, ServiceCallDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var climateImg: UIImageView!
    @IBOutlet weak var climatetableview: UITableView!
    @IBOutlet weak var temperatureLbl: UILabel!
    
    @IBOutlet weak var minLbl: UILabel!
    @IBOutlet weak var currentLbl: UILabel!
    @IBOutlet weak var maxLbl: UILabel!
    
    var db = InternalDB()
    let service = ServiceCall()
    let color = Colors()
    var locationManager = CLLocationManager()
    
    let basicCellIdentifier = "basicCell"
    var minweatherarray = [String]()
    var maxweatherarray = [String]()
    
    var temp = "25"
    
    var lat = "", long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        service.delegate = self
        
        temperatureLbl.text = "\(temp)°\nSUNNY"
        self.dataView.backgroundColor = color.colorSunny
        
        minLbl.text = "\(temp)°\nmin"
        currentLbl.text = "\(temp)°\nCurrent"
        maxLbl.text = "\(temp)°\nmax"
        
        minweatherarray = ["Wednesday", "Saturday", "Sunday"]
        maxweatherarray = ["32°", "43°", "56°"]
        // If rainy
        //climateImg.image = UIImage(named:"Rainy")
        
        // If Sunny
        climateImg.image = UIImage(named:"Sunny")
        
        // If Cloudy
        //climateImg.image = UIImage(named:"Cloudy")
        
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
        
        climatetableview.delegate = self
        climatetableview.dataSource = self
        climatetableview.tableFooterView = UIView(frame: CGRect.zero)
        climatetableview.reloadData()
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

    //MARK: TableView Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var j:Int=0
        for t in (0 ..< minweatherarray.count){
            if(minweatherarray[t] != ""){
                j += 1
            }
            
        }
        return j
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return basicCellAtIndexPath(indexPath)
    }
    
    func basicCellAtIndexPath(_ indexPath:IndexPath) -> weatherTableViewCell {
        let cell = climatetableview.dequeueReusableCell(withIdentifier: basicCellIdentifier) as! weatherTableViewCell
        if(minweatherarray[indexPath.row] != ""){
            cell.lbmin.text = minweatherarray[indexPath.row]
            cell.imgweather.image = UIImage(named:"rain")
            cell.lbmax.text = maxweatherarray[indexPath.row]
           
        }
        return cell
    }

}
