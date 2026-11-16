//
//  ContentView.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 21/01/2024.
//

import SwiftUI

struct TabMainView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        
        TabView{
            HistoryView()
                .tabItem {
                    Image(systemName: "book")
                    Text("History")
                }
            
            CameraTabView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "camera")
                    Text("Camera")
                }
            
            CommunityView()
                .tabItem {
                    Image(systemName: "shared.with.you")
                    Text("Community")
                }
            
        }
        .accentColor(Color("orange-bright"))
        
    }
}

#Preview {
    TabMainView(viewModel: AppViewModel())
}
