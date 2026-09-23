//
//  TimelineView.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI

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
    
    // Animasi Galaxy Merah
    @State private var animateMagicalGlow: Bool = false
    @State private var animateParticles: Bool = false
    
    var moviesWithOriginalIndex: [(originalIndex: Int, movie: MarvelMovie)] {
        Array(viewModel.movies.enumerated()).map { ($0.offset, $0.element) }
    }
    
    var displayedMovies: [(originalIndex: Int, movie: MarvelMovie)] {
        let filteredByStatus = moviesWithOriginalIndex.filter { item in
            selectedStatusFilter == .all || item.movie.status == selectedStatusFilter
        }
        
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
        
        let filteredBySearch = searchText.isEmpty ? filteredByType : filteredByType.filter { item in
            item.movie.title.localizedCaseInsensitiveContains(searchText)
        }
        
        return isAscending ? filteredBySearch : filteredBySearch.reversed()
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
            
            // SCROLLVIEW UTAMA DENGAN PINNED HEADERS
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                    headerTitleSection
                        .padding(.top, 16)
                    
                    // Search & Filter Pinned Header
                    Section(header: searchAndFilterBar) {
                        moviesListSection
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 110)
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .sheet(item: $selectedMovie) { movie in
            RankingSheetView(movie: movie) { updatedMovie in
                viewModel.updateMovie(updatedMovie)
            }
            .presentationDetents([.large])
            .presentationBackground(.black.opacity(0.9))
        }
        .onAppear {
            animateMagicalGlow = true
            animateParticles = true
        }
    }
    
    // MARK: - Subcomponents
    
    private var headerTitleSection: some View {
        VStack(spacing: 4) {
            Text("SACRED LINE")
                .font(.custom("Georgia", size: 26, relativeTo: .title))
                .bold()
                .foregroundColor(.white)
                .tracking(4)
                .shadow(color: Color(hex: "E63946").opacity(0.6), radius: 8, x: 0, y: 0) // Red Glow
            
            HStack(spacing: 8) {
                Text(String(viewModel.completedCount) + "/" + String(viewModel.movies.count) + " Watched")
                Text("•")
                Text(String(viewModel.completionPercentage) + "% Progress")
            }
            .font(.caption2.bold())
            .foregroundColor(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // SEARCH & FILTER BAR
    private var searchAndFilterBar: some View {
        VStack(spacing: 10) {
            // Search Bar
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .foregroundColor(Color(hex: "FF4D6D"))
                    .font(.system(size: 13, weight: .bold))
                
                TextField("Search the timeline...", text: $searchText)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .autocorrectionDisabled()
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.5))
            .overlay(
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(searchText.isEmpty ? Color.white.opacity(0.15) : Color(hex: "FF4D6D").opacity(0.8))
                        .frame(height: 1.5)
                }
            )
            .cornerRadius(8)
            
            // Filter & Sort Controls Row
            HStack(spacing: 8) {
                Menu {
                    ForEach(WatchStatus.allCases, id: \.self) { status in
                        Button(action: {
                            selectedStatusFilter = status
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
                    HStack(spacing: 4) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 10))
                        Text(selectedStatusFilter == .all ? "Status" : selectedStatusFilter.rawValue)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 8, weight: .bold))
                    }
                    .font(.system(size: 10, weight: .bold))
                    .frame(width: 100, height: 32)
                    .background(Color.white.opacity(0.1))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                
                Menu {
                    ForEach(MediaTypeFilter.allCases, id: \.self) { mediaType in
                        Button(action: {
                            selectedMediaTypeFilter = mediaType
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
                    HStack(spacing: 4) {
                        Image(systemName: selectedMediaTypeFilter.icon)
                            .font(.system(size: 10))
                        Text(selectedMediaTypeFilter == .all ? "Type" : selectedMediaTypeFilter.rawValue)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 8, weight: .bold))
                    }
                    .font(.system(size: 10, weight: .bold))
                    .frame(width: 90, height: 32)
                    .background(Color.white.opacity(0.1))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isAscending.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isAscending ? "arrow.up" : "arrow.down")
                            .font(.system(size: 9, weight: .bold))
                        Text(isAscending ? "Asc" : "Desc")
                    }
                    .font(.system(size: 10, weight: .bold))
                    .frame(height: 32)
                    .padding(.horizontal, 10)
                    .background(Color(hex: "C1121F").opacity(0.9)) // Red Sort Button
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color(hex: "FF4D6D").opacity(0.4), lineWidth: 1))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.92)
                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .padding(.horizontal, 4)
        .padding(.top, 8)
    }
    
    private var moviesListSection: some View {
        LazyVStack(spacing: 16) {
            if displayedMovies.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 32))
                        .foregroundColor(Color(hex: "FF4D6D").opacity(0.4))
                    Text("No timeline missions found.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.top, 40)
            } else {
                ForEach(displayedMovies, id: \.movie.id) { item in
                    TearableTicketCardWrapper(index: item.originalIndex, movie: item.movie) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            selectedMovie = item.movie
                        }
                    }
                }
            }
        }
    }
}

