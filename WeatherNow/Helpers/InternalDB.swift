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
    
    //Color Converter
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
    
    //Current TimeStamp
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd/MM/yyyy*hh.mm a"//08/07/2020 09.59 AM
        return (formatter.string(from: Date()) as NSString) as String
    }

}
