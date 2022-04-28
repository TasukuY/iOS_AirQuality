//
//  CityDataViewController.swift
//  AirQuality
//
//  Created by Tasuku Yamamoto on 4/27/22.
//

import UIKit

class CityDataViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    
    //MARK: - Properties
    var country: String?
    var state: String?
    var city: String?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCityData()
    }

    //MARK: - Helper Methods
    func fetchCityData(){
        guard let city = city, let state = state, let country = country else { return }
        AirQualityController.fetchData(for: city, in: state, in: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityData):
                    self.updateViews(with: cityData)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }//End of function
    
    func updateViews(with cityData: CityData){
        print("Chinko!!!!!!!")
        let data = cityData.data
        let coordinates = data.location.coordinates
        if coordinates.count == 2 {
            latLongLabel.text = "Lat: \(coordinates[1]) \nLong: \(coordinates[0])"
        } else {
            latLongLabel.text = "Coordinates Unknown"
        }
        
        cityStateCountryLabel.text = "\(data.city), \(data.state), \(data.country)"
        aqiLabel.text = "AQI: \(data.current.pollution.airQualityIndex)"
        windspeedLabel.text = "Windspeed: \(data.current.weather.windSpeed)"
        tempLabel.text = "Temperature: \(data.current.weather.temperature)"
        humidityLabel.text = "Humidity: \(data.current.weather.humidity)"
    }
    
}//End of class
