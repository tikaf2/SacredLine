//
//  MultiverseStatsView.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI

struct MultiverseStatsView: View {
    var viewModel: MovieViewModel
    @State private var activeSheetFilter: StatsDetailType? = nil
    @State private var showPortalSheet: Bool = false
    
    // State buat Random Mission & Efek Portal Loading
    @State private var randomPickedMovie: MarvelMovie? = nil
    @State private var isSpinningPortal: Bool = false
    @State private var portalStatusText: String = "Calibrating multiverse frequencies..."
    
    // Animasi Galaxy Merah Baru
    @State private var animateMagicalGlow: Bool = false
    @State private var animateParticles: Bool = false
    
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
        ZStack(alignment: .top) {
            // 1. Latar Belakang Cosmic Red Space (Dark Pitch Black + Crimson Tint)
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "080203"), Color(hex: "1A0508"), Color(hex: "040101")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 2. Partikel Galaxy Merah/Amber (Menggunakan inlined loop view untuk menghindari bentrok nama)
            ForEach(0..<30, id: \.self) { index in
                Circle()
                    .fill(index % 2 == 0 ? Color(hex: "FF3B47").opacity(Double.random(in: 0.15...0.45)) : Color.white.opacity(Double.random(in: 0.2...0.5)))
                    .frame(width: CGFloat.random(in: 2...4.5), height: CGFloat.random(in: 2...4.5))
                    .position(
                        x: CGFloat.random(in: 20...380),
                        y: CGFloat.random(in: 50...750)
                    )
                    .scaleEffect(animateParticles ? CGFloat.random(in: 1.2...1.8) : CGFloat.random(in: 0.6...0.9))
                    .opacity(animateParticles ? Double.random(in: 0.3...0.8) : Double.random(in: 0.1...0.4))
                    .animation(
                        .easeInOut(duration: Double.random(in: 3.0...6.5))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...2)),
                        value: animateParticles
                    )
            }
            .ignoresSafeArea()
            
            // 3. Nebula Glow Effect 1 (Crimson Red)
            Circle()
                .fill(Color(hex: "E63946").opacity(0.18))
                .frame(width: 380, height: 380)
                .blur(radius: 80)
                .offset(x: animateMagicalGlow ? 120 : -120, y: animateMagicalGlow ? -200 : 200)
                .animation(.easeInOut(duration: 7).repeatForever(autoreverses: true), value: animateMagicalGlow)
                .ignoresSafeArea()
            
            // 4. Nebula Glow Effect 2 (Blood Orange / Flame)
            Circle()
                .fill(Color(hex: "D90429").opacity(0.12))
                .frame(width: 300, height: 300)
                .blur(radius: 90)
                .offset(x: animateMagicalGlow ? -150 : 150, y: animateMagicalGlow ? 300 : -100)
                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animateMagicalGlow)
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
                            .shadow(color: Color(hex: "AE0F1C").opacity(0.6), radius: 8, x: 0, y: 2)
                        
                        Text("Watcher's Analytics & Archives")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.55))
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
                            accentColor: Color(hex: "FF4D5A"),
                            action: { activeSheetFilter = .completed }
                        )
                        
                        MagicalStatCard(
                            title: "Ranked Missions",
                            value: String(viewModel.rankedCount),
                            subtitle: "Logged in Tiers",
                            icon: "star.fill",
                            accentColor: Color(hex: "FFC107"),
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
                            accentColor: Color(hex: "00E5FF"),
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
                                    .fill(
                                        RadialGradient(
                                            colors: [Color(hex: "AE0F1C").opacity(0.5), Color(hex: "5A050B").opacity(0.1)],
                                            center: .center,
                                            startRadius: 2,
                                            endRadius: 24
                                        )
                                    )
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        Circle()
                                            .stroke(Color(hex: "FF4D5A").opacity(0.4), lineWidth: 1)
                                    )
                                
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
                                    .foregroundColor(.white.opacity(0.65))
                            }
                            
                            Spacer()
                            
                            Image(systemName: isSpinningPortal ? "circle.dashed" : "dice.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "FF4D5A"))
                                .rotationEffect(.degrees(isSpinningPortal ? 360 : 0))
                                .animation(isSpinningPortal ? Animation.linear(duration: 0.6).repeatForever(autoreverses: false) : .default, value: isSpinningPortal)
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(.ultraThinMaterial)
                                .opacity(0.8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color(hex: "AE0F1C"), Color(hex: "FF4D5A").opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                        )
                        .shadow(color: Color(hex: "AE0F1C").opacity(0.25), radius: 10, x: 0, y: 4)
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
                            .foregroundColor(.white.opacity(0.85))
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
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color(hex: "AE0F1C").opacity(0.4), Color.white.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
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
                .presentationBackground(Color(hex: "0B0103").opacity(0.96))
        }
        .sheet(isPresented: $showPortalSheet) {
            VStack(spacing: 24) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                
                VStack(spacing: 6) {
                    Text("NEXUS PORTAL SUMMONER")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(Color(hex: "FF4D5A"))
                        .tracking(3)
                    
                    Text(isSpinningPortal ? "Opening Cosmic Rift..." : "Your Next Sacred Mission")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                }
                
                if isSpinningPortal {
                    VStack(spacing: 16) {
                        ProgressView()
                            .tint(Color(hex: "FF4D5A"))
                            .scaleEffect(1.5)
                        
                        Text(portalStatusText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.65))
                            .italic()
                    }
                    .frame(height: 140)
                } else {
                    if let movie = randomPickedMovie {
                        VStack(spacing: 12) {
                            VStack(spacing: 4) {
                                Text("YEAR: " + movie.year)
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Color(hex: "FF4D5A"))
                                
                                Text(movie.title)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(movie.duration)
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.55))
                            }
                            
                            Text(movie.description)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.75))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .lineLimit(3)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                Color(hex: "150205").opacity(0.8)
                                LinearGradient(
                                    colors: [Color(hex: "AE0F1C").opacity(0.2), Color.clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                        )
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "AE0F1C").opacity(0.6), lineWidth: 1.2))
                        .padding(.horizontal, 24)
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Text("All timeline missions have been successfully conquered, Watcher!")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.65))
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
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "AE0F1C"), Color(hex: "700911")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: Color(hex: "AE0F1C").opacity(0.4), radius: 6, x: 0, y: 3)
                        }
                        
                        Button(action: { showPortalSheet = false }) {
                            Text("Close Portal")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
            .presentationDetents([.fraction(0.45)])
            .presentationBackground(Color(hex: "0B0103").opacity(0.96))
        }
        .onAppear {
            animateMagicalGlow = true
            animateParticles = true
        }
    }
    
    private func triggerCosmicPortalSummon() {
        showPortalSheet = true
        isSpinningPortal = true
        portalStatusText = "Scanning timeline frequencies..."
        
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
                            .fill(accentColor.opacity(0.22))
                            .frame(width: 32, height: 32)
                        Image(systemName: icon)
                            .foregroundColor(accentColor)
                            .font(.system(size: 14, weight: .bold))
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.35))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(value)
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: accentColor.opacity(0.4), radius: 4, x: 0, y: 1)
                    
                    Text(title)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(subtitle)
                        .font(.system(size: 9.5))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(16)
            .frame(height: 135, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .opacity(0.75)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.8), Color(hex: "AE0F1C").opacity(0.2), Color.white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.3
                            )
                    )
            )
            .shadow(color: accentColor.opacity(0.18), radius: 10, x: 0, y: 5)
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
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "1A0306"), Color(hex: "090102")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12) {
                        if filteredMovies.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "tray")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white.opacity(0.25))
                                Text("No missions found in this category yet.")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.45))
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
                                            .foregroundColor(.white.opacity(0.55))
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
                                        .opacity(0.65)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color(hex: "AE0F1C").opacity(0.25), lineWidth: 1)
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
