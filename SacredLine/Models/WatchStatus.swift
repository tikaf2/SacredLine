//
//  WatchStatus.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI

enum WatchStatus: String, CaseIterable, Codable {
    case all = "All"
    case completed = "Completed"
    case incomplete = "Incomplete"
    case notStarted = "Not Started"
    case comingSoon = "Coming Soon"
    
    var color: Color {
        switch self {
        case .completed: return .green
        case .incomplete: return .orange
        case .notStarted: return .gray
        case .comingSoon: return Color.purple.opacity(0.8)
        case .all: return .white
        }
    }
}

enum MarvelTier: String, CaseIterable, Identifiable, Codable {
    case s = "S"
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case unranked = ""
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .s: return "Elite"
        case .a: return "Great"
        case .b: return "Mid-High"
        case .c: return "Decent"
        case .d: return "Flawed"
        default: return ""
        }
    }
    
    var color: Color {
        switch self {
        case .s: return Color(hex: "D00000")
        case .a: return Color(hex: "E65F2B")
        case .b: return Color(hex: "3F7D45")
        case .c: return Color(hex: "2D5A7B")
        case .d: return Color(hex: "1F4068")
        default: return .clear
        }
    }
}

struct MarvelMovie: Identifiable, Codable {
    let id: UUID
    let title: String
    let year: String
    let duration: String
    let description: String
    var tier: MarvelTier
    var notes: String
    var watchDate: Date
    var wouldRewatch: Bool
    var statusOverride: WatchStatus?
    var userPhotoData: Data?
    
    // Inisialisasi default agar parameter lama tidak error
    init(id: UUID = UUID(), title: String, year: String, duration: String, description: String, tier: MarvelTier = .unranked, notes: String = "", watchDate: Date = Date(), wouldRewatch: Bool = false, statusOverride: WatchStatus? = nil, userPhotoData: Data? = nil) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.description = description
        self.tier = tier
        self.notes = notes
        self.watchDate = watchDate
        self.wouldRewatch = wouldRewatch
        self.statusOverride = statusOverride
        self.userPhotoData = userPhotoData
    }
    
    var status: WatchStatus {
        if let override = statusOverride {
            return override
        }
        if tier != .unranked && !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .completed
        } else if tier != .unranked {
            return .incomplete
        } else {
            return .notStarted
        }
    }
    
    var mediaGlowColor: Color {
        let text = duration.lowercased()
        let titleLower = title.lowercased()
        
        if text.contains("series") || titleLower.contains("season") {
            return Color(hex: "00E5FF")
        } else if text.contains("mini") {
            return Color(hex: "AA00FF")
        } else if (text.contains("m") && !text.contains("h")) || text.contains("short") || titleLower.contains("one-shot") {
            return Color(hex: "FFEA00")
        } else {
            return Color(hex: "FF3D00")
        }
    }
}
