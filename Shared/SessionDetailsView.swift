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
                Text(/*TODO: add loaction*/ "")
            }
            HStack {
                Label("Round", systemImage: "target")
                Spacer()
                Text(session.roundData.subRound)
            }
            .accessibilityElement(children: .combine)
        }
        .padding()
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct InterimResult: View {
    @Binding var value: Int
    var body: some View {
        ZStack {
            Text(String(value))
        }
        .frame(width: UIScreen.main.bounds.width / 5 , height: UIScreen.main.bounds.height / 19)
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
            .overlay(   isSelect ?
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

func setScore(x: Int) -> String {
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

struct SessionDetailView: View {
    @Binding var session: Session
    @State private var data = Session.Data()
    
    @State private var isPresentingEditView: Bool = false
    @State private var isScoreKeyboardActive: Bool = false
    
    var body: some View {
        ZStack {
            List {
                InfoList(session: self.$session)
                
                Section(header: HStack{
                    Text("Score")
                    Spacer()
                    InterimResult(value: $session.roundData.interimResult)
                }) {
                    ForEach(0..<self.session.roundData.endsCount, id: \.self) {i in
                        HStack {
                            Text(setIter(i: i))
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                            ForEach(0..<self.session.roundData.arrowsPerEnd, id: \.self) {j in
                                Button(self.session.roundData.scoresTable[i].row[j]) {
                                    if !isScoreKeyboardActive {
                                        isScoreKeyboardActive = true
                                    }
                                    if i < session.roundData.lastInputScoreCell_i || (i == session.roundData.lastInputScoreCell_i && j <= session.roundData.lastInputScoreCell_j ) {
                                        session.borderToggle(i: session.roundData.current_i, j: session.roundData.current_j)
                                        session.borderToggle(i: i, j: j)
                                        session.setCurrentI(x: i)
                                        session.setCurrentJ(x: j)
                                    }
                                }
                                .buttonStyle(OutlineButton(isSelect: self.$session.roundData.borderTable[i][j]))
                            }
                            Spacer()
                                .frame(width: 10)
                            VStack {
                                Text(setScore(x: self.session.roundData.scoresTable[i].sum))
                                    .offset(x: -5, y: 13)
                                    .frame(width: 25)
                                    .font(.system(size: 13))
                                Divider()
                                    .rotationEffect(.degrees(-30))
                                Text(setScore(x: self.session.roundData.scoresTable[i].interimResult))
                                    .offset(x: 5, y: -7)
                                    .frame(width: 25)
                                    .font(.system(size: 13))
                            }
                        }
                    }
                }
                Spacer()
                    .frame(height: 90)
            }
            .navigationTitle(session.title)
            .toolbar {
                Button("Edit") {
                    isPresentingEditView = true
                    data = session.data
                }
            }
            .sheet(isPresented: $isPresentingEditView) {
                NavigationView {
                    SessionDetailEditView(data: $data)
                        .navigationTitle(session.title)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isPresentingEditView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    isPresentingEditView = false
                                    session.update(from: data)
                                }
                            }
                        }
                }
            }
            
            if isScoreKeyboardActive {
                WAFullSizeKeyboardView(isActive: $isScoreKeyboardActive, session: $session, data: $data, IcurrentScoreCell: $session.roundData.current_i, JcurrentScoreCell: $session.roundData.current_j)
                    .offset(y: 300)
            }
        }
    }
}

struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SessionDetailView(session: .constant(Session.sampleData[0]))
        }
    }
}

