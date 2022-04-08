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
    
    /*
    //MARK: Base64 Encryption: Currently not in use
     
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
        formatter.dateFormat = "dd/MM/yyyy hh.mm a"//08/07/2020 09.59 AM
        return (formatter.string(from: Date()) as NSString) as String
    }

}
