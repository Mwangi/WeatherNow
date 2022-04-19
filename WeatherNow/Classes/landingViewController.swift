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
    @IBOutlet weak var lastupdateLbl: UILabel!
    
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
        
        var lastupdate = ""
        if(db.getLastUpdated() == ""){
            lastupdate = "N/A"
        }
        else{
            lastupdate = db.getLastUpdated()
        }
        lastupdateLbl.text = "Last Updated:\n\(lastupdate)"
        
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
        
        //MARK: Checks if one has internet connectivity before making call
        if (db.isConnectedToNetwork()){
            service.fetchcurrentweather(lat: lat, long: long)
        }
        else{
            //MARK: Get saved data
            temperatureLbl.text = db.gettemperatureLbl()
            minLbl.text = db.getminLbl()
            currentLbl.text = db.getcurrentLbl()
            maxLbl.text = db.getmaxLbl()
            currentcondition = db.getcurrentcondition()
            
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
            
            dayweatherarray = db.getdayweatherarray().components(separatedBy: ",")
            maxweatherarray = db.getmaxweatherarray().components(separatedBy: ",")
            typeweatherarray = db.gettypeweatherarray().components(separatedBy: ",")
            
            climatetableview.delegate = self
            climatetableview.dataSource = self
            climatetableview.tableFooterView = UIView(frame: CGRect.zero)
            climatetableview.reloadData()
        }
        
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
                        db.savecurrentcondition(currentcondition)
                    }
                    
                    print(status)
                    var currenttemperature = "", mintemperature = "", maxtemperature = ""
                    currenttemperature = "\(mainweather.temp!)"
                    mintemperature = "\(mainweather.temp_min!)"
                    maxtemperature = "\(mainweather.temp_max!)"
                    
                    temperatureLbl.text = "\(currenttemperature)°\n\(currentcondition)"
                    db.savetemperatureLbl("\(currenttemperature)°\n\(currentcondition)")
                    minLbl.text = "\(mintemperature)°\nmin"
                    db.saveminLbl("\(mintemperature)°\nmin")
                    currentLbl.text = "\(currenttemperature)°\nCurrent"
                    db.savecurrentLbl("\(currenttemperature)°\nCurrent")
                    maxLbl.text = "\(maxtemperature)°\nmax"
                    db.savemaxLbl("\(maxtemperature)°\nmax")
                    
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
                        dateweather = dateweather.convertDateString()!
                    
                        tempe = "\(weatherListing.main.temp!)"
                        print(tempe)
                        
                        //let maincondition = response.list
                        let maincondition = weatherListing.weather
                        
                        for weathertypeListing in maincondition{
                            conditionweather = weathertypeListing.main!
                            print(conditionweather)
                        }
                        
                        dayweatherarray.append(dateweather)
                        maxweatherarray.append(tempe)
                        typeweatherarray.append(conditionweather)
                    }
                    
                    print("\nDAYS: \(dayweatherarray)")
                    db.savedayweatherarray(dayweatherarray.joined(separator:","))
                    print("\nTEMP: \(maxweatherarray)")
                    db.savemaxweatherarray(maxweatherarray.joined(separator:","))
                    print("\nTYPE: \(typeweatherarray)")
                    db.savetypeweatherarray(typeweatherarray.joined(separator:","))
                    
                    climatetableview.delegate = self
                    climatetableview.dataSource = self
                    climatetableview.tableFooterView = UIView(frame: CGRect.zero)
                    climatetableview.reloadData()
                }
                else{
                    db.showAlerts("Error!", mg: "\nNo data found.", viewcontroller: self)
                }
                
                //Saves last updated once a successful network occurs
                db.saveLastUpdated(db.generateCurrentTimeStamp())
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
            
            if(typeweatherarray[indexPath.row] == "Cloudy" || typeweatherarray[indexPath.row] == "Clouds"){
                cell.imgweather.image = UIImage(named:"partlysunny")
            }
            else if(typeweatherarray[indexPath.row] == "Sunny" || typeweatherarray[indexPath.row] == "Sun"){
                cell.imgweather.image = UIImage(named:"clear")
            }
            else if(typeweatherarray[indexPath.row] == "Rainy" || typeweatherarray[indexPath.row] == "Rain"){
                cell.imgweather.image = UIImage(named:"rain")
            }
            
            cell.lbmax.text = maxweatherarray[indexPath.row]
           
        }
        return cell
    }

}

extension String {

    func convertDateString() -> String? {
        return convert(dateString: self, fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "EEEE")
    }

    func convert(dateString: String, fromDateFormat: String, toDateFormat: String) -> String? {

        let fromDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = fromDateFormat

        if let fromDateObject = fromDateFormatter.date(from: dateString) {

            let toDateFormatter = DateFormatter()
            toDateFormatter.dateFormat = toDateFormat

            let newDateString = toDateFormatter.string(from: fromDateObject)
            return newDateString
        }
        return nil
    }
}
