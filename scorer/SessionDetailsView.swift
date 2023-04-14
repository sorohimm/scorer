//
//  ScoreDetailsView.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 25/04/2022.
//

import SwiftUI


struct OvalTextFieldStyle: TextFieldStyle {
    @Binding var tfColor: Color

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
                .padding(10)
                .background(tfColor)
                .cornerRadius(5)
    }
}

struct InfoList: View {
    @Binding var session: Session
    var body: some View {
        Section(header: Text("Session Info")) {
            HStack {
                Label("Date", systemImage: "calendar")
                Spacer()
                Text(session.date, style: .date)
            }
            HStack {
                Label("Location", systemImage: "paperplane")
                Spacer()
                Text(/*TODO: add location*/ "")
            }
            HStack {
                Label("Round", systemImage: "target")
                Spacer()
                Text(session.subRound)
            }
                    .accessibilityElement(children: .combine)
        }
                .padding()
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct ResultSum: View {
    var value: Int
    var body: some View {
        ZStack {
            Text(String(value))
        }
                .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 19)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.cyan))
    }
}

struct OutlineButton: ButtonStyle {
    @Binding var isSelect: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration
                .label
                .foregroundColor(configuration.isPressed ? .gray : .accentColor)
                .font(.headline.bold())
                .frame(height: 28)
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .overlay(isSelect ?
                        RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.purple, lineWidth: 3)
                        :
                        RoundedRectangle(
                                cornerRadius: 8,
                                style: .continuous
                        ).stroke(Color.accentColor)
                )
    }
}

func setScoreString(x: Int) -> String {
    if x == 0 {
        return ""
    }
    return String(x)
}

func setIter(i: Int) -> String {
    if i < 9 {
        return String(i + 1) + ". "
    } else {
        return String(i + 1) + "."
    }
}

func colorResolver(strColor: String) -> Color {
    switch strColor {
    case "yellow": return Color.yellow
    case "red": return Color.red
    case "blue": return Color.blue
    case "black": return Color.black
    case "white": return Color.white
    case "green": return Color.green
    default: return Color.teal
    }
}

func buttonTextResolver(score: Score) -> String {
    switch score {
    case Score.Null: return ""
    case Score.Miss: return "M"
    case Score.One: return "1"
    case Score.Two: return "2"
    case Score.Three: return "3"
    case Score.Four: return "4"
    case Score.Five: return "5"
    case Score.Six: return "6"
    case Score.Seven: return "7"
    case Score.Eight: return "8"
    case Score.Nine: return "9"
    case Score.Ten: return "10"
    case Score.X: return "X"
    }
}

struct SessionDetailView: View {
    @Binding var session: Session
    @State private var data = Session.Data()

    @State private var isPresentingEditView: Bool = false
    @State private var isScoreKeyboardActive: Bool = false

    @State private var selector: ButtonSelector

    init(session: Binding<Session>) {
        _session = session
        _data = State(initialValue: session.wrappedValue.data)
        _selector = State(initialValue: ButtonSelector(rows: session.wrappedValue.roundData.endsCount, columns: session.wrappedValue.roundData.arrowsPerEnd, currentSet: session.wrappedValue.currentSet, currentColumn: session.wrappedValue.currentColumn))
    }

    var body: some View {
        ZStack {
            List {
                InfoList(session: self.$session)
                scoreSection
            }
                    .navigationTitle(session.title)
                    .toolbar {
                        Button("Edit") {
                            isPresentingEditView = true
                            data = session.data
                        }
                    }
                    .sheet(isPresented: $isPresentingEditView) {
                        SessionDetailEditView(data: $data)
                    }
            if isScoreKeyboardActive {
                KeyboardView(isKeyboardVisible: $isScoreKeyboardActive,
                        session: $session,
                        currentRow: $session.currentSet,
                        currentColumn: $session.currentColumn,
                        buttonSelector: $selector
                )
            }
        }
    }

    private var scoreSection: some View {
        Section(header: HStack {
            Text("Score")
            Spacer()
            ResultSum(value: session.roundData.getSum())
        }) {
            ForEach(0..<session.roundData.endsCount, id: \.self) { i in
                HStack {
                    Text(setIter(i: i))
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                    scoreButtons(forSet: i)
                    scoreVStack(forSet: i)
                }
            }
        }
    }

    private func scoreButtons(forSet set: Int) -> some View {
        ForEach(0..<session.roundData.arrowsPerEnd, id: \.self) { column in
            Button(buttonTextResolver(score: session.getScore(set: set, column: column))) {
                if isScoreKeyboardActive == false {
                    isScoreKeyboardActive = true
                }

                selector.selectButton(row: set, column: column)
                session.setCurrentSet(x: set)
                session.setCurrentColumn(x: column)
            }
                    .buttonStyle(OutlineButton(isSelect: $selector.matrix[set][column]))
                    .frame(maxWidth: .infinity)
        }
    }

    private func scoreVStack(forSet set: Int) -> some View {
        VStack {
            // sum of set
            Text(setScoreString(x: session.roundData.getSetSum(set: set)))
                    .offset(x: -5, y: 13)
                    .frame(width: 25)
                    .font(.system(size: 13))
            Divider()
            // interim result of set
            Text(setScoreString(x: session.roundData.getSetInterimResult(set: set)))
                    .offset(x: 5, y: -7)
                    .frame(width: 25)
                    .font(.system(size: 13))
        }
    }
}

//struct SessionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            SessionDetailView(session: .constant(Session.sampleData[0]))
//        }
//    }
//}


