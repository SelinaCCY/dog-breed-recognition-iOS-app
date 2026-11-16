//
//  CommunityView.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 21/01/2024.
// the code relating to community tab is widely adapted from https://www.youtube.com/watch?v=YCmZayf7Zi4

import SwiftUI
import UIKit
import MapKit
import CoreLocation

struct CommunityView: View {
    
    @State private var postcode: String = ""
    
    var body: some View {
        NavigationView{
            VStack{
                Text("You can search for your nearest vet and animal shelters here!")
                    .padding()
                
                TextField("Enter your postcode", text: $postcode)
                    //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.orange)
                    )
                    .padding(.horizontal)
                
                CommunityViewControllerRepresentable(postcode: $postcode)
                    .edgesIgnoringSafeArea(.all)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Community📍")
            .navigationBarTitleDisplayMode(.automatic)
            
        }
    }
}

#Preview {
    CommunityView()
}
