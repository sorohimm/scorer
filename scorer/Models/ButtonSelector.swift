//
// Created by Mashir, Vladimir on 14.04.2023.
//

import Foundation

class ButtonSelector {
    var matrix: [[Bool]]
    @Published var selectedRow: Int
    @Published var selectedColumn: Int

    init(rows: Int, columns: Int, currentSet: Int, currentColumn: Int) {
        matrix = [[Bool]](repeating: [Bool](repeating: false, count: columns), count: rows)
        selectedRow = currentSet
        selectedColumn = currentColumn
        selectButton(row: currentSet, column: currentColumn)
    }


    init() {
        matrix = [[Bool]](repeating: [Bool](repeating: false, count: 0), count: 0)
        selectedRow = 0
        selectedColumn = 0
    }

    func selectButton(row: Int, column: Int) {
        matrix[selectedRow][selectedColumn] = false
        matrix[row][column] = true
        selectedRow = row
        selectedColumn = column
    }

    func isSelected(row: Int, column: Int) -> Bool {
        matrix[row][column]
    }
}
