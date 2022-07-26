//
//  File 2.swift
//  
//
//  Created by Ian Saultz on 7/23/22.
//

import Foundation

extension Device {
    internal static let lookup = FriendlyNameLookup(
        resources: [
            "AirPods",
            "AirPort",
            "AirTag",
            "AppleDisplay",
            "AppleTV",
            "HomePod",
            "iMac",
            "iMacPro",
            "iPad",
            "iPhone",
            "iPodTouch",
            "MacBook",
            "MacBookAir",
            "MacBookPro",
            "Macmini",
            "MacPro",
            "MacStudio",
            "Watch"
        ]
    )
}

class FriendlyNameLookup {
    let resources: [String]
    var lookup: [String: String] = [:]
    let sims = Set(["arm64", "i386", "i386"])
    
    
    init(resources: [String]) {
        self.resources = resources
    }
    
    private func parseKeyName(_ key: String) -> String? {
        key.firstIndex(where: \.isNumber)
            .map(key.index(before:))
            .map { String(key[...$0]) }
    }
    
    private func pullFromFile(named resource: String) -> String? {
        Bundle.module.url(
            forResource: resource,
            withExtension: ""
        )
        .flatMap { try? Data(contentsOf: $0) }
        .flatMap { String(data: $0, encoding: .utf8) }
    }
    
    private func generateLookup(for content: String) -> [String: String] {
        content
            .components(separatedBy: .newlines)
            .dropLast()
            .reduce(into: [String: String]()) {
                guard let delimiterIndex = $1.firstIndex(of: ":")
                else { preconditionFailure("Invalid source file format") }
                let k = String($1[..<delimiterIndex])
                let v = String($1[$1.index(after: delimiterIndex)...])
                $0[k] = v
            }
    }
    
    private var simModelID: String? {
        ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]
    }
    
    private func generate(_ key: String) -> String {
        if sims.contains(key),
           let key = simModelID {
            return key
        } else {
            return key
        }
    }
    
    func get(key: String) -> String {
        #if DEBUG
        let key = generate(key)
        #endif
        
        if let value = lookup[key] { return value }
        
        parseKeyName(key)
            .flatMap(pullFromFile(named:))
            .flatMap(generateLookup(for:))
            .map { lookup.merge($0) { $1 } }
        
        return lookup[key] ?? key
    }
}
