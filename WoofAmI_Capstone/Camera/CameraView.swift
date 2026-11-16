//
//  CameraView.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 21/01/2024.
//

//integrated both camera and image picker together

import SwiftUI
import AVFoundation
import UIKit

struct CameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerShowing: Bool
    
    func makeUIViewController(context: Context) -> CameraController {
        let cameraController = CameraController()
        cameraController.delegate = context.coordinator
        return cameraController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //no update
    }
    
    //communicate both
    typealias UIViewControllerType = CameraController
    
    //coordinator class for delegation
    final class Coordinator: NSObject, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate, CameraControllerDelegate{
        
        //handling image captured
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        // UIImagePickerControllerDelegate methods
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            if let image = info[.originalImage] as? UIImage {
                        parent.selectedImage = image
                    }
            parent.isImagePickerShowing = false
            picker.dismiss(animated: true)
                }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerShowing = false
            picker.dismiss(animated: true)
                }
        
        func didCapturePhoto(_ image: UIImage) {
            parent.selectedImage = image
        }
        
        //camera controller delegate method
        func didTapChoosePhoto(){
            print("Presenting image picker")
            DispatchQueue.main.async{
                self.parent.isImagePickerShowing = true
            }
            
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}
