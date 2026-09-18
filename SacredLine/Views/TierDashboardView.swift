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
    @State private var animateGlow: Bool = false
    @State private var showSharePassport: Bool = false
    
    var body: some View {
        ZStack {
            backgroundGradientView
            glowingPortalCircle
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    headerTitleSection
                    tierRowsSection
                    distributionMatrixSection
                }
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
        .onAppear { animateGlow = true }
    }
    
    // MARK: - Subcomponents
    
    private var backgroundGradientView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "140304"), Color(hex: "0A0102"), Color(hex: "050000")]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var glowingPortalCircle: some View {
        Circle()
            .fill(Color(hex: "AE0F1C").opacity(0.2))
            .frame(width: 400, height: 400)
            .blur(radius: 90)
            .offset(x: animateGlow ? 100 : -100, y: animateGlow ? -200 : 200)
            .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animateGlow)
            .ignoresSafeArea()
    }
    
    private var headerTitleSection: some View {
        VStack(spacing: 10) {
            Text("TIER RANKINGS")
                .font(.custom("Georgia", size: 32, relativeTo: .title))
                .bold()
                .foregroundColor(.white)
                .tracking(4)
            
            Text("Multiverse Classifications Ledger")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
                .tracking(2)
                .textCase(.uppercase)
            
            Button(action: { showSharePassport = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Tier Passport")
                }
                .font(.caption.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
            }
            .padding(.top, 2)
        }
        .padding(.top, 16)
    }
    
    private var tierRowsSection: some View {
        VStack(spacing: 14) {
            ForEach(tiers) { tier in
                // Mengambil film di tier ini dan dibalik (.reversed()) agar yang terbaru/terakhir ditambahkan muncul di paling kiri/depan
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
                    
                    // Area Tengah: Slide Horizontal (Film-film di tier ini, urutan terbaru di depan)
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
                    
                    // Tombol Chevron di Sebelah Kanan untuk buka Sheet Lengkap
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
                        .fill(Color.black.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(tier.color.opacity(0.5), lineWidth: 1.2)
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: tier.color.opacity(0.15), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
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
        .padding(.horizontal, 20)
    }
}

// MARK: - Sheet Detail List Film per Tier (Urutan Terbaru di Atas)
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
                        // Menggunakan .reversed() agar film yang baru di-rank muncul di paling atas list
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
