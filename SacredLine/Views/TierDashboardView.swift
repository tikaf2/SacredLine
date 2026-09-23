//
//  TierDashboardView.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI
import Charts

struct TierDashboardView: View {
    var viewModel: MovieViewModel
    let tiers: [MarvelTier] = [.s, .a, .b, .c, .d]
    @State private var selectedMovie: MarvelMovie? = nil
    @State private var selectedTierForSheet: MarvelTier? = nil // Untuk sheet list lengkap
    
    // Animasi Galaxy Merah & Cosmic Background
    @State private var animateMagicalGlow: Bool = false
    @State private var animateParticles: Bool = false
    @State private var showSharePassport: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // 1. Latar Belakang Cosmic Red Space (Dark Pitch Black + Crimson Tint)
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "080203"), Color(hex: "1A0508"), Color(hex: "040101")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 2. Partikel Galaxy Merah/Amber
            ForEach(0..<30, id: \.self) { index in
                GalaxyParticleView(index: index, animate: animateParticles)
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
                VStack(spacing: 24) {
                    headerTitleSection
                    tierRowsSection
                    distributionMatrixSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        // Sheet untuk Detail List Lengkap per Tier
        .sheet(item: $selectedTierForSheet) { tier in
            TierDetailSheetView(tier: tier, viewModel: viewModel) { movie in
                selectedMovie = movie
            }
            .presentationDetents([.medium, .large])
            .presentationBackground(.black.opacity(0.92))
        }
        // Sheet untuk Edit Movie Individual
        .sheet(item: $selectedMovie) { movie in
            RankingSheetView(movie: movie) { updatedMovie in
                viewModel.updateMovie(updatedMovie)
            }
            .presentationDetents([.large])
            .presentationBackground(.black.opacity(0.9))
        }
        // Sheet untuk Share Passport
        .sheet(isPresented: $showSharePassport) {
            ShareStoryView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationBackground(.black.opacity(0.85))
        }
        .onAppear {
            animateMagicalGlow = true
            animateParticles = true
        }
    }
    
    // MARK: - Subcomponents Kosmik
    
    private var headerTitleSection: some View {
        VStack(spacing: 12) {
            Text("TIER RANKINGS")
                .font(.system(size: 30, weight: .bold, design: .serif))
                .foregroundColor(.white)
                .tracking(3)
            
            Text("Watcher's Sacred Classification")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .tracking(2)
            
            Button(action: { showSharePassport = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 12, weight: .bold))
                    Text("Share Tier Passport")
                        .font(.caption.bold())
                }
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(
                        LinearGradient(
                            colors: [Color(hex: "AE0F1C").opacity(0.8), Color.white.opacity(0.2)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 1.2
                    )
                )
                .shadow(color: Color(hex: "AE0F1C").opacity(0.2), radius: 8, x: 0, y: 3)
            }
            .padding(.top, 4)
        }
        .padding(.top, 20)
    }
    
    private var tierRowsSection: some View {
        VStack(spacing: 14) {
            ForEach(tiers) { tier in
                let rankedMovies = Array(viewModel.movies.filter { $0.tier == tier }.reversed())
                
                HStack(spacing: 0) {
                    // Kotak Badge Huruf Tier di Kiri
                    Button(action: {
                        selectedTierForSheet = tier
                    }) {
                        ZStack {
                            LinearGradient(
                                colors: [tier.color, tier.color.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            Text(tier.rawValue)
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 2)
                        }
                        .frame(width: 55, height: 85)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Area Tengah: Slide Horizontal Film per Tier
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if rankedMovies.isEmpty {
                                Button(action: { selectedTierForSheet = tier }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "film.stack.fill")
                                            .font(.system(size: 11))
                                        Text("No missions logged in Tier " + tier.rawValue)
                                            .font(.system(size: 11, weight: .medium))
                                    }
                                    .foregroundColor(.white.opacity(0.35))
                                    .padding(.leading, 16)
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                ForEach(rankedMovies) { m in
                                    Button(action: { selectedMovie = m }) {
                                        HStack(spacing: 0) {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("YEAR")
                                                    .font(.system(size: 5.5, weight: .black))
                                                    .foregroundColor(m.mediaGlowColor)
                                                Text(m.year)
                                                    .font(.system(size: 9, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(6)
                                            .frame(width: 45, height: 65)
                                            .background(m.mediaGlowColor.opacity(0.2))
                                            
                                            VStack(spacing: 3) {
                                                ForEach(0..<5, id: \.self) { _ in
                                                    Rectangle().fill(Color.white.opacity(0.2)).frame(width: 1, height: 3)
                                                }
                                            }
                                            .frame(width: 6)
                                            
                                            VStack(alignment: .leading, spacing: 3) {
                                                Text(m.title)
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .lineLimit(2)
                                                
                                                Text(m.notes.isEmpty ? "Tap to view..." : "\"" + m.notes + "\"")
                                                    .font(.system(size: 8.5))
                                                    .italic()
                                                    .foregroundColor(.white.opacity(0.5))
                                                    .lineLimit(1)
                                            }
                                            .padding(8)
                                            
                                            Spacer(minLength: 0)
                                        }
                                        .frame(width: 155, height: 65)
                                        .background(Color.black.opacity(0.6))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(m.mediaGlowColor.opacity(0.6), lineWidth: 1)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    
                    // Tombol Chevron Kanan untuk Membuka Sheet List Lengkap
                    Button(action: {
                        selectedTierForSheet = tier
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(width: 35, height: 85)
                            .background(Color.black.opacity(0.3))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.45))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(tier.color.opacity(0.5), lineWidth: 1.2)
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: tier.color.opacity(0.15), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    private var distributionMatrixSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("TIER DISTRIBUTION MATRIX")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(2)
                Spacer()
                Text("Total: " + String(viewModel.completedCount) + " Ranked")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Chart {
                ForEach(tiers) { tier in
                    let count = viewModel.movies.filter({ $0.tier == tier }).count
                    BarMark(
                        x: .value("Tier", tier.rawValue),
                        y: .value("Count", count)
                    )
                    .foregroundStyle(tier.color)
                    .cornerRadius(6)
                }
            }
            .frame(height: 120)
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .opacity(0.7)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

// MARK: - Sheet Detail List Film per Tier
struct TierDetailSheetView: View {
    let tier: MarvelTier
    var viewModel: MovieViewModel
    var onSelectMovie: (MarvelMovie) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0A0102").ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        HStack(spacing: 8) {
                            Text("TIER " + tier.rawValue)
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(tier.color)
                            Text("Classification")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(20)
                    
                    ScrollView(showsIndicators: false) {
                        let moviesInTier = Array(viewModel.movies.filter { $0.tier == tier }.reversed())
                        
                        if moviesInTier.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "film.stack")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.2))
                                Text("No missions logged in Tier " + tier.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(moviesInTier) { movie in
                                    Button(action: {
                                        dismiss()
                                        onSelectMovie(movie)
                                    }) {
                                        HStack(spacing: 14) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(movie.mediaGlowColor.opacity(0.3))
                                                Text(movie.year)
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                            .frame(width: 50, height: 50)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(movie.title)
                                                    .font(.subheadline.bold())
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                
                                                Text(movie.notes.isEmpty ? "No personal notes added yet." : "\"" + movie.notes + "\"")
                                                    .font(.caption2)
                                                    .italic()
                                                    .foregroundColor(.white.opacity(0.6))
                                                    .lineLimit(1)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption.bold())
                                                .foregroundColor(.white.opacity(0.3))
                                        }
                                        .padding(12)
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TierDashboardView(viewModel: MovieViewModel())
    }
}
