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
    @State private var animateParticles: Bool = false
    @State private var pulseGlow: Bool = false
    
    private let pages: [OnboardingPageData] = [
        OnboardingPageData(
            title: "Protect the Sacred Timeline",
            description: "Keep your Marvel marathon journey organized, clean, and completely under control from start to finish.",
            systemImage: "clock.arrow.circlepath",
            accentColor: Color(hex: "00E5FF"), // Cyan Kosmik
            codeLabel: "TVA-FILE // 1260 BCE-2028"
        ),
        OnboardingPageData(
            title: "Filter Your Universe",
            description: "Instantly sort through movies, series, miniseries, and shorts in chronological MCU order with powerful filters.",
            systemImage: "slider.horizontal.3",
            accentColor: Color(hex: "9D4EDD"), // Violet Portal
            codeLabel: "TEMPORAL FILTER // ACTIVE"
        ),
        OnboardingPageData(
            title: "Rank & Flex Your Take",
            description: "Drop your personal hot takes, assign custom tiers (S to D), and share review cards straight to Instagram Stories.",
            systemImage: "square.and.arrow.up.fill",
            accentColor: Color(hex: "FFD166"), // Gold Nexus
            codeLabel: "NEXUS EVENT // UNLOCKED"
        )
    ]
    
    var body: some View {
        ZStack {
            // 1. Cinematic Deep Cosmic Void Background (Clean Dark Blue/Black, No Red Error Vibe)
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "030712"), Color(hex: "0B132B"), Color(hex: "02040A")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 2. High-Density Cosmic Floating Dust Particles (Diperbanyak jadi 45 partikel!)
            ForEach(0..<45, id: \.self) { index in
                SacredParticleView(index: index, animate: animateParticles)
            }
            .ignoresSafeArea()
            
            // 3. Main Container
            VStack(spacing: 0) {
                // Top Bar (Skip Action)
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                isOnboardingCompleted = true
                            }
                        }) {
                            Text("SKIP")
                                .font(.system(size: 12, weight: .heavy))
                                .tracking(2)
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Paged Content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(data: pages[index], pulseGlow: pulseGlow)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                Spacer()
                
                // Bottom Control Section
                VStack(spacing: 28) {
                    // Custom Organic Segmented Indicators
                    HStack(spacing: 6) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(currentPage == index ? pages[currentPage].accentColor : Color.white.opacity(0.15))
                                .frame(width: currentPage == index ? 32 : 8, height: 6)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    
                    // Immersive Action Button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            if currentPage < pages.count - 1 {
                                currentPage += 1
                            } else {
                                isOnboardingCompleted = true
                            }
                        }
                    }) {
                        HStack(spacing: 12) {
                            Text(currentPage == pages.count - 1 ? "INITIALIZE TIMELINE" : "PROCEED")
                                .font(.system(size: 14, weight: .bold))
                                .tracking(1.5)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            ZStack {
                                pages[currentPage].accentColor
                                
                                LinearGradient(
                                    colors: [.white.opacity(0.4), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                        )
                        .cornerRadius(22)
                        .shadow(color: pages[currentPage].accentColor.opacity(0.4), radius: 15, x: 0, y: 6)
                    }
                    .padding(.horizontal, 28)
                }
                .padding(.bottom, 36)
            }
        }
        .onAppear {
            animateParticles = true
            pulseGlow = true
        }
    }
}

// MARK: - High-Density Cosmic Particle Effect
struct SacredParticleView: View {
    let index: Int
    let animate: Bool
    
    // Pola posisi tersebar luas di seluruh layar
    var randomX: CGFloat {
        let multipliers: [CGFloat] = [20, 45, 70, 90, 15, 35, 60, 85, 95, 30, 50, 75, 10, 40, 65, 80, 25, 55, 70, 88]
        return (multipliers[index % multipliers.count] / 100.0) * UIScreen.main.bounds.width
    }
    
    var randomY: CGFloat {
        let multipliers: [CGFloat] = [10, 25, 40, 60, 75, 90, 15, 30, 50, 65, 80, 95, 20, 35, 55, 70, 85, 92, 45, 88]
        return (multipliers[index % multipliers.count] / 100.0) * UIScreen.main.bounds.height
    }
    
    var randomSize: CGFloat {
        return CGFloat([1.0, 2.0, 2.5, 3.0, 1.5][index % 5])
    }
    
    var particleColor: Color {
        let colors = [Color.white, Color(hex: "00E5FF"), Color(hex: "9D4EDD"), Color(hex: "FFD166")]
        return colors[index % colors.count]
    }
    
    var body: some View {
        Circle()
            .fill(particleColor)
            .frame(width: randomSize, height: randomSize)
            .shadow(color: particleColor, radius: 4)
            .position(x: randomX, y: animate ? randomY - 40 : randomY + 40)
            .opacity(animate ? (index % 2 == 0 ? 0.8 : 0.4) : 0.1)
            .animation(
                .easeInOut(duration: 2.5 + Double(index % 4))
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.05),
                value: animate
            )
    }
}

// MARK: - Data Model
struct OnboardingPageData {
    let title: String
    let description: String
    let systemImage: String
    let accentColor: Color
    let codeLabel: String
}

// MARK: - Cinematic Holographic Page View
struct OnboardingPageView: View {
    let data: OnboardingPageData
    let pulseGlow: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Holographic TVA Portal Ring Icon
            ZStack {
                // Outer Pulsing Ring
                Circle()
                    .stroke(data.accentColor.opacity(0.3), lineWidth: 1)
                    .frame(width: 170, height: 170)
                    .scaleEffect(pulseGlow ? 1.12 : 0.95)
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: pulseGlow)
                
                // Inner Glow Background
                Circle()
                    .fill(data.accentColor.opacity(0.12))
                    .frame(width: 140, height: 140)
                    .blur(radius: 12)
                
                // Glassmorphism Core Disc
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(colors: [data.accentColor, data.accentColor.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 2
                            )
                    )
                
                // Icon Center
                Image(systemName: data.systemImage)
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundColor(data.accentColor)
                    .shadow(color: data.accentColor.opacity(0.8), radius: 8, x: 0, y: 0)
            }
            .padding(.bottom, 10)
            
            // Text & Metadata Section
            VStack(spacing: 16) {
                // Tech Code Label Ala TVA Terminal
                Text(data.codeLabel)
                    .font(.system(size: 10, weight: .bold))
                    .tracking(3)
                    .foregroundColor(data.accentColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(data.accentColor.opacity(0.1))
                    .cornerRadius(8)
                
                Text(data.title)
                    .font(.custom("Georgia", size: 28, relativeTo: .title))
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(data.description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
                    .lineSpacing(5)
            }
            
            Spacer()
        }
    }
}

// MARK: - SwiftUI Preview
#Preview {
    OnboardingView(isOnboardingCompleted: .constant(false))
}

