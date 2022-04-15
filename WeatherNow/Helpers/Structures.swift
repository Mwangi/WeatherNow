//
//  Structures.swift
//  WeatherNow
//
//  Created by Mwangi Gituathi on 4/13/22.
//

import Foundation

public struct CurrentWeatherItem: Codable{
    //var coord: String?
    var weather: [MainWeather]
    //var base: String?
    var main: MainItem
    //var visibility: Int?
    //var wind: String?
    //var clouds: String?
    //var dt: Int?
    //var sys: Int?
    //var timezone: Int?
    //var id: Int?
    var name: String?
    var cod: Int? //Status
}

struct MainItem: Codable{
    //var feels_like: Double?
    //var humidity: Double?
    //var pressure: Double?
    //var sea_level: Double?
    var temp: Double?
    var temp_max: Double?
    var temp_min: Double?
}

struct MainWeather: Codable{
    //var id: Double?
    var main: String?
    //var description: String?
    //var icon: String?
}

struct Forecast: Codable{
    var cod: String?
    var list: [ListForecastWeather]
}

struct ListForecastWeather: Codable{
    //Just added the values I will need
    var weather: [MainWeather]
    var dt_txt: String?
    var main: MainItem
}

struct WeatherList: Codable{
    var main: MainItem
}



