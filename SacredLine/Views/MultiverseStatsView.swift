//
//  MultiverseStatsView.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI

struct MultiverseStatsView: View {
    var viewModel: MovieViewModel
    @State private var animateGlow: Bool = false
    @State private var activeSheetFilter: StatsDetailType? = nil
    @State private var showPortalSheet: Bool = false
    
    // State buat Random Mission & Efek Portal Loading
    @State private var randomPickedMovie: MarvelMovie? = nil
    @State private var isSpinningPortal: Bool = false
    @State private var portalStatusText: String = "Calibrating multiverse frequencies..."
    
    enum StatsDetailType: Identifiable {
        case completed, ranked, sTier, rewatchable
        var id: Self { self }
        
        var title: String {
            switch self {
            case .completed: return "Watched Missions Ledger"
            case .ranked: return "Ranked Classifications"
            case .sTier: return "S-Tier Masterpieces"
            case .rewatchable: return "Rewatchable Favorites"
            }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "1F0608"), Color(hex: "0A0102"), Color(hex: "050000")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(Color(hex: "AE0F1C").opacity(0.28))
                .frame(width: 380, height: 380)
                .blur(radius: 90)
                .offset(x: animateGlow ? 120 : -120, y: animateGlow ? -200 : 200)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animateGlow)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    // Header Title
                    VStack(spacing: 6) {
                        Text("MULTIVERSE STATS")
                            .font(.custom("Georgia", size: 28, relativeTo: .title))
                            .bold()
                            .foregroundColor(.white)
                            .tracking(4)
                        
                        Text("Watcher's Analytics & Archives")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                            .tracking(2)
                            .textCase(.uppercase)
                    }
                    .padding(.top, 20)
                    
                    // Stats Grid
                    let sTierCount = viewModel.movies.filter { $0.tier == .s }.count
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        MagicalStatCard(
                            title: "Total Progress",
                            value: String(viewModel.completionPercentage) + "%",
                            subtitle: String(viewModel.completedCount) + " of " + String(viewModel.movies.count) + " Watched",
                            icon: "checkmark.seal.fill",
                            accentColor: .green,
                            action: { activeSheetFilter = .completed }
                        )
                        
                        MagicalStatCard(
                            title: "Ranked Missions",
                            value: String(viewModel.rankedCount),
                            subtitle: "Logged in Tiers",
                            icon: "star.fill",
                            accentColor: .yellow,
                            action: { activeSheetFilter = .ranked }
                        )
                        
                        MagicalStatCard(
                            title: "Elite S-Tier",
                            value: String(sTierCount),
                            subtitle: "Masterpiece Films",
                            icon: "trophy.fill",
                            accentColor: Color(hex: "AE0F1C"),
                            action: { activeSheetFilter = .sTier }
                        )
                        
