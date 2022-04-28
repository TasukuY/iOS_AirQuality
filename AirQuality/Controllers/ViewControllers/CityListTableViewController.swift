//
//  CityListTableViewController.swift
//  AirQuality
//
//  Created by Tasuku Yamamoto on 4/27/22.
//

import UIKit

class CityListTableViewController: UITableViewController {

    //MARK: - Properties
    var country: String?
    var state: String?
    var cities: [String] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCities()
    }

    //MARK: - Helper Methods
    func fetchCities(){
        guard let country = country,
              let state = state
        else { return }
        
        AirQualityController.fetchCities(for: state, in: country) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let cities):
                    self.cities = cities
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
        
    }//End of function
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel?.text = city
        
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCityDataVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? CityDataViewController
            else { return }
            
            let cityTosend = cities[indexPath.row]
            
            destination.country = country
            destination.state = state
            destination.city = cityTosend
        }
    }

}//End of class
