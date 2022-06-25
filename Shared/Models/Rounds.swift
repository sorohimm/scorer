//
//  Rounds.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 07/05/2022.
//

import Foundation

enum Rounds: String, CaseIterable, Identifiable {
    case WA, GNAS, USA
    var id: Self { self }
}

enum WA: String, CaseIterable, Identifiable {
    case wa1440, wa70, wa60, wa50
    var id: Self { self }
}

extension Rounds {
    var subRounds: WA {
        switch self {
        case .WA: return .wa70
        case .GNAS: return .wa60
        case .USA: return .wa1440
        }
    }
}
