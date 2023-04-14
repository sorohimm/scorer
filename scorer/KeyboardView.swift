//
//  ScoreKeyboardView.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 26/04/2022.
//

import SwiftUI

struct KeyboardView: View {
    @Binding var isKeyboardVisible: Bool
    @State private var dragOffset: CGSize = .zero
    @Binding var session: Session
    @Binding var currentRow: Int
    @Binding var currentColumn: Int
    @Binding var buttonSelector: ButtonSelector

    var body: some View {
        ZStack {
            if isKeyboardVisible {
                VStack {
                    Spacer()
                    VStack() {
                        ZStack(alignment: .topLeading) {
                            HStack {
                                VStack(spacing: 2) {
                                    HStack(spacing: 2) {
                                        Spacer()
                                        Group {
                                            scoreButton(scoreAlias: "X", score: Score.X, backgroundColor: "yellow", txColor: "black")
                                            scoreButton(scoreAlias: "10", score: Score.Ten, backgroundColor: "yellow", txColor: "black")
                                            scoreButton(scoreAlias: "9", score: Score.Nine, backgroundColor: "yellow", txColor: "black")
                                            scoreButton(scoreAlias: "8", score: Score.Eight, backgroundColor: "red", txColor: "black")
                                        }
                                                .padding(.horizontal, 1)
                                                .padding(.vertical, 1)
                                        Spacer()
                                    }
                                    HStack(spacing: 2) {
                                        Spacer()
                                        Group {
                                            scoreButton(scoreAlias: "7", score: Score.Seven, backgroundColor: "red", txColor: "black")
                                            scoreButton(scoreAlias: "6", score: Score.Six, backgroundColor: "blue", txColor: "black")
                                            scoreButton(scoreAlias: "5", score: Score.Five, backgroundColor: "blue", txColor: "black")
                                            scoreButton(scoreAlias: "4", score: Score.Four, backgroundColor: "black", txColor: "white")
                                        }
                                                .padding(.horizontal, 1)
                                                .padding(.vertical, 1)
                                        Spacer()
                                    }
                                    HStack(spacing: 2) {
                                        Spacer()
                                        Group {
                                            scoreButton(scoreAlias: "3", score: Score.Three, backgroundColor: "black", txColor: "white")
                                            scoreButton(scoreAlias: "2", score: Score.Two, backgroundColor: "white", txColor: "black")
                                            scoreButton(scoreAlias: "1", score: Score.One, backgroundColor: "white", txColor: "black")
                                            scoreButton(scoreAlias: "M", score: Score.Miss, backgroundColor: "green", txColor: "black")
                                        }
                                                .padding(.horizontal, 1)
                                                .padding(.vertical, 1)
                                        Spacer()
                                    }
                                }
                            }
                        }
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 7)
                                .background(Color.gray.opacity(0.7))
                                .cornerRadius(15)
                                .padding(.bottom, 1)
                                .offset(dragOffset)
                                .gesture(
                                        DragGesture()
                                                .onChanged { value in
                                                    if value.translation.height > 0 {
                                                        dragOffset.height = value.translation.height
                                                    }
                                                }
                                                .onEnded { value in
                                                    if value.translation.height > 100 {
                                                        isKeyboardVisible = false
                                                    }
                                                    dragOffset = .zero
                                                }
                                )
                    }
                }
            }
        }


    }

    private func scoreButton(scoreAlias: String, score: Score, backgroundColor: String, txColor: String) -> some View {
        AnyView(
                Button(action: {
                    handleInput(score: score)
                }) {
                    Text(scoreAlias).padding()
                            .foregroundColor(colorResolver(strColor: txColor))
                }
                        .font(.headline.bold())
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .background(colorResolver(strColor: backgroundColor))
                        .cornerRadius(10)
        )
    }

    private func handleInput(score: Score) {
        session.setScore(score: score)
        changePosition()
    }

    private func changePosition() {
        if currentColumn + currentRow != session.endsCount - 1 + session.arrowsPerEnd - 1 {
            // last row cell condition
            if currentColumn == session.arrowsPerEnd - 1 && currentRow != session.endsCount - 1 {
                currentColumn = 0
                currentRow += 1
            } else { // just move to the next cell
                currentColumn += 1
            }
        }

        buttonSelector.selectButton(row: currentRow, column: currentColumn)
    }
}