// ======================================================
// MARK: - GALAXY PARTICLE VIEW (Red Theme)
// ======================================================
struct GalaxyParticleView: View {
    let index: Int
    let animate: Bool
    
    var randomX: CGFloat {
        let multipliers: [CGFloat] = [10, 30, 50, 70, 90, 20, 40, 60, 80, 15, 35, 55, 75, 95, 25, 45, 65, 85, 5, 12]
        return (multipliers[index % multipliers.count] / 100.0) * UIScreen.main.bounds.width
    }
    
    var randomY: CGFloat {
        let multipliers: [CGFloat] = [5, 25, 45, 65, 85, 15, 35, 55, 75, 95, 10, 30, 50, 70, 90, 20, 40, 60, 80, 12]
        return (multipliers[index % multipliers.count] / 100.0) * UIScreen.main.bounds.height
    }
    
    var randomSize: CGFloat {
        return CGFloat([1.0, 1.5, 2.0, 2.5][index % 4])
    }
    
    var particleColor: Color {
        let colors = [Color.white, Color(hex: "FF4D6D"), Color(hex: "E63946"), Color(hex: "FFB703")]
        return colors[index % colors.count]
    }
    
    var body: some View {
        Circle()
            .fill(particleColor)
            .frame(width: randomSize, height: randomSize)
            .shadow(color: particleColor, radius: 3)
            .position(x: randomX, y: animate ? randomY - 30 : randomY + 30)
            .opacity(animate ? (index % 2 == 0 ? 0.75 : 0.3) : 0.0)
            .animation(
                .easeInOut(duration: Double(3 + (index % 5)))
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.1),
                value: animate
            )
    }
}

// ======================================================
// MARK: - TEARABLE TICKET CARD WRAPPER
// ======================================================

struct TearableTicketCardWrapper: View {
    let index: Int
    let movie: MarvelMovie
    let action: () -> Void
    
    @State private var showTornState: Bool = false
    
    var body: some View {
        let isCompleted = (movie.status == .completed)
        
        Button(action: action) {
            ZStack {
                HStack(spacing: showTornState ? 6 : 0) {
                    // Stub Kiri
                    TicketStub(
                        mission: "MCU-\(index + 1)",
                        year: movie.year,
                        glowColor: movie.mediaGlowColor
                    )
                    .clipShape(showTornState ? AnyShape(TornLeftTicketShape()) : AnyShape(UnevenRoundedRectangle(topLeadingRadius: 18, bottomLeadingRadius: 18, bottomTrailingRadius: 0, topTrailingRadius: 0)))
                    .overlay(showTornState ? AnyView(TornEdgeHighlight(side: .right)) : AnyView(EmptyView()))
                    .rotationEffect(.degrees(showTornState ? -3.5 : 0), anchor: .topTrailing)
                    .offset(x: showTornState ? -2 : 0, y: showTornState ? 2 : 0)
                    
                    // Perforasi tengah
                    if !showTornState {
                        PerforationView()
                    } else {
                        Color.clear
                            .frame(width: 8, height: 105)
                    }
                    
                    // Main Content Kanan
                    TicketMainContent(
                        title: movie.title,
                        year: movie.year,
                        duration: movie.duration,
                        status: movie.status
                    )
                    .clipShape(showTornState ? AnyShape(TornRightTicketShape()) : AnyShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 18, topTrailingRadius: 18)))
                    .overlay(showTornState ? AnyView(TornEdgeHighlight(side: .left)) : AnyView(EmptyView()))
                }
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(showTornState ? Color.clear : movie.mediaGlowColor.opacity(0.6), lineWidth: 1.2)
                )
                .shadow(color: showTornState ? Color(hex: "FF4D6D").opacity(0.2) : movie.mediaGlowColor.opacity(0.3), radius: 6, x: 0, y: 3)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onChange(of: isCompleted) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                        showTornState = true
                    }
                }
            } else {
                showTornState = false
            }
        }
        .onAppear {
            showTornState = isCompleted
        }
    }
}

