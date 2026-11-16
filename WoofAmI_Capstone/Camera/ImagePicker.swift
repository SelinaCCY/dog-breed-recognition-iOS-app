//
//  ImagePicker.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 28/01/2024.
//

//upload image (image picker) functionality

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator  //object to receive  UIImagePickerController Event
        
        //done button
        imagePicker.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: context.coordinator,
            action: #selector(Coordinator.doneButtonTapped)
        )
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
}

//UIImagePickerController Event
class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var parent: ImagePicker
    
    init(_ picker: ImagePicker){
        self.parent = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, 
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //run the code when the user has selcted an image
        print("image selected")
        
        if let image = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage{
            
            //we are able to get the image
            DispatchQueue.main.async{
                self.parent.selectedImage = image
            }
            
        }
        //dismiss picker
        parent.isPickerShowing = false
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //run code when user has cancelled the picker
        print("cancelled")
        
        //dismiss picker
        dismissPicker()
    }
    
    func dismissPicker(){
        parent.isPickerShowing = false
    }
    
    @objc func doneButtonTapped() {
        dismissPicker()
    }
}


