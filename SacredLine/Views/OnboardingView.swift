//
//  OnboardingView.swift
//  SacredLine
//
//  Created by Mentari Tika on 17/09/26.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPage: Int = 0
    
    private let pages: [OnboardingPageData] = [
        OnboardingPageData(
            title: "Protect the Sacred Timeline",
            description: "Keep your Marvel marathon journey organized, clean, and completely under control from start to finish.",
            systemImage: "clock.arrow.circlepath",
            accentColor: Color(hex: "AE0F1C")
        ),
        OnboardingPageData(
            title: "Filter Your Universe",
            description: "Instantly sort through movies, series, miniseries, and shorts in chronological MCU order with powerful filters.",
            systemImage: "slider.horizontal.3",
            accentColor: Color(hex: "00E5FF")
        ),
        OnboardingPageData(
            title: "Rank & Flex Your Take",
            description: "Drop your personal hot takes, assign custom tiers (S to D), and share gorgeous review cards straight to Instagram Stories.",
            systemImage: "square.and.arrow.up.fill",
            accentColor: Color(hex: "FF007F")
        )
    ]
    
    var body: some View {
        ZStack {
            // Background Sinematik Gelap
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "1F0608"), Color(hex: "0A0102"), Color(hex: "050000")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Tombol Skip di kanan atas
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            withAnimation {
                                isOnboardingCompleted = true
                            }
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    }
                }
                
                // TabView untuk halaman Onboarding
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(data: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Custom Page Indicator & Button Section
                VStack(spacing: 24) {
                    // Dot Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(currentPage == index ? pages[currentPage].accentColor : Color.white.opacity(0.2))
                                .frame(width: currentPage == index ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentPage)
                        }
                    }
                    
                    // Action Button (Next / Get Started)
                    Button(action: {
                        withAnimation {
                            if currentPage < pages.count - 1 {
                                currentPage += 1
                            } else {
                                isOnboardingCompleted = true
                            }
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(pages[currentPage].accentColor)
                            .cornerRadius(18)
                            .shadow(color: pages[currentPage].accentColor.opacity(0.5), radius: 10, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Data Model & Subview untuk Halaman Onboarding
struct OnboardingPageData {
    let title: String
    let description: String
    let systemImage: String
    let accentColor: Color
}

struct OnboardingPageView: View {
    let data: OnboardingPageData
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon dengan Efek Lingkaran Bercahaya (Glow)
            ZStack {
                Circle()
                    .fill(data.accentColor.opacity(0.15))
                    .frame(width: 160, height: 160)
                    .blur(radius: 20)
                
                RoundedRectangle(cornerRadius: 32)
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                    .frame(width: 120, height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(data.accentColor.opacity(0.6), lineWidth: 1.5)
                    )
                
                Image(systemName: data.systemImage)
                    .font(.system(size: 44))
                    .foregroundColor(data.accentColor)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                Text(data.title)
                    .font(.custom("Georgia", size: 26, relativeTo: .title))
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(data.description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
    }
}
