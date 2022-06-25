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
    @State private var isPractice:Bool = Session.Data().roundData.isPractice
    @State private var isCompetition:Bool = Session.Data().roundData.isCompetition
    
    @State private var is3ArrowsPerEnd:Bool = Session.Data().roundData.is3ArrowsPerEnd
    @State private var is6ArrowsPerEnd:Bool = Session.Data().roundData.is6ArrowsPerEnd
    
    @State private var date = Date()
    
    @State private var round: Rounds = .WA
    
    var body: some View {
        let onPrictice = Binding<Bool>(get: { self.data.roundData.isPractice }, set: { self.data.roundData.isPractice = $0; self.data.roundData.isCompetition = !self.data.roundData.isCompetition})
        let onCompetition = Binding<Bool>(get: { self.data.roundData.isCompetition }, set: { self.data.roundData.isPractice = !self.data.roundData.isPractice; self.data.roundData.isCompetition = $0})
        
        let on3ArrowsPerEnd = Binding<Bool>(get: { self.data.roundData.is3ArrowsPerEnd }, set: { self.data.roundData.is3ArrowsPerEnd = $0; self.data.roundData.is6ArrowsPerEnd = !self.data.roundData.is6ArrowsPerEnd})
        let on6ArrowsPerEnd = Binding<Bool>(get: { self.data.roundData.is6ArrowsPerEnd }, set: { self.data.roundData.is3ArrowsPerEnd = !self.data.roundData.is3ArrowsPerEnd; self.data.roundData.is6ArrowsPerEnd = $0})
        
        Form {
            Section(header: Text("Session Info")) {
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
                
                Picker("Round", selection: $data.roundData.round) {
                    Text("WA international").tag("wa_international")
                }
                
                if data.roundData.round == "wa_international"{
                    Picker("SubRound", selection: $data.roundData.subRound) {
                        Text("WA 1440").tag("wa1440")
                        Text("WA 70m").tag("wa70")
                        Text("WA 60m").tag("wa60")
                        Text("WA 50m").tag("wa50")
                    }
                }
                
                HStack {
                    Toggle(isOn: onPrictice, label: {
                        Text("Practice")
                    })
                    .onChange(of: isPractice) { _isOn in
                        data.roundData.isPractice.toggle()
                        data.roundData.isCompetition.toggle()
                    }
                    .padding()
                    .toggleStyle(CheckboxStyle())
                    
                    Toggle(isOn: onCompetition, label: {
                        Text("Competition")
                    })
                    .onChange(of: isCompetition) { _isOn in
                        data.roundData.isPractice.toggle()
                        data.roundData.isCompetition.toggle()
                    }
                    .toggleStyle(CheckboxStyle())
                }
                
                HStack {
                    Toggle(isOn: on3ArrowsPerEnd, label: {
                        Text("3 Appows")
                    })
                    .onChange(of: is3ArrowsPerEnd) { _isOn in
                        data.roundData.setArrowsPerEnd(value: 3)
                    }
                    .padding()
                    .toggleStyle(CheckboxStyle())

                    Toggle(isOn: on6ArrowsPerEnd, label: {
                        Text("6 Arrows")
                    })
                    .onChange(of: is6ArrowsPerEnd) { _isOn in
                        data.roundData.setArrowsPerEnd(value: 6)
                    }
                    .toggleStyle(CheckboxStyle())
                }
                
                Picker("Type", selection: $data.roundData.arrowsPerEnd) {
                    Text("3 Arrows").tag(3)
                    Text("6 Arrows").tag(6)
                }
                .onChange(of: data.roundData.arrowsPerEnd) { _ in
                    data.roundData.fill()
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailEditView(data: .constant(Session.sampleData[0].data))
    }
}
