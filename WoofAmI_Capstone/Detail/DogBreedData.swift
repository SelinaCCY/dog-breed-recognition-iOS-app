//
//  DogBreedData.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 25/02/2024.
//

//parse breedData.json into Swift Object

import Foundation

// characteristics
struct Characteristics: Decodable {
    
    let size: String
    let exercise: String
    let sizeOfHome: String
    let grooming: String
    let coatLength: String
    let sheds: String
    let lifespan: String
    let sizeOfGarden: String
    
    enum CodingKeys: String, CodingKey{
        
        case size = "Size"
        case exercise = "Exercise"
        case sizeOfHome = "Size of home"
        case grooming = "Grooming"
        case coatLength = "Coat length"
        case sheds = "Sheds"
        case lifespan = "Lifespan"
        case sizeOfGarden = "Size of garden"
        
    }
    
}

// main struct for each breed
struct DogBreedData: Decodable{
    
    let breedName: String
    let breedURL: String
    let imageURL: String
    let characteristics: Characteristics
    
    enum CodingKeys: String, CodingKey{
        
        case breedName = "Breed Name"
        case breedURL = "Breed URL"
        case imageURL = "Image URL"
        case characteristics = "Characteristics"
    }
}

//for decoding in array of breeds
typealias DogBreedDataArray = [DogBreedData]


