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
    
    //MARK: Current TimeStamp
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd/MM/yyyy hh.mm a"//08/07/2020 09.59 AM
        return (formatter.string(from: Date()) as NSString) as String
    }

}
