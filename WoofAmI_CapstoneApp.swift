//
//  WoofAmI_CapstoneApp.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 21/01/2024.
//

import SwiftUI

@main
struct WoofAmI_CapstoneApp: App {
    @StateObject private var viewModel = AppViewModel()
    let coreDataManager = CoreDataManager.shared
    
    init() {
        setupTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            TabMainView(viewModel: viewModel)
                .environment(\.managedObjectContext, coreDataManager.persistentContainer.viewContext)
        }
    }
    
    private func setupTabBarAppearance(){
        let apperance = UITabBarAppearance()
        apperance.backgroundColor = UIColor.systemGray5
        UITabBar.appearance().standardAppearance = apperance
        if #available(iOS 17.0, *){
            UITabBar.appearance().scrollEdgeAppearance = apperance
        }
    }
}
