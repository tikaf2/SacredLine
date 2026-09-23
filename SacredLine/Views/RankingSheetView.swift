//
//  RankingSheetView.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI
import Photos

struct RankingSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State var movie: MarvelMovie
    var onSave: (MarvelMovie) -> Void
    
    @State private var showError: Bool = false
    @State private var showSharePreview: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var zoomedImage: UIImage? = nil
    @FocusState private var isNotesFocused: Bool
    @State private var animateGlow: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGalaxyGradient
                StarryBackgroundView()
                glowingGalaxyNebula
                
                VStack(spacing: 0) {
                    headerNavigationBar
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            movieInfoCardSection
                            photoMomentSection
                            tierPickerSection
                            personalReviewSection
                            dateAndToggleSection
                            
                            Button(action: { showSharePreview = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                    Text("Preview & Share IG Story")
                                }
                                .font(.headline.bold())
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(LinearGradient(colors: [movie.mediaGlowColor, Color.cyan.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(16)
                                .shadow(color: movie.mediaGlowColor.opacity(0.5), radius: 12, x: 0, y: 4)
                            }
                            .padding(.top, 10)
                        }
                        .padding(20)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { isNotesFocused = false }.bold()
                }
            }
            .sheet(isPresented: $showSharePreview) {
                MovieReviewShareCard(movie: movie)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(.black.opacity(0.85))
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(sourceType: .photoLibrary, selectedImageData: $movie.userPhotoData)
            }
            .sheet(item: Binding(
                get: { zoomedImage.map { IdentifiableImage(image: $0) } },
                set: { zoomedImage = $0?.image }
            )) { item in
                ZoomedPhotoView(image: item.image)
            }
            .onAppear { animateGlow = true }
        }
    }
    
    // MARK: - Galaxy Background Elements
    
    private var backgroundGalaxyGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "0B0B16"), Color(hex: "06060B"), Color(hex: "020205")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var glowingGalaxyNebula: some View {
        ZStack {
            // Purple Nebula Orb
            Circle()
                .fill(Color.purple.opacity(0.2))
                .frame(width: 350, height: 350)
                .blur(radius: 80)
                .offset(x: animateGlow ? 120 : -120, y: animateGlow ? -200 : 200)
                .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animateGlow)
            
            // Cyan Star-dust Glow
            Circle()
                .fill(Color.cyan.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .offset(x: animateGlow ? -100 : 130, y: animateGlow ? 180 : -150)
                .animation(.easeInOut(duration: 7).repeatForever(autoreverses: true), value: animateGlow)
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Subcomponents
    
    private var headerNavigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.body.bold())
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("COSMIC LOG")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(.cyan)
                    .tracking(2)
                Text(movie.title)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            
            Spacer()
            
            let isTierSelected = movie.tier != .unranked
            Button(action: saveAction) {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isTierSelected ? .black : .white.opacity(0.4))
                    .frame(width: 36, height: 36)
                    .background(isTierSelected ? movie.mediaGlowColor : Color.white.opacity(0.1))
                    .clipShape(Circle())
                    .shadow(color: isTierSelected ? movie.mediaGlowColor.opacity(0.4) : Color.clear, radius: 6, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var movieInfoCardSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.4), Color.black],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    VStack(spacing: 2) {
                        Image(systemName: "sparkle")
                            .foregroundColor(.cyan)
                            .font(.system(size: 20))
                        Text(movie.year)
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .frame(width: 65, height: 85)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.6), lineWidth: 1.5)
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack(spacing: 8) {
                        Label(movie.year, systemImage: "calendar")
                        Text("•")
                        Label(movie.duration, systemImage: "clock")
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                }
                Spacer()
            }
            
            Divider().background(Color.white.opacity(0.15))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("STORYLINE")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(.cyan)
                    .tracking(1)
                Text(movie.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.75))
                    .lineLimit(4)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .opacity(0.6)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.5), Color.cyan.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private var photoMomentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Starlight Memory Photo")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if movie.userPhotoData != nil {
                    Button("Remove") {
                        movie.userPhotoData = nil
                    }
                    .font(.caption.bold())
                    .foregroundColor(.red)
                }
            }
            
            HStack(spacing: 12) {
                if let data = movie.userPhotoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan.opacity(0.4), lineWidth: 1)
                        )
                        .onTapGesture {
                            zoomedImage = uiImage
                        }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Photo Attached")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                        Text("Tap photo to view, or change below")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 60, height: 60)
                        Image(systemName: "photo.badge.plus")
                            .foregroundColor(.cyan.opacity(0.8))
                            .font(.system(size: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Add Watch Photo / Ticket")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                        Text("Tap button to select from gallery")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                Spacer()
            }
            
            Button(action: {
                PHPhotoLibrary.requestAuthorization { status in
                    DispatchQueue.main.async {
                        showImagePicker = true
                    }
                }
            }) {
                HStack {
                    Image(systemName: movie.userPhotoData == nil ? "plus.circle.fill" : "arrow.triangle.2.circlepath")
                    Text(movie.userPhotoData == nil ? "Select Photo from Gallery" : "Change Photo")
                }
                .font(.subheadline.bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .opacity(0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var tierPickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Galaxy Ranking Tier")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("*")
                    .foregroundColor(.red)
                Spacer()
                if movie.tier != .unranked {
                    Text("Tier " + movie.tier.rawValue + " (" + movie.tier.title + ")")
                        .font(.caption.bold())
                        .foregroundColor(movie.tier.color)
                }
            }
            
            if showError {
                Text("Please select a tier before saving")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(MarvelTier.allCases.filter { $0 != .unranked }) { tier in
                        let isSelected = movie.tier == tier
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                movie.tier = tier
                                showError = false
                            }
                        }) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(isSelected ? tier.color : Color.white.opacity(0.06))
                                        .frame(width: 50, height: 50)
                                        .shadow(color: isSelected ? tier.color.opacity(0.8) : Color.clear, radius: 10)
                                    
                                    Text(tier.rawValue)
                                        .font(.system(size: 18, weight: .black))
                                        .foregroundColor(.white)
                                }
                                .overlay(
                                    Circle().stroke(isSelected ? Color.cyan : Color.white.opacity(0.15), lineWidth: isSelected ? 2.5 : 1)
                                )
                                .scaleEffect(isSelected ? 1.15 : 1.0)
                                
                                Text(tier.title)
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(isSelected ? .white : .white.opacity(0.5))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .opacity(0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(showError ? Color.red : Color.white.opacity(0.1), lineWidth: showError ? 2 : 1)
                )
        )
    }
    
    private var personalReviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cosmic Log & Thoughts")
                .font(.headline)
                .foregroundColor(.white)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .opacity(0.5)
                
                if movie.notes.isEmpty {
                    Text("Record your stellar review or favorite moments...")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $movie.notes)
                    .font(.body)
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .focused($isNotesFocused)
            }
            .frame(height: 130)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
        }
    }
    
    private var dateAndToggleSection: some View {
        VStack(spacing: 0) {
            DatePicker("Watch Date", selection: $movie.watchDate, displayedComponents: .date)
                .padding()
                .foregroundColor(.white)
            
            Divider().background(Color.white.opacity(0.1))
            
            Toggle("Would Rewatch", isOn: $movie.wouldRewatch)
                .toggleStyle(SwitchToggleStyle(tint: .cyan))
                .padding()
                .foregroundColor(.white)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .opacity(0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private func saveAction() {
        if movie.tier == .unranked {
            withAnimation { showError = true }
        } else {
            onSave(movie)
            dismiss()
        }
    }
}

// MARK: - Twinkling Starry Background Generator
struct StarryBackgroundView: View {
    @State private var animateStars = false
    
    var body: some View {
        ZStack {
            ForEach(0..<25, id: \.self) { i in
                Circle()
                    .fill(i % 2 == 0 ? Color.white : Color.cyan)
                    .frame(width: CGFloat(i % 3 + 2), height: CGFloat(i % 3 + 2))
                    .position(
                        x: CGFloat((i * 37) % Int(UIScreen.main.bounds.width)),
                        y: CGFloat((i * 59) % Int(UIScreen.main.bounds.height))
                    )
                    .opacity(animateStars ? Double.random(in: 0.2...0.9) : Double.random(in: 0.1...0.4))
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 1.5...4.0))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animateStars
                    )
            }
        }
        .onAppear {
            animateStars = true
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

// MARK: - Identifiable Image Zoom Helper
struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

// MARK: - Full Screen Zoom View
struct ZoomedPhotoView: View {
    let image: UIImage
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .padding(20)
                }
                
                Spacer()
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                
                Spacer()
            }
        }
    }
}

