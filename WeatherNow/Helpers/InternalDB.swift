//
//  InternalDB.swift
//  WeatherNow
//
//  Created by Mwangi Gituathi on 4/8/22.
//

import Foundation
import SystemConfiguration
import LocalAuthentication
import UIKit

class InternalDB{
    
    let prefs:UserDefaults
    
    init(){
        prefs = UserDefaults.standard
    }
    
    //MARK: LOCAL DB
    func getAPIKEY()->String{
        let openweather_api = DecryptDataBase64("Mzk1YTgyZGZmMjI5N2Q4YjNhODkwMGVhMjAwMGMzZmM=")
        return openweather_api as String
    }
    
    //MARK: Default URL
    func getDefaultURL()->String{
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    func saveWeatherLocations(_ data:String){
        prefs.setValue(data, forKey: "LOCATIONS")
    }
    
    func getWeatherLocations()->String{
        let check=prefs.string( forKey: "LOCATIONS")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "LOCATIONS")!
    }
    
    func saveFavourites(_ data:String){
        prefs.setValue(data, forKey: "FAVOURITES")
    }
    
    func getFavourites()->String{
        let check=prefs.string( forKey: "FAVOURITES")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "FAVOURITES")!
    }
    
    func saveLastUpdated(_ data:String){
        prefs.setValue(data, forKey: "LASTUPDATED")
    }
    
    func getLastUpdated()->String{
        let check=prefs.string( forKey: "LASTUPDATED")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "LASTUPDATED")!
    }
    
    func savetemperatureLbl(_ data:String){
        prefs.setValue(data, forKey: "temperatureLbl")
    }
    
    func gettemperatureLbl()->String{
        let check=prefs.string( forKey: "temperatureLbl")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "temperatureLbl")!
    }
    
    func saveminLbl(_ data:String){
        prefs.setValue(data, forKey: "minLbl")
    }
    
    func getminLbl()->String{
        let check=prefs.string( forKey: "minLbl")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "minLbl")!
    }
    
    func savecurrentLbl(_ data:String){
        prefs.setValue(data, forKey: "currentLbl")
    }
    
    func getcurrentLbl()->String{
        let check=prefs.string( forKey: "currentLbl")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "currentLbl")!
    }
    
    func savemaxLbl(_ data:String){
        prefs.setValue(data, forKey: "maxLbl")
    }
    
    func getmaxLbl()->String{
        let check=prefs.string( forKey: "maxLbl")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "maxLbl")!
    }
    
    func savecurrentcondition(_ data:String){
        prefs.setValue(data, forKey: "currentcondition")
    }
    
    func getcurrentcondition()->String{
        let check=prefs.string( forKey: "currentcondition")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "currentcondition")!
    }
    
    func savedayweatherarray(_ data:String){
        prefs.setValue(data, forKey: "dayweatherarray")
    }
    
    func getdayweatherarray()->String{
        let check=prefs.string( forKey: "dayweatherarray")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "dayweatherarray")!
    }
    
    func savemaxweatherarray(_ data:String){
        prefs.setValue(data, forKey: "maxweatherarray")
    }
    
    func getmaxweatherarray()->String{
        let check=prefs.string( forKey: "maxweatherarray")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "maxweatherarray")!
    }
    
    func savetypeweatherarray(_ data:String){
        prefs.setValue(data, forKey: "typeweatherarray")
    }
    
    func gettypeweatherarray()->String{
        let check=prefs.string( forKey: "typeweatherarray")
        if check==nil {
            return ""
        }
        return prefs.string(forKey: "typeweatherarray")!
    }
  
    //MARK: Base64 Encryption: Currently not in use
    /*
    func EncryptDataBase64(_ DataToSend:String)->NSString{
        let DataToSend = DataToSend
        
        let plainData = (DataToSend as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        return base64String as NSString
        
    }
    */
    
    //MARK: Base64 Decryption
    func DecryptDataBase64(_ DataToSend:String)->NSString{
        let DataToSend = DataToSend
        
        let base64Decoded = Data(base64Encoded: DataToSend, options:   NSData.Base64DecodingOptions(rawValue: 0))
        
        let dataString = NSString(data: base64Decoded!, encoding:String.Encoding.utf8.rawValue)
        
        if(dataString==nil){
            return ""
        }
        return dataString!
        
    }
    
    //MARK: Color Formatter
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK: Current TimeStamp
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    //MARK: Just an alertview
    func showAlerts(_ tle:String,mg:String,viewcontroller:UIViewController){
        let alert = UIAlertController(title: tle, message: mg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler:nil)
        alert.addAction(action)
        viewcontroller.present(alert, animated: true, completion: nil)
    }

//    func ConvertDate(date:String) -> String{
//        //Date formatter
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE, MMM d"
//        formatter.date(from: date)
//        return date
//    }
    
    //MARK: Internet Connection Checker
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}
