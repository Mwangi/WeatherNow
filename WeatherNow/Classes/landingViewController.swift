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
    var dayweatherarray = [String]()
    var maxweatherarray = [String]()
    var typeweatherarray = [String]()
    
    var currentcondition = ""
    
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
    
    func serviceCallStringResponse(ResultFromServer: NSString, RequestType: String) {
        parseResult(res: ResultFromServer, type: RequestType)
    }
    
    func parseResult(res: NSString, type: String){
       
        let data = res.data(using: String.Encoding.utf8.rawValue)!
        
        let decoder = JSONDecoder()
        do {
            if(type == "CURRENT"){
                
                let response = try decoder.decode(CurrentWeatherItem.self, from: data)
                let status = response.cod!
                if(status == 200){
                    
                    let location = response.name!
                    let mainweather = response.main
                    
                    let maincondition = response.weather
                    
                    for weatherListing in maincondition{
                        let conditionweather = weatherListing.main
                        print(conditionweather!)
                        currentcondition = "\(conditionweather!)"
                    }
                    
                    print(status)
                    var currenttemperature = "", mintemperature = "", maxtemperature = ""
                    currenttemperature = "\(mainweather.temp!)"
                    mintemperature = "\(mainweather.temp_min!)"
                    maxtemperature = "\(mainweather.temp_max!)"
                    
                    temperatureLbl.text = "\(currenttemperature)°\n\(currentcondition)"
                    minLbl.text = "\(mintemperature)°\nmin"
                    currentLbl.text = "\(currenttemperature)°\nCurrent"
                    maxLbl.text = "\(maxtemperature)°\nmax"
                    
                    if(currentcondition == "Cloudy" || currentcondition == "Clouds"){
                        self.dataView.backgroundColor = color.colorCloudy
                        climateImg.image = UIImage(named:"Cloudy")
                    }
                    else if(currentcondition == "Sunny" || currentcondition == "Sun"){
                        self.dataView.backgroundColor = color.colorSunny
                        climateImg.image = UIImage(named:"Sunny")
                    }
                    else if(currentcondition == "Rainy" || currentcondition == "Rain"){
                        self.dataView.backgroundColor = color.colorRainy
                        climateImg.image = UIImage(named:"Rainy")
                    }
                    
                    //MARK: Network call to get forecast
                    service.fetchweatherforecast(lat: lat, long: long)
                    
                }
                else{
                    db.showAlerts("Error!", mg: "\nNo data found.", viewcontroller: self)
                }
            }
            else if(type == "FORECAST"){
                
                let response = try decoder.decode(Forecast.self, from: data)
                let status = response.cod!
                if(status == "200"){
                    
                    let listweather = response.list
                    
                    var dateweather = "", tempe = "", conditionweather = ""
                    
                    for weatherListing in listweather{
                        
                        dateweather = weatherListing.dt_txt!
                        print(dateweather)
                        
                        tempe = "\(weatherListing.main.temp!)"
                        print(tempe)
                        
                        let maincondition = response.list
                        for weatherListing in maincondition{
                            conditionweather = "\(weatherListing.main)"
                            print(conditionweather)
                            
                        }
                        
                        dayweatherarray.append(dateweather)
                        maxweatherarray.append(tempe)
                        typeweatherarray.append(conditionweather)
                    }
                    
                    print("\nDAYS: \(dayweatherarray)")
                    print("\nTEMP: \(maxweatherarray)")
                    print("\nTYPE: \(typeweatherarray)")
                    
                    climatetableview.delegate = self
                    climatetableview.dataSource = self
                    climatetableview.tableFooterView = UIView(frame: CGRect.zero)
                    climatetableview.reloadData()
                }
                else{
                    db.showAlerts("Error!", mg: "\nNo data found.", viewcontroller: self)
                }
            }
        }
        catch let error{
            print(error)
        }
    }
    
    //MARK: TableView Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var j:Int=0
        for t in (0 ..< dayweatherarray.count){
            if(dayweatherarray[t] != ""){
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
        if(dayweatherarray[indexPath.row] != ""){
            cell.lbmin.text = dayweatherarray[indexPath.row]
            cell.imgweather.image = UIImage(named:"rain")
            cell.lbmax.text = maxweatherarray[indexPath.row]
           
        }
        return cell
    }

}
