//
//  Set.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 07/05/2022.
//

import Foundation
import SwiftUI

struct SetPoint: Codable {
    var sum: Int
    var iterimResult: Int
    
    init() {
        self.sum = 0
        self.iterimResult = 0
    }
}

struct Set: Codable {
    var row: [String]
    var sum: Int
    var interimResult: Int
    
    init(len: Int) {
        self.row = []
        for _ in 0..<len {
            self.row.append("")
        }
        self.sum = 0
        self.interimResult = 0
    }
    
    mutating func addScore(x: Int) {
        self.sum += x
    }
    
    mutating func reduceScore(x: Int) {
        self.sum -= x
    }
    
    mutating func addInterimScore(x: Int) {
        self.interimResult += x
    }
    
    mutating func reduceInterimScore(x: Int) {
        self.interimResult -= x
    }
}

struct RoundData: Identifiable, Codable {
    let id: UUID
    var location: String
    var place: String
    var round: String
    var subRound: String
    
    var isPractice: Bool
    var isCompetition: Bool
    
    var endsCount: Int
    var arrowsPerEnd: Int
    var is3ArrowsPerEnd:Bool
    var is6ArrowsPerEnd:Bool
    
    var scoresTable: [Set]
    var colorTable: [[String]]
    var borderTable: [[Bool]]
    var interimResult: Int
    
    var current_i: Int
    var current_j: Int
    
    var lastInputScoreCell_i: Int
    var lastInputScoreCell_j: Int
    
    init() {
        self.location = ""
        self.place = "outdoor"
        self.round = "wa_international"
        self.subRound = "wa70"
        self.endsCount = 12
        self.isPractice = true
        self.isCompetition = false
        
        self.is3ArrowsPerEnd = true
        self.is6ArrowsPerEnd = false
        self.arrowsPerEnd = 6
        
        self.id = UUID()
        
        self.scoresTable = []
        for _ in 0..<self.endsCount {
            self.scoresTable.append(Set(len: arrowsPerEnd))
        }
        
        self.colorTable = []
        for _ in 0..<self.endsCount {
            var temp: [String] = []
            for _ in 0..<self.arrowsPerEnd {
                temp.append("green")
            }
            self.colorTable.append(temp)
        }
        
        self.borderTable = []
        for _ in 0..<self.endsCount {
            var temp: [Bool] = []
            for _ in 0..<self.arrowsPerEnd {
                temp.append(false)
            }
            self.borderTable.append(temp)
        }
        self.borderTable[0][0] = true
        
        self.interimResult = 0
        
        self.current_i = 0
        self.current_j = 0
        
        self.lastInputScoreCell_i = 0
        self.lastInputScoreCell_j = 0
    }
    
    mutating func fill() {
        self.scoresTable = []
        for _ in 0..<self.endsCount {
            self.scoresTable.append(Set(len: arrowsPerEnd))
        }
    }
    
    mutating func setArrowsPerEnd(value: Int) {
        self.arrowsPerEnd = value
    }
}

