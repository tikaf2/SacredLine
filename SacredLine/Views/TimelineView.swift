//
//  TimelineView.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI

// Enum untuk Filter Jenis Tayangan yang Mutlak (Tidak Tumpang Tindih)
enum MediaTypeFilter: String, CaseIterable {
    case all = "All Types"
    case movie = "Movie"
    case series = "Series"
    case miniseries = "Miniseries"
    case short = "Short"
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .movie: return "film.fill"
        case .series: return "tv.fill"
        case .miniseries: return "square.stack.3d.down.right.fill"
        case .short: return "bolt.fill"
        }
    }
}

// Helper untuk mendeteksi kategori secara mutlak agar tidak double
func getMediaTypeCategory(for movie: MarvelMovie) -> MediaTypeFilter {
    let text = movie.duration.lowercased()
    let titleLower = movie.title.lowercased()
    
    if text.contains("mini") {
        return .miniseries
    } else if text.contains("series") || titleLower.contains("season") {
        return .series
    } else if (text.contains("m") && !text.contains("h")) || text.contains("short") || titleLower.contains("one-shot") {
        return .short
    } else {
        return .movie
    }
}

struct TimelineView: View {
    var viewModel: MovieViewModel
    @State private var selectedStatusFilter: WatchStatus = .all
    @State private var selectedMediaTypeFilter: MediaTypeFilter = .all
    @State private var searchText: String = ""
    @State private var isAscending: Bool = true
    @State private var selectedMovie: MarvelMovie? = nil
    @State private var animateMagicalGlow: Bool = false
    @State private var scrollOffset: CGFloat = 0
    
    // Menyimpan indeks asli tiap film berdasarkan data awal viewModel.movies
    var moviesWithOriginalIndex: [(originalIndex: Int, movie: MarvelMovie)] {
        Array(viewModel.movies.enumerated()).map { ($0.offset, $0.element) }
    }
    
    var displayedMovies: [(originalIndex: Int, movie: MarvelMovie)] {
        // 1. Filter berdasarkan Status
        let filteredByStatus = moviesWithOriginalIndex.filter { item in
            selectedStatusFilter == .all || item.movie.status == selectedStatusFilter
        }
        
        // 2. Filter berdasarkan Jenis Media secara Mutlak (Tanpa Double)
        let filteredByType = filteredByStatus.filter { item in
            let category = getMediaTypeCategory(for: item.movie)
            switch selectedMediaTypeFilter {
            case .all: return true
            case .movie: return category == .movie
            case .series: return category == .series
            case .miniseries: return category == .miniseries
            case .short: return category == .short
            }
        }
        
        // 3. Filter berdasarkan Search Text
        let filteredBySearch = searchText.isEmpty ? filteredByType : filteredByType.filter { item in
            item.movie.title.localizedCaseInsensitiveContains(searchText)
        }
        
        return isAscending ? filteredBySearch : filteredBySearch.reversed()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "1F0608"), Color(hex: "0A0102"), Color(hex: "050000")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(Color(hex: "AE0F1C").opacity(0.25))
                .frame(width: 380, height: 380)
                .blur(radius: 80)
                .offset(x: animateMagicalGlow ? 120 : -120, y: animateMagicalGlow ? -200 : 200)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animateMagicalGlow)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    
                    headerTitleSection
                    searchBarSection
                    controlsBarSection
                    moviesListSection
                }
                .padding(.bottom, 90)
            }
            .scrollDismissesKeyboard(.immediately)
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                scrollOffset = value
            }
            
            headerBlurOverlay
        }
        .sheet(item: $selectedMovie) { movie in
            RankingSheetView(movie: movie) { updatedMovie in
                viewModel.updateMovie(updatedMovie)
            }
            .presentationDetents([.large])
            .presentationBackground(.black.opacity(0.9))
        }
        .onAppear { animateMagicalGlow = true }
    }
    
    // MARK: - Subcomponents
    
    private var headerTitleSection: some View {
        VStack(spacing: 6) {
            Text("SACRED LINE")
                .font(.custom("Georgia", size: 28, relativeTo: .title))
                .bold()
                .foregroundColor(.white)
                .tracking(4)
            
            HStack(spacing: 8) {
                Text(String(viewModel.completedCount) + "/" + String(viewModel.movies.count) + " Watched")
                Text("•")
                Text(String(viewModel.completionPercentage) + "% Progress")
            }
            .font(.caption2.bold())
            .foregroundColor(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 16)
    }
    
    private var searchBarSection: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 14, weight: .bold))
            
            TextField("Search timeline or series...", text: $searchText)
                .foregroundColor(.white)
                .font(.system(size: 13, weight: .medium))
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 14))
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .opacity(0.7)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
    
    private var controlsBarSection: some View {
        HStack(spacing: 8) {
            Menu {
                ForEach(WatchStatus.allCases, id: \.self) { status in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedStatusFilter = status
                        }
                    }) {
                        HStack {
                            Text(status.rawValue)
                            if selectedStatusFilter == status {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text(selectedStatusFilter == .all ? "Status" : selectedStatusFilter.rawValue)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8, weight: .bold))
                }
                .font(.system(size: 10.5, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.white.opacity(0.1))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
            }
            
            Menu {
                ForEach(MediaTypeFilter.allCases, id: \.self) { mediaType in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedMediaTypeFilter = mediaType
                        }
                    }) {
                        HStack {
                            Text(mediaType.rawValue)
                            if selectedMediaTypeFilter == mediaType {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: selectedMediaTypeFilter.icon)
                    Text(selectedMediaTypeFilter == .all ? "Type" : selectedMediaTypeFilter.rawValue)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8, weight: .bold))
                }
                .font(.system(size: 10.5, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.white.opacity(0.1))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isAscending.toggle()
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: isAscending ? "arrow.up" : "arrow.down")
                        .font(.system(size: 9, weight: .bold))
                    Text(isAscending ? "Asc" : "Desc")
                }
                .font(.system(size: 10.5, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.red.opacity(0.75))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
    }
    
    private var moviesListSection: some View {
        LazyVStack(spacing: 16) {
            if displayedMovies.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.2))
                    Text("No timeline missions found.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.top, 40)
            } else {
                // Menggunakan originalIndex agar nomor MCU (MCU-1, dst.) TETAP STABIL meskipun difilter
                ForEach(displayedMovies, id: \.movie.id) { item in
                    MagicalBoardingPassCard(index: item.originalIndex, movie: item.movie) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            selectedMovie = item.movie
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 4)
    }
    
    private var headerBlurOverlay: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .opacity(scrollOffset < -15 ? 0.95 : 0)
            .frame(height: 130)
            .ignoresSafeArea(edges: .top)
            .overlay(
                Rectangle()
                    .frame(height: scrollOffset < -15 ? 0.5 : 0)
                    .foregroundColor(.white.opacity(0.15)),
                alignment: .bottom
            )
            .animation(.easeInOut(duration: 0.2), value: scrollOffset < -15)
            .allowsHitTesting(false)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Boarding Pass Card
