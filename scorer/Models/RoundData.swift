//
//  RoundData.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 07/05/2022.
//

import Foundation
import SwiftUI

enum Score: Int, Codable {
    case Null = -1, Miss, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, X
}

struct Set: Codable {
    private var row: [Score]
    private var sum: Int
    private var interimResult: Int

    init(len: Int) {
        row = [Score](repeating: Score.Null, count: len)
        sum = 0
        interimResult = 0
    }

    mutating func setScore(column: Int, x: Score) {
        row[column] = x
        updateSum()
    }

    mutating private func updateSum() {
        var newSum = 0
        for num in row {
            if num == Score.Null {
                continue
            }
            if num == Score.X {
                newSum += Score.Ten.rawValue
            } else {
                newSum += num.rawValue
            }
        }
        sum = newSum
    }

    func getSum() -> Int {
        return sum
    }

    func getScore(column: Int) -> Score {
        return row[column]
    }

    func getInterimResult() -> Int {
        return interimResult
    }

    mutating func setInterimResult(x: Int) {
        interimResult = x
    }
}

struct RoundData: Identifiable, Codable {
    let id: UUID

    var endsCount: Int
    var arrowsPerEnd: Int

    private var scoresTable: [Set] = []
    var sum: Int

    init(endsCount: Int, arrowsPerEnd: Int) {
        id = UUID()
        sum = 0

        self.endsCount = endsCount
        self.arrowsPerEnd = arrowsPerEnd

        scoresTable = [Set](repeating: Set(len: arrowsPerEnd), count: endsCount)
    }

    init() {
        id = UUID()
        sum = 0

        endsCount = 0
        arrowsPerEnd = 0

        scoresTable = []
    }

    mutating func setScore(row: Int, column: Int, score: Score) {
        scoresTable[row].setScore(column: column, x: score)
        updateSum()
        updateInterim()
    }

    mutating private func updateSum() {
        var newSum = 0
        for set in scoresTable {
            newSum += set.getSum()
        }

        sum = newSum
    }

    mutating private func updateInterim() {
        var prevInterim = 0
        for i in scoresTable.indices {
            prevInterim += scoresTable[i].getSum()
            scoresTable[i].setInterimResult(x: prevInterim)
        }
    }

    func getSetScore(set: Int, column: Int) -> Score {
        return scoresTable[set].getScore(column: column)
    }

    func getSetSum(set: Int) -> Int {
        return scoresTable[set].getSum()
    }

    func getSetInterimResult(set: Int) -> Int {
        return scoresTable[set].getInterimResult()
    }

    func getSum() -> Int {
        return sum
    }
}

