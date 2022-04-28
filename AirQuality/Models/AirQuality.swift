//
//  AirQuality.swift
//  AirQuality
//
//  Created by Tasuku Yamamoto on 4/27/22.
//

import Foundation

struct Country: Decodable {
    let data: [Data]
    
    struct Data: Decodable {
        let countryName: String
        
        enum CodingKeys: String, CodingKey {
            case countryName = "country"
        }
    }//End of Data struct Data
}//End of struct Country

struct State: Decodable {
    let data: [Data]
    
    struct Data: Decodable {
        let stateName: String
        
        enum CodingKeys: String, CodingKey {
            case stateName = "state"
        }
    }//End of struct Data
}//End of struct State

struct City: Decodable {
    let data: [Data]
    
    struct Data: Decodable {
        let cityName: String
        
        enum CodingKeys: String, CodingKey {
            case cityName = "city"
        }
    }//End of struct Data
}//End of struct City

struct CityData: Decodable {
    let data: Data
    
    struct Data: Decodable {
        let city: String
        let state: String
        let country: String
        
        let location: Location
        struct Location: Decodable {
            let coordinates: [Double]
        }//End of struct Location
        
        let current: Current
        struct Current: Decodable {
            let weather: Weather
            struct Weather: Decodable {
                let temperature: Int
                let humidity: Int
                let windSpeed: Double
                
                enum CodingKeys: String, CodingKey {
                    case temperature = "tp"
                    case humidity = "hu"
                    case windSpeed = "ws"
                }
            }//End of struct Weather
            
            let pollution: Pollution
            struct Pollution: Decodable {
                let airQualityIndex: Int
                
                enum CodingKeys: String, CodingKey {
                    case airQualityIndex = "aqius"
                }
            }//End of struct Pollution
        }//End of struct Current
    }//End of struct Data
}//End of struct CityData
