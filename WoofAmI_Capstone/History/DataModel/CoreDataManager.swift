//
//  CoreDataManager.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 04/03/2024.
//
// referred to https://developer.apple.com/documentation/swiftui/fetchrequest

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    init(){
        persistentContainer = NSPersistentContainer(name: "userDog")
        
        persistentContainer.loadPersistentStores{ (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    //logic to save scanned dog results
    func saveDogScanResult(dogName: String?, userImage: UIImage, breedName: String, confidence: Double?, completion: @escaping (Bool) -> Void){
        let context = persistentContainer.viewContext
        let newDogScanResult = DogScanResult(context: context)
        newDogScanResult.id = UUID()
        newDogScanResult.dogName = dogName
        newDogScanResult.breedName = breedName
        newDogScanResult.confidence = confidence ?? 0.0
        newDogScanResult.timestamp = Date()
        
        print("Saving dog scan result with timestamp: \(newDogScanResult.timestamp!)")
        
        if let imageData = userImage.jpegData(compressionQuality: 1.0){
            newDogScanResult.userImage = imageData
            print("Saving image data of size: \(imageData.count) bytes")
        } else {
            print("Could not convert UIImage to Data")
        }
        
        do {
            try context.save()
            completion(true)
        } catch {
            print ("Failed to save dog scan result: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    //logic to fetch scanned dog results
    func fetchDogScanResults() -> [DogScanResult]{
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<DogScanResult> = DogScanResult.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let results = try context.fetch(request)
            for result in results {
                if let imageData = result.userImage {
                    print("Fetched image data size: \(imageData.count) bytes")
                } else {
                    print("No image data for result with id: \(result.id?.uuidString ?? "unknown")")
                }
            }
            return results
            //return try context.fetch(request)
        } catch {
            print ("Failed to fetch dog scan results: \(error.localizedDescription)")
            return[] 
        }
    }
    
}
