//
//  Session.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 25/04/2022.
//

import Foundation
import SwiftUI

struct Session: Identifiable, Codable {
    let id: UUID
    var title: String
    var date: Date
    var roundData: RoundData
    
    init(id: UUID = UUID(), title: String, date: Date, roundData: RoundData) {
        self.id = id
        self.title = title
        self.date = date
        self.roundData = roundData
    }
}

extension Session {
    struct Data {
        var title: String = ""
        var date: Date = Date.now
        var roundData: RoundData = RoundData()
    }
    
    var data: Data {
        Data(title: title, date: date, roundData: roundData)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        date = data.date
        roundData = data.roundData
    }
    
    mutating func update(from roundData: RoundData) {
        self.roundData = roundData
    }
    
    mutating func setPoint(i: Int, j: Int, point: String) {
        roundData.scoresTable[i].row[j] = point
    }
    
    mutating func setColor(i: Int, j: Int, color: String) {
        roundData.colorTable[i][j] = color
    }
    
    mutating func setCurrentI(x: Int) {
        self.roundData.current_i = x
    }
    
    mutating func setCurrentJ(x: Int) {
        self.roundData.current_j = x
    }
    
    mutating func setLastInputI(x: Int) {
        self.roundData.lastInputScoreCell_i = x
    }
    
    mutating func setLastInputJ(x: Int) {
        self.roundData.lastInputScoreCell_j = x
    }
    
    mutating func addSessionScore(score: Int) {
        self.roundData.interimResult += score
    }
    
    mutating func reduceSessionScore(score: Int) {
        self.roundData.interimResult -= score
    }
    
    mutating func setArrowsPerEnd(value: Int) {
        self.roundData.arrowsPerEnd = value
    }
    
    mutating func addAllNext(i: Int, score: Int) {
        for t in i+1 ..< self.roundData.scoresTable.count {
            //if self.roundData.scoresTable[t].sum == 0 {
            //    break
            //}
            self.roundData.scoresTable[t].addInterimScore(x: score)
        }
    }
    
    mutating func reduceAllNext(i: Int, score: Int) {
        for t in i+1 ..< self.roundData.scoresTable.count {
            if self.roundData.scoresTable[t].sum == 0 {
                break
            }
            self.roundData.scoresTable[t].reduceInterimScore(x: score)
        }
    }
    
    mutating func addSetScore(i: Int, score: Int) {
        if i > 0 {
            if self.roundData.scoresTable[i - 1].interimResult > 0 &&  self.roundData.scoresTable[i].interimResult == 0 {
                self.roundData.scoresTable[i].addInterimScore(x: self.roundData.scoresTable[i - 1].interimResult)
            }
        }
        self.roundData.scoresTable[i].addInterimScore(x: score)
        self.roundData.scoresTable[i].addScore(x: score)
    }
    
    mutating func reduceSetScore(i: Int, score: Int) {
        self.roundData.scoresTable[i].reduceScore(x: score)
        self.roundData.scoresTable[i].reduceInterimScore(x: score)
    }
    
    mutating func borderToggle(i: Int, j: Int) {
        self.roundData.borderTable[i][j].toggle()
    }
    
    init(data: Data) {
        id = UUID()
        title = data.title
        date = data.date
        roundData = data.roundData
    }
}

extension Session {
    static let sampleData: [Session] = []
}