                        MagicalStatCard(
                            title: "Would Rewatch",
                            value: String(viewModel.rewatchableCount),
                            subtitle: "Favorite Replays",
                            icon: "arrow.clockwise.circle.fill",
                            accentColor: .cyan,
                            action: { activeSheetFilter = .rewatchable }
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Portal Button dengan Efek Transisi Animasi
                    Button(action: {
                        triggerCosmicPortalSummon()
                    }) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "AE0F1C").opacity(0.3))
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: "sparkles.rectangle.stack.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(isSpinningPortal ? 360 : 0))
                                    .animation(isSpinningPortal ? Animation.linear(duration: 0.8).repeatForever(autoreverses: false) : .default, value: isSpinningPortal)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Watcher's Random Portal")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Tap to open a cosmic rift for your next watch.")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Image(systemName: isSpinningPortal ? "circle.dashed" : "dice.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "AE0F1C"))
                                .rotationEffect(.degrees(isSpinningPortal ? 360 : 0))
                                .animation(isSpinningPortal ? Animation.linear(duration: 0.6).repeatForever(autoreverses: false) : .default, value: isSpinningPortal)
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(.ultraThinMaterial)
                                .opacity(0.85)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color(hex: "AE0F1C").opacity(isSpinningPortal ? 1.0 : 0.6), lineWidth: 1.5)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(isSpinningPortal)
                    .padding(.horizontal, 20)
                    
                    // Wisdom Banner
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                            Text("WATCHER'S WISDOM")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.yellow)
                                .tracking(2)
                        }
                        
                        Text(viewModel.completedCount == 0 ? "Your sacred journey has just begun. Pick a flight card in the Timeline to log your first mission!" : "You are actively weaving through the multiverse timelines. Keep pushing forward, Watcher!")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.ultraThinMaterial)
                            .opacity(0.6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 110)
            }
        }
        .sheet(item: $activeSheetFilter) { filterType in
            StatsDetailView(viewModel: viewModel, filterType: filterType)
                .presentationDetents([.medium, .large])
                .presentationBackground(Color.black.opacity(0.95))
        }
        .sheet(isPresented: $showPortalSheet) {
            // Sheet Portal Kosmik dengan Efek Loading / Summary
            VStack(spacing: 24) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                
                VStack(spacing: 6) {
                    Text("NEXUS PORTAL SUMMONER")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(Color(hex: "AE0F1C"))
                        .tracking(3)
                    
                    Text(isSpinningPortal ? "Opening Cosmic Rift..." : "Your Next Sacred Mission")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                }
                
                if isSpinningPortal {
                    // Tampilan Efek Loading Portal Berputar
                    VStack(spacing: 16) {
                        ProgressView()
                            .tint(Color(hex: "AE0F1C"))
                            .scaleEffect(1.5)
                        
                        Text(portalStatusText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .italic()
                    }
                    .frame(height: 140)
                } else {
                    if let movie = randomPickedMovie {
                        VStack(spacing: 12) {
                            VStack(spacing: 4) {
                                Text("YEAR: " + movie.year)
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Color(hex: "AE0F1C"))
                                
                                Text(movie.title)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(movie.duration)
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            
                            Text(movie.description)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .lineLimit(3)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "AE0F1C").opacity(0.5), lineWidth: 1))
                        .padding(.horizontal, 24)
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Text("All timeline missions have been successfully conquered, Watcher!")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(30)
                    }
                }
                
                if !isSpinningPortal {
                    HStack(spacing: 12) {
                        Button(action: { triggerCosmicPortalSummon() }) {
                            HStack(spacing: 6) {
                                Image(systemName: "dice.fill")
                                Text("Reroll Portal")
                            }
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .clipShape(Capsule())
                        }
                        
                        Button(action: { showPortalSheet = false }) {
                            Text("Close Portal")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
            .presentationDetents([.fraction(0.45)])
            .presentationBackground(Color.black.opacity(0.95))
        }
        .onAppear { animateGlow = true }
    }
    
    // Fungsi Efek Animasi Portal Kosmik sebelum Film Muncul
    private func triggerCosmicPortalSummon() {
        showPortalSheet = true
        isSpinningPortal = true
        portalStatusText = "Scanning timeline frequencies..."
        
        // Simulasi efek membuka portal selama 1.2 detik
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            portalStatusText = "Extracting variant from multiverse..."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            let uncompleted = viewModel.movies.filter { $0.status != .completed }
            if !uncompleted.isEmpty {
                randomPickedMovie = uncompleted.randomElement()
            } else {
                randomPickedMovie = viewModel.movies.randomElement()
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isSpinningPortal = false
            }
        }
    }
}

// MARK: - Magical Stat Card
struct MagicalStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(accentColor.opacity(0.25))
                            .frame(width: 32, height: 32)
                        Image(systemName: icon)
                            .foregroundColor(accentColor)
                            .font(.system(size: 14, weight: .bold))
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.3))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(value)
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.85))
                    
                    Text(subtitle)
                        .font(.system(size: 9.5))
                        .foregroundColor(.white.opacity(0.45))
                }
            }
            .padding(16)
            .frame(height: 135, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.7), Color.white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.2
                            )
                    )
            )
            .shadow(color: accentColor.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Stats Detail View
struct StatsDetailView: View {
    var viewModel: MovieViewModel
    var filterType: MultiverseStatsView.StatsDetailType
    
    var filteredMovies: [MarvelMovie] {
        switch filterType {
        case .completed:
            return viewModel.movies.filter { $0.status == .completed }
        case .ranked:
            return viewModel.movies.filter { $0.tier != .unranked }
        case .sTier:
            return viewModel.movies.filter { $0.tier == .s }
        case .rewatchable:
            return viewModel.movies.filter { $0.wouldRewatch }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12) {
                        if filteredMovies.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "tray")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white.opacity(0.2))
                                Text("No missions found in this category yet.")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .padding(.top, 60)
                        } else {
                            ForEach(filteredMovies) { movie in
                                HStack(spacing: 14) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(movie.title)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                        Text(movie.year + " • " + movie.duration)
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    Spacer()
                                    
                                    Text(movie.status.rawValue)
                                        .font(.system(size: 9, weight: .bold))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(movie.status.color.opacity(0.25))
                                        .foregroundColor(movie.status.color)
                                        .clipShape(Capsule())
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(.ultraThinMaterial)
                                        .opacity(0.6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle(filterType.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// MARK: - Live Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MultiverseStatsView(viewModel: MovieViewModel())
    }
}