// ======================================================
// MARK: - TICKET SUB-COMPONENTS
// ======================================================

struct TicketStub: View {
    let mission: String
    let year: String
    let glowColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("MISSION")
                .font(.system(size: 7, weight: .black))
                .foregroundStyle(glowColor)
            
            Text(mission)
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            
            Spacer()
            
            Text(year)
                .font(.system(size: 6.5, weight: .bold))
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 14)
        .frame(width: 80, height: 105)
        .background(
            LinearGradient(
                colors: [glowColor.opacity(0.35), Color(hex: "1A0508")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

struct TicketMainContent: View {
    let title: String
    let year: String
    let duration: String
    let status: WatchStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("TIMELINE PASS")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.white.opacity(0.4))
                
                Spacer()
                
                Text(status.rawValue)
                    .font(.system(size: 8.5, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(status == .notStarted ? Color.white.opacity(0.15) : status.color.opacity(0.3))
                    .foregroundStyle(status == .notStarted ? Color.white.opacity(0.9) : status.color)
                    .clipShape(Capsule())
            }
            
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .lineLimit(2)
            
            Spacer(minLength: 0)
            
            HStack {
                Label("\(year) • \(duration)", systemImage: "clock")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.6))
                
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
        .frame(maxWidth: .infinity, minHeight: 105, maxHeight: 105)
        .background(Color.white.opacity(0.08))
    }
}

struct PerforationView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            VStack(spacing: 4) {
                ForEach(0..<10, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 2.5, height: 2.5)
                }
            }
        }
        .frame(width: 12, height: 105)
    }
}

// ======================================================
// MARK: - TORN EDGE SHAPES
// ======================================================
enum TornEdgeSide { case left; case right }

struct TornEdgeHighlight: View {
    let side: TornEdgeSide
    
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                let segments = 8
                let step = proxy.size.height / CGFloat(segments)
                
                for i in 0...segments {
                    let y = CGFloat(i) * step
                    let variation: CGFloat = (i % 2 == 0) ? 1.5 : 3.5
                    let x: CGFloat = (side == .left) ? variation : proxy.size.width - variation
                    
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            .stroke(Color.white.opacity(0.2), lineWidth: 0.8)
        }
        .allowsHitTesting(false)
    }
}

struct TornLeftTicketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = 18
        let tearDepth: CGFloat = 5
        let segments = 8
        let segmentHeight = rect.height / CGFloat(segments)
        
        path.move(to: CGPoint(x: radius, y: 0))
        path.addLine(to: CGPoint(x: rect.width - tearDepth, y: 0))
        
        for i in 0...segments {
            let y = CGFloat(i) * segmentHeight
            let x: CGFloat = (i < 6) ? (rect.width - (i % 2 == 0 ? tearDepth : 1)) : rect.width
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: radius, y: rect.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.height - radius), control: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addQuadCurve(to: CGPoint(x: radius, y: 0), control: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

struct TornRightTicketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = 18
        let tearDepth: CGFloat = 5
        let segments = 8
        let segmentHeight = rect.height / CGFloat(segments)
        
        path.move(to: CGPoint(x: tearDepth, y: 0))
        path.addLine(to: CGPoint(x: rect.width - radius, y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: radius), control: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - radius))
        path.addQuadCurve(to: CGPoint(x: rect.width - radius, y: rect.height), control: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: tearDepth, y: rect.height))
        
        for i in stride(from: segments, through: 0, by: -1) {
            let y = CGFloat(i) * segmentHeight
            let x: CGFloat = (i < 6) ? (i % 2 == 0 ? 1 : tearDepth) : 0
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.closeSubpath()
        return path
    }
}