// MARK: - IG Story Share Template
struct MovieReviewShareCard: View {
    let movie: MarvelMovie
    @Environment(\.dismiss) var dismiss
    @State private var zoomedImageForShare: UIImage? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "0B0B16"), Color(hex: "020205")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack {
                        Text("SHARE COSMIC CARD")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    cardContentBody
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.ultraThinMaterial)
                                .opacity(0.7)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.cyan, Color.purple.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                        )
                        .padding(.horizontal, 24)
                    
                    Button(action: shareToInstagramStory) {
                        Text("Share to Instagram Story")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(item: Binding(
            get: { zoomedImageForShare.map { IdentifiableImage(image: $0) } },
            set: { zoomedImageForShare = $0?.image }
        )) { item in
            ZoomedPhotoView(image: item.image)
        }
    }
    
    @ViewBuilder
    private var cardContentBody: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("GALAXY REVIEW")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(.cyan)
                        .tracking(2)
                    
                    if movie.tier != .unranked {
                        Text("Tier " + movie.tier.rawValue + " • " + movie.tier.title)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(movie.tier.color)
                    }
                }
                Spacer()
                
                if movie.tier != .unranked {
                    Text(movie.tier.rawValue)
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(movie.tier.color)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.cyan, lineWidth: 1.5))
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .lineLimit(2)
                Text(movie.duration)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
            
            if let data = movie.userPhotoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 256, height: 256)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                    )
                    .onTapGesture {
                        zoomedImageForShare = uiImage
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Divider().background(Color.white.opacity(0.2))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("MY COSMIC THOUGHTS:")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.cyan.opacity(0.7))
                
                Text(movie.notes.isEmpty ? "No cosmic notes logged yet." : "\"" + movie.notes + "\"")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(4)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black.opacity(0.5))
            .cornerRadius(12)
            
            HStack {
                Text("#SacredLine #GalaxyMCU")
                    .font(.system(size: 8.5, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
                Spacer()
                Text(movie.wouldRewatch ? "🔄 Would Rewatch" : "")
                    .font(.caption2.bold())
                    .foregroundColor(.cyan)
            }
        }
    }
    
    private func shareToInstagramStory() {
        let renderer = ImageRenderer(content: cardToShare)
        renderer.scale = 3.0
        
        guard let uiImage = renderer.uiImage, let imageData = uiImage.pngData() else { return }
        
        let destinationURL = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")!
        
        let pasteboardItems: [String: Any] = [
            "com.instagram.sharedSticker.stickerImage": imageData,
            "com.instagram.sharedSticker.backgroundTopColor": "#0B0B16",
            "com.instagram.sharedSticker.backgroundBottomColor": "#020205",
            "com.instagram.sharedSticker.contentURL": destinationURL.absoluteString
        ]
        
        let pasteboardOptions = [
            UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
        ]
        
        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
        
        if let instagramURL = URL(string: "instagram-stories://share?source_application=\(Bundle.main.bundleIdentifier ?? "com.sacredline.app")") {
            if UIApplication.shared.canOpenURL(instagramURL) {
                UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
            } else {
                if let storeURL = URL(string: "https://apps.apple.com/app/instagram/id389801252") {
                    UIApplication.shared.open(storeURL)
                }
            }
        }
    }
    
    private var cardToShare: some View {
        cardContentBody
            .padding(20)
            .frame(width: 304)
            .background(Color(hex: "0B0B16"))
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        LinearGradient(
                            colors: [Color.cyan, Color.purple.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
    }
}
