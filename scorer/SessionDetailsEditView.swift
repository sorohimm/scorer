//
//  SessionEditView.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 25/04/2022.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            configuration.label

            Spacer()

            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(configuration.isOn ? .purple : .gray)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .onTapGesture {
                        configuration.isOn.toggle()
                    }
        }

    }
}

func not(_ value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
            get: { !value.wrappedValue },
            set: { value.wrappedValue = !$0 }
    )
}

struct SessionDetailEditView: View {
    @Binding var data: Session.Data
    @State private var isPractice: Bool = Session.Data().isPractice
    @State private var isCompetition: Bool = Session.Data().isCompetition

    @State private var is3ArrowsPerEnd: Bool = Session.Data().is3ArrowsPerEnd
    @State private var is6ArrowsPerEnd: Bool = Session.Data().is6ArrowsPerEnd

    @State private var date = Date()

    @State private var round: Rounds = .WA

    var body: some View {
        let onPractice = Binding<Bool>(get: { data.isPractice }, set: { self.data.isPractice = $0; self.data.isCompetition = !self.data.isCompetition })
        let onCompetition = Binding<Bool>(get: { data.isCompetition }, set: { self.data.isPractice = !self.data.isPractice; self.data.isCompetition = $0 })

        let on3ArrowsPerEnd = Binding<Bool>(get: { data.is3ArrowsPerEnd }, set: { self.data.is3ArrowsPerEnd = $0; self.data.is6ArrowsPerEnd = !self.data.is6ArrowsPerEnd })
        let on6ArrowsPerEnd = Binding<Bool>(get: { data.is6ArrowsPerEnd }, set: { self.data.is3ArrowsPerEnd = !self.data.is3ArrowsPerEnd; self.data.is6ArrowsPerEnd = $0 })

        Form {
            Section(header: Text("Session Info"), content: {
                TextField("Title", text: $data.title)
                HStack {
                    DatePicker(
                            "Date",
                            selection: $data.date,
                            displayedComponents: [.date]
                    )
                            .datePickerStyle(.graphical)
                    Spacer()
                }

                Picker("Round", selection: $data.round) {
                    Text("WA international").tag("wa_international")
                }

                if data.round == "wa_international" {
                    Picker("SubRound", selection: $data.subRound) {
                        Text("WA 1440").tag("wa1440")
                        Text("WA 70m").tag("wa70")
                        Text("WA 60m").tag("wa60")
                        Text("WA 50m").tag("wa50")
                    }
                }

                HStack {
                    Toggle(isOn: onPractice, label: {
                        Text("Practice")
                    })
                            .onChange(of: isPractice) { _isOn in
                                data.isPractice.toggle()
                                data.isCompetition.toggle()
                            }
                            .padding()
                            .toggleStyle(CheckboxStyle())

                    Toggle(isOn: onCompetition, label: {
                        Text("Competition")
                    })
                            .onChange(of: isCompetition) { _isOn in
                                data.isPractice.toggle()
                                data.isCompetition.toggle()
                            }
                            .toggleStyle(CheckboxStyle())
                }

                HStack {
                    Toggle(isOn: on3ArrowsPerEnd, label: {
                        Text("3 Arrows")
                    })
                            .onChange(of: is3ArrowsPerEnd) { _isOn in
                                data.setArrowsPerSet(value: 3)
                            }
                            .padding()
                            .toggleStyle(CheckboxStyle())

                    Toggle(isOn: on6ArrowsPerEnd, label: {
                        Text("6 Arrows")
                    })
                            .onChange(of: is6ArrowsPerEnd) { _isOn in
                                data.setArrowsPerSet(value: 6)
                            }
                            .toggleStyle(CheckboxStyle())
                }

                Picker("Type", selection: $data.arrowsPerEnd) {
                    Text("3 Arrows").tag(3)
                    Text("6 Arrows").tag(6)
                }
                        .onChange(of: data.arrowsPerEnd) { _ in
                            data.fillRoundData()
                        }
                        .pickerStyle(.segmented)
            }
            )
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailEditView(data: .constant(Session.sampleData[0].data))
    }
}

