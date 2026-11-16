//
//  PersistenceController.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 04/03/2024.
// reference: https://www.youtube.com/watch?v=O0FSDNOXCl0

import Foundation
import CoreData
import SwiftUI

class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false){
        container = NSPersistentContainer(name: "userDog")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores{storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

extension PersistenceController{
    
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
    //mock 10 objects
        for _ in 0..<10 {
            let newDogScanResult = DogScanResult(context: viewContext)
            newDogScanResult.id = UUID()
            newDogScanResult.dogName = "Doggo"
            newDogScanResult.breedName = "Sample Breed"
            
            if let image = UIImage(named: "poodle-test"),
               let imageData = image.jpegData(compressionQuality: 1.0){
                newDogScanResult.userImage = imageData
                print("Mock image data size: \(imageData.count) bytes") //print size of image 
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error \(error), \((error as NSError).userInfo)")
        }
        
        return controller
        
    }()
}
