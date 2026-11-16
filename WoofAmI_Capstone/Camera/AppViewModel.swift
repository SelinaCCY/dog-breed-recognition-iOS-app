//
//  AppViewModel.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 19/02/2024.
//

//this view model holds the state for selectedImage, classifcation result, navigation to DogDetailView

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    
    @Published var selectedImage: UIImage?
    @Published var isImagePickerShowing = false
    @Published var classificationLabel = ""
    @Published var isClassifying = false
    @Published var classificationResult: ClassificationResult?{
        didSet{
            if classificationResult != nil{
                showDetail = true
            }
        }
    }
    
    @Published var showDetail = false
    
}
