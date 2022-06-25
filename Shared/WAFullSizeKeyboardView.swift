//
//  ScoreKeyboardView.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 26/04/2022.
//

import SwiftUI

func checkCellPosition(i: inout Int, j: inout Int, maxI: Int, maxJ: Int) {
    if i == maxI && j == maxJ { // last cell condition
        return
    }
    
    if j == maxJ && i != maxI { // switching to a new line
        j = 0
        i += 1
    } else { // continue on current row
        j += 1
    }
}

func canCompleteInput(i: Int, j: Int, maxI: Int, maxJ: Int) -> Bool {
    if j == maxJ && i == maxI {
        return false
    }
    return true
}

func pointResolver(x: String) -> Int {
    if x == "X" {
        return 10
    } else if x == "M" {
        return 0
    } else {
        return Int(x) ?? 0
    }
}

struct WAFullSizeKeyboardView : View {
    @Binding var isActive: Bool
    @Binding var session: Session
    @Binding var data: Session.Data
    
    @Binding var IcurrentScoreCell: Int
    @Binding var JcurrentScoreCell: Int
    
    @State private var isLastInput: Bool = false
    
    var body : some View{
        VStack() {
            Button(action: {isActive = !isActive}) {
                Image(systemName: "x.circle")
            }.offset(x: 160)
            ZStack(alignment: .topLeading) {
                HStack {
                    VStack (spacing: 2) {
                        HStack (spacing: 2) {
                            Spacer()
                            Group {
                                scoreButton(point: "X", bcColor: "yellow", txColor: "black")
                                scoreButton(point: "10", bcColor: "yellow", txColor: "black")
                                scoreButton(point: "9", bcColor: "yellow", txColor: "black")
                                scoreButton(point: "8", bcColor: "red", txColor: "black")
                            }
                            .padding(.horizontal, 1)
                            .padding(.vertical, 1)
                            Spacer()
                        }
                        HStack (spacing: 2) {
                            Spacer()
                            Group {
                                scoreButton(point: "7", bcColor: "red", txColor: "black")
                                scoreButton(point: "6", bcColor: "blue", txColor: "black")
                                scoreButton(point: "5", bcColor: "blue", txColor: "black")
                                scoreButton(point: "4", bcColor: "black", txColor: "white")
                            }
                            .padding(.horizontal, 1)
                            .padding(.vertical, 1)
                            Spacer()
                        }
                        HStack(spacing: 2) {
                            Spacer()
                            Group {
                                scoreButton(point: "3", bcColor: "black", txColor: "white")
                                scoreButton(point: "2", bcColor: "white", txColor: "black")
                                scoreButton(point: "1", bcColor: "white", txColor: "black")
                                scoreButton(point: "M", bcColor: "green", txColor: "black")
                            }
                            .padding(.horizontal, 1)
                            .padding(.vertical, 1)
                            Spacer()
                        }
                    }
                    
                    VStack {
                        Button(action: {
                            //setAndUpdate(point: point, color: bcColor)
                        }) {
                            Text("<-").padding()
                                .foregroundColor(Color.black)
                        }
                        .font(.headline.bold())
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    .frame(width: 20)
                    Spacer()
                        .frame(width: 15)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 7)
            .background(Color.cyan)
            .cornerRadius(25)
        }
    }
    
    private func scoreButton(point: String, bcColor: String, txColor: String) -> some View {
        return AnyView(
            Button(action: {
                updateScore(point: point, color: bcColor)
            }) {
                Text(point).padding()
                    .foregroundColor(colorResolver(strColor: txColor))
            }
                .font(.headline.bold())
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(colorResolver(strColor: bcColor))
                .cornerRadius(10)
        )
    }
    
    private func updateScore(point: String, color: String) {
        // cell update case
        if session.roundData.scoresTable[IcurrentScoreCell].row[JcurrentScoreCell] != "" {
            session.reduceAllNext(i: IcurrentScoreCell, score: pointResolver(x:
                                                                                session.roundData.scoresTable[IcurrentScoreCell].row[JcurrentScoreCell]))
            
            session.reduceSetScore(i: IcurrentScoreCell, score: pointResolver(x:
                                                                                session.roundData.scoresTable[IcurrentScoreCell].row[JcurrentScoreCell]))
            
            session.reduceSessionScore(score: pointResolver(x: session.roundData.scoresTable[IcurrentScoreCell].row[JcurrentScoreCell]))
            
            session.addAllNext(i: IcurrentScoreCell, score: pointResolver(x: point))
            
        }
        
        if canCompleteInput(i: IcurrentScoreCell, j: JcurrentScoreCell, maxI: session.roundData.endsCount, maxJ: session.roundData.arrowsPerEnd) {
            // set new point to cell
            session.roundData.scoresTable[IcurrentScoreCell].row[JcurrentScoreCell] = point
            session.setPoint(i: IcurrentScoreCell, j: JcurrentScoreCell, point: point)
            
            // score update
            session.addSetScore(i: IcurrentScoreCell, score: pointResolver(x: point))
            session.addSessionScore(score: pointResolver(x: point))
            
            // set color
            session.setColor(i: IcurrentScoreCell, j: JcurrentScoreCell, color: color)
            
            // removing the selection from the last button
            session.borderToggle(i: session.roundData.current_i, j: session.roundData.current_j)
            
            // check positions
            checkCellPosition(i: &IcurrentScoreCell, j: &JcurrentScoreCell, maxI: session.roundData.endsCount - 1, maxJ: session.roundData.arrowsPerEnd - 1)
            
            // set positions
            session.setCurrentI(x: IcurrentScoreCell)
            session.setCurrentJ(x: JcurrentScoreCell)
            
            // put the selection on the new button
            session.borderToggle(i: IcurrentScoreCell, j: JcurrentScoreCell)
            
            // update last input if nessesary
            if session.roundData.scoresTable[IcurrentScoreCell].row[JcurrentScoreCell] == "" {
                session.setLastInputI(x: IcurrentScoreCell)
                session.setLastInputJ(x: JcurrentScoreCell)
            }
        }
    }
}

