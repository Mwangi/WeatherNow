//
//  Colors.swift
//  WeatherNow
//
//  Created by Mwangi Gituathi on 4/8/22.
//

import Foundation
import UIKit

class Colors {
    
    let db = InternalDB()
    
    var colorRainy: UIColor!
    var colorSunny: UIColor!
    var colorCloudy: UIColor!
    
    init() {
        colorRainy = self.db.hexStringToUIColor(hex: "#57575D")
        colorSunny = self.db.hexStringToUIColor(hex: "#47AB2F")
        colorCloudy = self.db.hexStringToUIColor(hex: "#54717A")
    }
}
