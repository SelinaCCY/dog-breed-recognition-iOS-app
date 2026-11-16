//
//  HistoryListCell.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 23/01/2024.
//

import SwiftUI

struct HistoryListCell: View {
    let scannedDog: DogScanResult
    
    var body: some View {
        HStack{
            //load and display the user image from core data
            if let imageData = scannedDog.userImage, let uiImage = UIImage(data: imageData){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 90)
                    .clipShape(Circle())
            } else {
                Image("poodle-test") //placeholder image
                    .resizable()
                    .frame(width: 120, height: 90)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 5){
                Text(scannedDog.dogName ?? "Unknown Name")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text(scannedDog.breedName ?? "Unknown Breed")
                    .font(.title3)
                    .fontWeight(.medium)
            }
        }
    }
}

