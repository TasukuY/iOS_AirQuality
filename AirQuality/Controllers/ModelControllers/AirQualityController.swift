//
//  AirQualityController.swift
//  AirQuality
//
//  Created by Tasuku Yamamoto on 4/27/22.
//

import Foundation

class AirQualityController {
    
    //MARK: - Properties
    static let baseURL = URL(string: "https://api.airvisual.com")
    static let versionComponent = "v2"
    static let countriesComponent = "countries"
    static let statesComponent = "states"
    static let citiesComponent = "cities"
    static let cityComponent = "city"
    
    //query keys
    static let countryKey = "country"
    static let stateKey = "state"
    static let cityKey = "city"
    
    //api key's key and value
    static let apiKeyKey = "key"
    static let apiKeyValue = "c5160553-74e3-47e8-bff0-fa49453f5d46"
    
    
    //http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    static func fetchCountries(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        //URL, Data task, Error and Response Handling, Data checking, Data Decoding
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let countriesURL = versionURL.appendingPathComponent(countriesComponent)
        //add query
        var components = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print("Final URL for the countries endpoint: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.throwError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Error Status of the country endpoint: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do{
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                let countryDicts = topLevelObject.data
                
                var listOfCountryNames: [String] = []
                
                for country in countryDicts {
                    let countryName = country.countryName
                    listOfCountryNames.append(countryName)
                }
                
                return completion(.success(listOfCountryNames))
                
            }catch let decodingError{
                return completion(.failure(.unableToDecode(decodingError)))
            }
            
        }.resume()
        
    }//End of function
    
    //http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchStates(for theCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        //URL, Data task, Error and Response Handling, Data checking, Data Decoding
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let statesURL = versionURL.appendingPathComponent(statesComponent)
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let countryApiQuery = URLQueryItem(name: countryKey, value: theCountry)
        let keyApiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [countryApiQuery, keyApiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print("Final URL for the states endpoint: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.throwError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Error Status of the states endpoint: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do{
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let stateDicts = topLevelObject.data
                
                var listOfStateNames: [String] = []
                
                for state in stateDicts {
                    let stateName = state.stateName
                    listOfStateNames.append(stateName)
                }
                
                return completion(.success(listOfStateNames))
                
            }catch let decodingError{
                return completion(.failure(.unableToDecode(decodingError)))
            }
            
        }.resume()
        
    }//End of function
    
    //http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchCities(for theState: String, in theCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let citiesURL = versionURL.appendingPathComponent(citiesComponent)
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let stateApiQuery = URLQueryItem(name: stateKey, value: theState)
        let countryApiQuery = URLQueryItem(name: countryKey, value: theCountry)
        let keyApiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [stateApiQuery, countryApiQuery, keyApiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print("Final URL for the cities endpoint: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.throwError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Error Status of the cities endpoint: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }

            do{
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let cityDicts = topLevelObject.data
                
                var listOfCityNames: [String] = []
                
                for city in cityDicts {
                    let cityName = city.cityName
                    listOfCityNames.append(cityName)
                }
                
                return completion(.success(listOfCityNames))
                
            }catch let decodingError{
                return completion(.failure(.unableToDecode(decodingError)))
            }
            
        }.resume()
        
    }//End of function
    
    //http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
    static func fetchData(for theCity: String, in theState: String, in theCountry: String, completion: @escaping (Result<CityData, NetworkError>) -> Void ){
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let cityURL = versionURL.appendingPathComponent(cityComponent)
        var components = URLComponents(url: cityURL, resolvingAgainstBaseURL: true)
        let cityApiQuery = URLQueryItem(name: cityKey, value: theCity)
        let stateApiQuery = URLQueryItem(name: stateKey, value: theState)
        let countryApiQuery = URLQueryItem(name: countryKey, value: theCountry)
        let keyApiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [cityApiQuery, stateApiQuery, countryApiQuery, keyApiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print("Final URL for the city data endpoint: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.throwError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Error Status of the city data endpoint: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do{
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                
                return completion(.success(cityData))
            }catch let decodingError{
                return completion(.failure(.unableToDecode(decodingError)))
            }
            
        }.resume()
        
    }//End of function
    
}//End of class
