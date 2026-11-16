//
//  BreedLoader.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 26/02/2024.
//

import Foundation

class BreedLoader{
    
    func loadBreedData() -> [DogBreedData]? {
        guard let url = Bundle.main.url(forResource: "breed_data", withExtension: "json") else {
            print("JSON file not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let breeds = try decoder.decode([DogBreedData].self, from: data)
            return breeds
        } catch{
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}


