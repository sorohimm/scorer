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
    var subRound: String
    var round: String

    var roundData: RoundData

    var lastInputSet: Int
    var lastInputColumn: Int
    var currentSet: Int
    var currentColumn: Int

    var isPractice: Bool
    var isCompetition: Bool
    var arrowsPerEnd: Int
    var endsCount: Int

    init(id: UUID = UUID(), title: String, date: Date, roundData: RoundData) {
        self.id = id
        self.title = title
        self.date = date
        self.roundData = roundData

        subRound = ""
        round = ""

        lastInputSet = 0
        lastInputColumn = 0
        currentSet = 0
        currentColumn = 0
        isPractice = true
        isCompetition = false
        arrowsPerEnd = 6
        endsCount = 12
    }
}

extension Session {
    struct Data {
        var title = ""
        var date = Date.now
        var roundData = RoundData()

        var subRound = ""
        var round = ""

        var lastInputSet = 0
        var lastInputColumn = 0
        var currentSet = 0
        var currentColumn = 0

        var isPractice = true
        var isCompetition = false
        var arrowsPerEnd = 0
        var endsCount = 0

        mutating func setArrowsPerSet(value: Int) {
            arrowsPerEnd = value
        }

        mutating func fillRoundData() {
            roundData = RoundData(endsCount: 3, arrowsPerEnd: 6)
        }
    }


    var data: Data {
        Data(title: title,
                date: date,
                roundData: roundData,
                isPractice: isPractice,
                isCompetition: isCompetition,
                arrowsPerEnd: arrowsPerEnd
        )
    }

    mutating func update(from data: Data) {
        title = data.title
        date = data.date
        roundData = data.roundData
    }

    mutating func update(from roundData: RoundData) {
        self.roundData = roundData
    }

    mutating func setLastInputSet(x: Int) {
        lastInputSet = x
    }

    mutating func setLastInputColumn(x: Int) {
        lastInputColumn = x
    }

    mutating func setCurrentSet(x: Int) {
        currentSet = x
    }

    mutating func setCurrentColumn(x: Int) {
        currentColumn = x
    }

    mutating func setScore(score: Score) {
        roundData.setScore(row: currentSet, column: currentColumn, score: score)
    }

    func getScore(set: Int, column: Int) -> Score {
        return roundData.getSetScore(set: set, column: column)
    }

    init(data: Data) {
        id = UUID()
        title = data.title
        date = data.date
        roundData = data.roundData

        subRound = data.subRound
        round = data.round

        lastInputSet = data.lastInputSet
        lastInputColumn = data.lastInputColumn
        currentSet = data.currentSet
        currentColumn = data.currentColumn

        isPractice = data.isPractice
        isCompetition = data.isCompetition
        arrowsPerEnd = data.arrowsPerEnd
        endsCount = data.endsCount
    }

}

extension Session {
    static let sampleData: [Session] = []
}