struct MagicalBoardingPassCard: View {
    let index: Int
    let movie: MarvelMovie
    let action: () -> Void
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("MISSION")
                        .font(.system(size: 7, weight: .black))
                        .foregroundColor(movie.mediaGlowColor)
                    
                    Text("MCU-\(index + 1)")
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(movie.year)
                        .font(.system(size: 6.5, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 14)
                .frame(width: 80)
                .background(
                    LinearGradient(
                        colors: [movie.mediaGlowColor.opacity(0.35), Color(hex: "1F0608")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(
                    UnevenRoundedRectangle(topLeadingRadius: 18, bottomLeadingRadius: 18, bottomTrailingRadius: 0, topTrailingRadius: 0)
                )
                
                ZStack {
                    Color.black.opacity(0.4)
                    VStack(spacing: 5) {
                        ForEach(0..<8, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.white.opacity(0.25))
                                .frame(width: 1.5, height: 5)
                        }
                    }
                }
                .frame(width: 12)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("TIMELINE PASS")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white.opacity(0.4))
                        Spacer()
                        Text(movie.status.rawValue)
                            .font(.system(size: 8.5, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(movie.status == .notStarted ? Color.white.opacity(0.15) : movie.status.color.opacity(0.3))
                            .foregroundColor(movie.status == .notStarted ? Color.white.opacity(0.9) : movie.status.color)
                            .clipShape(Capsule())
                    }
                    
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack {
                        Label(movie.year + " • " + movie.duration, systemImage: "clock")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                        Spacer()
                        HStack(spacing: 1.5) {
                            ForEach(0..<10, id: \.self) { barIndex in
                                Rectangle()
                                    .fill(Color.white.opacity(barIndex % 2 == 0 ? 0.7 : 0.2))
                                    .frame(width: barIndex % 3 == 0 ? 2.5 : 1, height: 14)
                            }
                        }
                    }
                }
                .padding(14)
                
                Spacer(minLength: 0)
            }
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .opacity(0.85)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [movie.mediaGlowColor.opacity(0.8), Color.white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.2
                            )
                    )
            )
            .shadow(color: movie.mediaGlowColor.opacity(isPressed ? 0.7 : 0.25), radius: isPressed ? 12 : 6, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: Double.infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}
