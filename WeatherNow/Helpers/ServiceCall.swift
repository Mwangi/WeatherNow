//
//  ServiceCall.swift
//  WeatherNow
//
//  Created by Mwangi Gituathi on 4/8/22.
//

import Foundation
import UIKit

class ServiceCall{
    
    var window: UIWindow?
    
    //MARK: Variables
    let requestTimeoutInterval = 60
    let errorMessage = "There was an error, please try again"
    var ReturnData: NSString = ""
    var requeststr = "", requesttype = ""
    
    var delegate: ServiceCallDelegate?
    var db = InternalDB()
    
    func fetchcurrentweather(lat:String, long:String){
        requesttype = "CURRENT"
        requeststr = "weather?lat=\(lat)&lon=\(long)&appid=\(db.getAPIKEY())"
        ConnectToService(requeststr: requeststr)
    }
    
    func fetchweatherforecast(lat:String, long:String){
        requesttype = "FORECAST"
        requeststr = "forecast?lat=\(lat)&lon=\(long)&appid=\(db.getAPIKEY())"
        ConnectToService(requeststr: requeststr)
    }
    
    func ConnectToService(requeststr: String){
        
        var urlstr=""
    
        urlstr = "\(db.getDefaultURL())\(self.requeststr)"
        print("Request String: \(urlstr)")
        let url: URL = URL(string:urlstr)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 120
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                DispatchQueue.main.async(execute: {
                    //Error Occurred
                    print("error=\(error)")
                    
                    let alert=UIAlertController(title: "Error!", message: self.errorMessage, preferredStyle: .alert)
                    
                    let action=UIAlertAction(title: "GOT IT", style: .default, handler:{ action in
                        DispatchQueue.main.async(execute: {
                        })
                    })
                    
                    alert.addAction(action)
                    
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                print("response = \(response)")
                
                let alert=UIAlertController(title: "Error!", message: self.errorMessage, preferredStyle: .alert)
                
                let action=UIAlertAction(title: "GOT IT", style: .default, handler:{ action in
                    DispatchQueue.main.async(execute: {
                    })
                })
                
                alert.addAction(action)
                
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                
                return
            }
            else {
                DispatchQueue.main.async(execute: {
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("ResponseString: \(responseString!)")
                    
                    if(responseString==nil){
                        let alert=UIAlertController(title: "Error!", message: self.errorMessage, preferredStyle: .alert)
                        
                        let action=UIAlertAction(title: "GOT IT", style: .default, handler:{ action in
                            DispatchQueue.main.async(execute: {
                            })
                        })
                        
                        alert.addAction(action)
                        
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                    else{
                        self.ReturnData = responseString! as NSString
                        if(self.ReturnData.contains("<")){
                            let i=self.ReturnData.range(of: "<").location
                            self.ReturnData=self.ReturnData.substring(to: i) as NSString
                            
                        }
                        self.ReturnData = self.ReturnData.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
                        
                        if self.ReturnData.length < 3{
                            let alert=UIAlertController(title: "Error!", message: self.errorMessage, preferredStyle: .alert)
                            
                            let action=UIAlertAction(title: "GOT IT", style: .default, handler:{ action in
                                DispatchQueue.main.async(execute: {
                                })
                            })
                            
                            alert.addAction(action)
                            
                            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                        else {
                            self.ProcessResponse(ResultFromServer: self.ReturnData)
                        }
                    }
                    
                })
            }
        }
        task.resume()
    }
    
    func ProcessResponse(ResultFromServer: NSString){
        
        self.delegate?.serviceCallStringResponse(ResultFromServer: ResultFromServer as String, RequestType: requesttype)
        
    }

}

public protocol ServiceCallDelegate {
    func serviceCallStringResponse(ResultFromServer: String, RequestType: String)
}
