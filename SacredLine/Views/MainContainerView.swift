//
//  MainContainerView.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//


import SwiftUI

struct MainContainerView: View {
    @State private var viewModel = MovieViewModel()
    
    var body: some View {
        TabView {
            Tab("Timeline", systemImage: "calendar.badge.clock") {
                TimelineView(viewModel: viewModel)
            }
            
            Tab("Tier", systemImage: "trophy.fill") {
                TierDashboardView(viewModel: viewModel)
            }
            
            Tab("Stats", systemImage: "chart.pie.fill") {
                MultiverseStatsView(viewModel: viewModel)
            }
        }
        .accentColor(.white)
    }
}

#Preview {
    MainContainerView()
}
