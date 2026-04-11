//
//  DeviceFamily.swift
//  ViewCollection
//
//  Created by Vaida on 2026-04-11.
//

import Foundation


/// macOS device family.
public enum DeviceFamily: UInt8, CaseIterable, Sendable, CustomStringConvertible, Codable, Identifiable, Hashable {
    case MacBook
    case MacBookPro
    case MacBookAir
    case MacMini
    case MacStudio
    case iMac
    case MacPro
    /// Generic, unknown family.
    case mac
    
    public var id: UInt8 {
        self.rawValue
    }
    
    public var description: String {
        switch self {
        case .MacBook: return "MacBook"
        case .MacBookPro: return "MacBook Pro"
        case .MacBookAir: return "MacBook Air"
        case .MacMini: return "Mac mini"
        case .MacStudio: return "Mac Studio"
        case .iMac: return "iMac"
        case .MacPro: return "Mac Pro"
        case .mac: return "Mac"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .MacBookPro, .MacBook, .MacBookAir:
            "macbook"
        case .MacMini:
            "macmini.gen3"
        case .MacStudio:
            "macstudio"
        case .iMac:
            "desktopcomputer"
        case .MacPro:
            "macpro.gen3"
        case .mac:
            "macbook"
        }
    }
    
#if os(macOS)
    /// The device family for the current device.
    public static let current: DeviceFamily = {
        return switch macModelNameSystemProfiler() {
        case "MacBook": .MacBook
        case "MacBook Pro": .MacBookPro
        case "MacBook Air": .MacBookAir
        case "Mac mini": .MacMini
        case "Mac Studio": .MacStudio
        case "iMac": .iMac
        case "Mac Pro": .MacPro
        default: .mac
        }
    }()
    
    private static func macModelNameSystemProfiler() -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/system_profiler")
        process.arguments = ["SPHardwareDataType"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()
        
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return nil
        }
        
        guard process.terminationStatus == 0,
              let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) else {
            return nil
        }
        
        for line in output.split(separator: "\n") {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.hasPrefix("Model Name:") {
                return trimmed.replacingOccurrences(of: "Model Name:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        return nil
    }
#endif

}
