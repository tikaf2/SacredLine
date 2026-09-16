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
    @FocusState private var isNotesFocused: Bool
    @State private var animateGlow: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradientView
                glowingBackgroundCircle
                
                VStack(spacing: 0) {
                    headerNavigationBar
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            movieInfoCardSection
                            photoMomentSection
                            tierPickerSection
                            personalReviewSection
                            dateAndToggleSection
                            saveButtonSection
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
            .onAppear { animateGlow = true }
        }
    }
    
    // MARK: - Subcomponents
    
    private var backgroundGradientView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1F0608"), Color(hex: "0A0102")]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var glowingBackgroundCircle: some View {
        Circle()
            .fill(movie.mediaGlowColor.opacity(0.15))
            .frame(width: 300, height: 300)
            .blur(radius: 60)
            .offset(x: animateGlow ? 100 : -100, y: animateGlow ? -150 : 150)
            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animateGlow)
            .ignoresSafeArea()
    }
    
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
                Text("MISSION LOG")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(movie.mediaGlowColor)
                    .tracking(2)
                Text(movie.title)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if movie.tier != .unranked {
                Button(action: { showSharePreview = true }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(movie.mediaGlowColor.opacity(0.3))
                        .clipShape(Circle())
                }
            } else {
                Color.clear.frame(width: 36, height: 36)
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
                                colors: [movie.mediaGlowColor.opacity(0.5), Color.black],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    VStack(spacing: 2) {
                        Image(systemName: "film.fill")
                            .foregroundColor(movie.mediaGlowColor)
                            .font(.system(size: 20))
                        Text(movie.year)
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .frame(width: 65, height: 85)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(movie.mediaGlowColor.opacity(0.8), lineWidth: 1.5)
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
                Text("OFFICIAL SYNOPSIS")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(movie.mediaGlowColor)
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
                .opacity(0.7)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [movie.mediaGlowColor.opacity(0.6), Color.white.opacity(0.05)],
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
                Text("Marathon Photo Moment")
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
            
            Button(action: {
                PHPhotoLibrary.requestAuthorization { status in
                    DispatchQueue.main.async {
                        showImagePicker = true
                    }
                }
            }) {
                HStack(spacing: 12) {
                    if let data = movie.userPhotoData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Photo Attached")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                            Text("Tap to change photo")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.08))
                                .frame(width: 60, height: 60)
                            Image(systemName: "photo.badge.plus")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.system(size: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Add Watch Photo / Ticket")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                            Text("Tap to select from gallery")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    Spacer()
                }
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
                Text("Personal Ranking")
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
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
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
                                    Circle().stroke(isSelected ? Color.white : Color.white.opacity(0.15), lineWidth: isSelected ? 2.5 : 1)
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
            Text("Personal Review & Thoughts")
                .font(.headline)
                .foregroundColor(.white)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .opacity(0.5)
                
                if movie.notes.isEmpty {
                    Text("Write down your thoughts, favorite scenes, or hot takes...")
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
                .toggleStyle(SwitchToggleStyle(tint: movie.mediaGlowColor))
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
    
    private var saveButtonSection: some View {
        Button(action: saveAction) {
            Text("Save Mission Log")
                .font(.headline.bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(movie.mediaGlowColor)
                .cornerRadius(16)
                .shadow(color: movie.mediaGlowColor.opacity(0.5), radius: 10, x: 0, y: 4)
        }
        .padding(.top, 10)
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

// MARK: - Template Share IG Story
struct MovieReviewShareCard: View {
    let movie: MarvelMovie
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "2D0B0E"), Color(hex: "0A0102")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack {
                        Text("SHARE REVIEW CARD")
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
                    
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("SACRED LINE REVIEW")
                                    .font(.system(size: 8, weight: .black))
                                    .foregroundColor(movie.mediaGlowColor)
                                    .tracking(2)
                                Text(movie.year)
                                    .font(.caption.bold())
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                            
                            if movie.tier != .unranked {
                                Text(movie.tier.rawValue)
                                    .font(.system(size: 22, weight: .black))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(movie.tier.color)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.title3.bold())
                                .foregroundColor(.white)
                                .lineLimit(2)
                            Text(movie.duration)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                        if let data = movie.userPhotoData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("MY HOT TAKE / OPINION:")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.white.opacity(0.4))
                            
                            Text(movie.notes.isEmpty ? "No personal notes logged yet." : "\"" + movie.notes + "\"")
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(4)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(12)
                        
                        HStack {
                            Text("#SacredLine #MCUReview")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white.opacity(0.4))
                            Spacer()
                            Text(movie.wouldRewatch ? "🔄 Would Rewatch" : "")
                                .font(.caption2.bold())
                                .foregroundColor(.green)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .opacity(0.7)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        LinearGradient(
                                            colors: [movie.mediaGlowColor, Color.white.opacity(0.1)],
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
    }
    
    private func shareToInstagramStory() {
        let renderer = ImageRenderer(content: cardToShare)
        renderer.scale = 3.0
        
        guard let uiImage = renderer.uiImage, let imageData = uiImage.pngData() else { return }
        
        // Tautan interaktif di pojok kiri atas IG Story (ganti dengan link tujuan kamu)
        let destinationURL = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")!
        
        let pasteboardItems: [String: Any] = [
            "com.instagram.sharedSticker.stickerImage": imageData,
            "com.instagram.sharedSticker.backgroundTopColor": "#1F0608",
            "com.instagram.sharedSticker.backgroundBottomColor": "#0A0102",
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
        VStack(alignment: .leading, spacing: 12) {
            Text("SACRED LINE REVIEW")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(movie.mediaGlowColor)
            Text(movie.title)
                .font(.title2.bold())
                .foregroundColor(.white)
            
            if let data = movie.userPhotoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text("Tier: " + (movie.tier == .unranked ? "Unranked" : movie.tier.rawValue))
                .font(.headline)
                .foregroundColor(.yellow)
            Text(movie.notes.isEmpty ? "" : "\"" + movie.notes + "\"")
                .font(.subheadline)
                .italic()
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(24)
        .frame(width: 350)
        .background(Color(hex: "1F0608"))
        .cornerRadius(24)
    }
}
