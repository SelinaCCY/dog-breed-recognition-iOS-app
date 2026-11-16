//
//  DogScanResult+CoreDataProperties.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 22/03/2024.
//
//

import Foundation
import CoreData


extension DogScanResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogScanResult> {
        return NSFetchRequest<DogScanResult>(entityName: "DogScanResult")
    }

    @NSManaged public var breedName: String?
    @NSManaged public var confidence: Double
    @NSManaged public var dogName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var userImage: Data?
    @NSManaged public var timestamp: Date?
    @NSManaged public var originalBreedIdentifier: String?

}

extension DogScanResult : Identifiable {

}
