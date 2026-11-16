//
//  CommunityViewControllerRepresentable.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 28/03/2024.
//

import Foundation
import SwiftUI
import UIKit

struct CommunityViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var postcode: String
    
    typealias UIViewControllerType = CommunityViewController
    
    func makeUIViewController(context: Context) -> CommunityViewController {
        let communityViewController = CommunityViewController()
        communityViewController.postcode = postcode
        return communityViewController
    }
    
    func updateUIViewController(_ uiViewController: CommunityViewController, context: Context){
        uiViewController.postcode = postcode
    }
}
