//
//  DogBreedClassifier.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 31/01/2024.
// adapted from https://developer.apple.com/documentation/coreml/integrating_a_core_ml_model_into_your_app
// initializing the ML model

import Foundation
import CoreML
import Vision
import UIKit

class DogBreedClassifier{
    
    private let model: VNCoreMLModel
    
    init(){
        //load model
        do{
            let modelURL = dogBreedRecognitionUpdated.urlOfModelInThisBundle
            let compileModel = try MLModel(contentsOf: modelURL)
            self.model = try VNCoreMLModel(for: compileModel)
        } catch {
            print("Error loading model: \(error)")
            fatalError("Could not load model")
        }
        
    }
    
    //takes in a UIImage and a completiomn handler that provides the breed
    func classify(image: UIImage, completion: @escaping (Result<(breed: String, confidence: Float), Error>) -> Void){
        
        //convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else{
            completion(.failure(ClassificationError.invalidImage))
            return
        }
        
        //create a Core ML Vision request
        let request = VNCoreMLRequest(model: model){
            [weak self] request, error in
            //check for error
            if let error = error{
                completion(.failure(error))
                return
            }
            //process the results
            self?.processResults(from: request, completion: completion)
        }
        request.imageCropAndScaleOption = .centerCrop
        
        //run vision request
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: image.cgImageOrientation)
        DispatchQueue.global(qos: .userInitiated).async{
            do{
                try handler.perform([request])
            } 
            catch{
                completion(.failure(error))
            }
        }
        
    }
    
    private func processResults(from request: VNRequest, completion: (Result<(breed: String, confidence: Float), Error>) -> Void){
        //process results of request
        guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else{
            completion(.failure(ClassificationError.noResults))
            return
        }
        
        //completion handler provides breed
        completion(.success((breed: topResult.identifier, confidence: topResult.confidence)))
    }
    
    enum ClassificationError: Error{
        case invalidImage
        case noResults
    }
}

// Helper extension to handle image orientation conversion between UIImage and CIImage.
extension UIImage {
    var cgImageOrientation: CGImagePropertyOrientation {
        return CGImagePropertyOrientation(rawValue: UInt32(imageOrientation.rawValue))!
    }
}
