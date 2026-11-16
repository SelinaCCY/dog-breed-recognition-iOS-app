//
//  CameraTabView.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 28/01/2024.
//
// Code regarding to camera functionality is adapted from https://www.youtube.com/watch?v=ZYPNXLABf3c
// Code regarding to image picker functionality is adapted from https://www.youtube.com/watch?v=crULPMS7Uxs&t=385s

import SwiftUI
import Vision

struct CameraTabView: View {
    
    @ObservedObject var viewModel: AppViewModel
    
    private let dogBreedClassifier = DogBreedClassifier()
    
    var body: some View {
        NavigationStack{
            VStack{
                CameraView(selectedImage: $viewModel.selectedImage,
                           isImagePickerShowing: $viewModel.isImagePickerShowing)
                .sheet(isPresented: $viewModel.isImagePickerShowing) {
                    ImagePicker(selectedImage: $viewModel.selectedImage,
                                isPickerShowing: $viewModel.isImagePickerShowing)
                    }
                
                //display classifcation results
                if !viewModel.classificationLabel.isEmpty{
                    Text(viewModel.classificationLabel)
                        .padding()
                }
                
                //show a loading indicator when classifying
                if viewModel.isClassifying{
                    ProgressView("Classifying...")
                }
            }
            
            .onChange(of: viewModel.selectedImage) { _ in
                classifyImage()
            }
            //auto navigation
            .sheet(isPresented: $viewModel.showDetail) {
                //valid data before navigating
                if let result = viewModel.classificationResult, let image = viewModel.selectedImage{
                    DogDetailView(classificationResult: result, userImage: image, breedURL: "https://www.thekennelclub.org.uk/search/breeds-a-to-z/")
                } else {
                    Text("Missing data")
                }
            }
            }
        }
                
    private func classifyImage(){
        guard let image = viewModel.selectedImage else {return}
        
        //indicate that classification has started
        viewModel.isClassifying = true
        
        dogBreedClassifier.classify(image: image){ result in
            DispatchQueue.main.async{
                
                //classification is complete
                self.viewModel.isClassifying = false
                
                switch result{
                case .success(let classification):
                    self.viewModel.classificationLabel = "Breed: \(classification.breed), Confidence: \(classification.confidence)"
                    self.viewModel.classificationResult = ClassificationResult(breed: classification.breed, confidence: classification.confidence)
                    //viewModel.showDogDetailView = true //trigger navigation
                    self.viewModel.showDetail = true
                case .failure(let error):
                    self.viewModel.classificationLabel = "Classification failed: \(error.localizedDescription)"
                }
            }
            
        }
    }
}


#Preview {
    CameraTabView(viewModel: AppViewModel())
}
