//
//  ShareStoryView.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI

struct ShareStoryView: View {
    var viewModel: MovieViewModel
    @Environment(\.dismiss) var dismiss
    @State private var animateGlow: Bool = false
    
    let tiers: [MarvelTier] = [.s, .a, .b, .c, .d]
    
    var body: some View {
        ZStack {
            // Background Kosmik Gelap Elegan
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "1F0608"), Color(hex: "0A0102"), Color(hex: "050000")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Efek Portal Bergeser
            Circle()
                .fill(Color(hex: "AE0F1C").opacity(0.3))
                .frame(width: 350, height: 350)
                .blur(radius: 80)
                .offset(x: animateGlow ? 100 : -100, y: animateGlow ? -150 : 150)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animateGlow)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header Sheet
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("INSTAGRAM PASSPORT")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(Color(hex: "AE0F1C"))
                                .tracking(3)
                            Text("Multiverse Tier Summary")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // --- KARTU PASPOR UTAMA UNTUK IG STORY (RENDER TARGET) ---
                    passportCardView
                        .padding(.horizontal, 20)
                    
                    // Tombol Share Utama
                    Button(action: shareToInstagramStory) {
                        HStack(spacing: 8) {
                            Image(systemName: "paperplane.fill")
                            Text("Share Passport to IG Story")
                        }
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear { animateGlow = true }
    }
    
    // MARK: - Desain Paspor Kosmik (Rich Instagram Story Template)
    private var passportCardView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header Paspor
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .foregroundColor(.yellow)
                            .font(.system(size: 10))
                        Text("SACRED NEXUS PASSPORT")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.yellow)
                            .tracking(3)
                    }
                    
                    Text("Watcher's Tier Ledger")
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Badge Total Progress
                VStack(alignment: .trailing, spacing: 2) {
                    Text("PROGRESS")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                    Text(String(viewModel.completionPercentage) + "%")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "AE0F1C"))
                }
                .padding(10)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
            }
            
            Divider().background(Color.white.opacity(0.2))
            
            // Perincian Tier (S, A, B, C, D) dengan preview film pilihan
            VStack(spacing: 10) {
                ForEach(tiers) { tier in
                    let moviesInTier = viewModel.movies.filter { $0.tier == tier }
                    
                    HStack(spacing: 12) {
                        // Badge Huruf Tier
                        Text(tier.rawValue)
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(tier.color)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(tier.title)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                Text(String(moviesInTier.count) + " missions")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            
                            // Daftar judul film ringkas dalam satu baris
                            Text(moviesInTier.isEmpty ? "No entries recorded" : moviesInTier.map { $0.title }.joined(separator: " • "))
                                .font(.system(size: 9.5))
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(1)
                        }
                    }
                    .padding(10)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(tier.color.opacity(0.4), lineWidth: 1)
                    )
                }
            }
            
            // Footer Paspor / Watermark
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("AUTHORIZED WATCHER")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                    Text("MCU Multiverse Timeline")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                Text("#SacredLine")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "AE0F1C"))
            }
            .padding(.top, 4)
        }
        .padding(20)
        .frame(width: 325) // Fixed width container preview for clean scaling
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.85)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "AE0F1C").opacity(0.8), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: Color(hex: "AE0F1C").opacity(0.25), radius: 15, x: 0, y: 6)
    }
    
    // MARK: - Fungsi Integrasi Instagram Stories
    private func shareToInstagramStory() {
        let renderer = ImageRenderer(content: passportCardView.frame(width: 360))
        renderer.scale = 3.0
        
        if let uiImage = renderer.uiImage, let imageData = uiImage.pngData() {
            let pasteboardItems: [String: Any] = [
                "com.instagram.sharedSticker.stickerImage": imageData,
                "com.instagram.sharedSticker.backgroundTopColor": "#1F0608",
                "com.instagram.sharedSticker.backgroundBottomColor": "#0A0102"
            ]
            
            UIPasteboard.general.setItems([pasteboardItems], options: [.expirationDate: Date().addingTimeInterval(60 * 5)])
            
            if let instagramURL = URL(string: "instagram-stories://share?source_application=com.sacredline.app") {
                if UIApplication.shared.canOpenURL(instagramURL) {
                    UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
                } else {
                    if let storeURL = URL(string: "https://apps.apple.com/app/instagram/id389801252") {
                        UIApplication.shared.open(storeURL)
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ShareStoryView(viewModel: MovieViewModel())
    }
}
