//
//  DogAttributesView.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 26/02/2024.
//

import SwiftUI

struct DogAttributesView: View {
    
    var characteristics: Characteristics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AttributeView(icon: "dog.fill", attribute: "SIZE:", value: characteristics.size)
            AttributeView(icon: "pawprint.fill", attribute: "EXERCISE:", value: characteristics.exercise)
            AttributeView(icon: "house.fill", attribute: "SIZE OF HOME:", value: characteristics.sizeOfHome)
            AttributeView(icon: "scissors", attribute: "GROOMING:", value: characteristics.grooming)
            AttributeView(icon: "hare.fill", attribute: "COAT LENGTH:", value: characteristics.coatLength)
            AttributeView(icon: "allergens.fill", attribute: "SHEDS:", value: characteristics.sheds)
            AttributeView(icon: "heart.fill", attribute: "LIFESPAN:", value: characteristics.lifespan)
            AttributeView(icon: "leaf.fill", attribute: "SIZE OF GARDEN:", value: characteristics.sizeOfGarden)
        }
        .padding()
        .background(
            ZStack{
                Color("orange-light").opacity(0.7)
                
                Rectangle()
                    .fill(Material.ultraThinMaterial)
                
        
            })
        .cornerRadius(15)
        .padding()
    }
}

struct AttributeView: View {
    let icon: String
    let attribute: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
            Text(attribute)
                .bold()
            Spacer()
            Text(value)
                .foregroundColor(.black) 
        }
    }
}

#Preview {
    DogAttributesView(characteristics: Characteristics(
        size: "Small",
        exercise: "up to 1 hour per day",
        sizeOfHome: "Flat/Apartment",
        grooming: "More than once a week",
        coatLength: "Medium",
        sheds: "Yes",
        lifespan: "Over 12 years",
        sizeOfGarden: "Small"))
}

