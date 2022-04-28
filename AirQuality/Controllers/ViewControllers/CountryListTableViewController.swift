//
//  CountryTableViewController.swift
//  AirQuality
//
//  Created by Tasuku Yamamoto on 4/27/22.
//

import UIKit

class CountryListTableViewController: UITableViewController {

    //MARK: - Properties
    var countries: [String] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
    }

    //MARK: - Helper Methods
    func fetchCountries() {
        AirQualityController.fetchCountries { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.countries = countries
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }//End of function
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country
        
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "toStateTVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? StateListTableViewController
            else { return }
            
            let countryToSend = countries[indexPath.row]
            destination.country = countryToSend
        }
    }

}//End of class
