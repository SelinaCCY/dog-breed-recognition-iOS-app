//
//  HistoryView.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 21/01/2024.
//
// code relating to CoreData adapted from tutorial https://www.youtube.com/watch?v=O0FSDNOXCl0
// History is a List view that contains the history of scanned dogs

import SwiftUI
import CoreData

struct HistoryView: View {
    
    //fetch request to fetch DogScanResults entities
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DogScanResult.timestamp, ascending: false)],
        animation: .default)
    
    private var scannedDogs: FetchedResults<DogScanResult>
    
    var body: some View {

        NavigationView{
            
            VStack{
               Text("You can revisit the furry friends that you had scanned previously from here!")
                
                List{
                    ForEach(scannedDogs, id: \.self){ scannedDog in
                        NavigationLink(destination: DogDetailView(dogScanResult: scannedDog, breedURL: "https://www.thekennelclub.org.uk/search/breeds-a-to-z/")) {
                            HistoryListCell(scannedDog: scannedDog)
                        }
                        .onAppear{
                            if let imageData = scannedDog.userImage {
                                print("Fetched image data of size from History View: \(imageData.count) bytes")
                            } else {
                                print("no image data fetched for dog ID History View: \(scannedDog.id?.uuidString ?? "unknown")")
                            }
                        }
                    }
                }
                .navigationTitle("Woof-tory📖")
    
            }
            
        }
        
    }
}

#Preview {
    HistoryView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
