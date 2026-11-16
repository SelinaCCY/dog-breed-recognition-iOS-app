//
//  CameraControllerDelegate.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 29/01/2024.
//

import Foundation
import UIKit

protocol CameraControllerDelegate: AnyObject {
    //handle photo captured by user
    func didCapturePhoto(_ image: UIImage)
    
    //handle chosen photo by user
    func didTapChoosePhoto()
}
