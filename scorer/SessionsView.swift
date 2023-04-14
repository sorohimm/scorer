//
//  DetailView.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 25/04/2022.
//

import SwiftUI

struct SessionsView: View {
    @Binding var sessions: [Session]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewSessionView = false
    @State private var newSessionData = Session.Data()
    let saveAction: ()->Void

    var body: some View {
        List {
            ForEach($sessions) { $session in
                NavigationLink(destination: SessionDetailView(session: $session)) {
                    CardView(session: session)
                }
            }
                    .onDelete { indices in
                        sessions.remove(atOffsets: indices)
                    }
        }
                .navigationTitle("Sessions")
                .toolbar {
                    Button(action: {
                        isPresentingNewSessionView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $isPresentingNewSessionView) {
                    NavigationView {
                        SessionDetailEditView(data: $newSessionData)
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Dismiss") {
                                            isPresentingNewSessionView = false
                                            newSessionData = Session.Data()
                                        }
                                    }
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("Add") {
                                            let newSession = Session(data: newSessionData)
                                            sessions.append(newSession)
                                            isPresentingNewSessionView = false
                                            newSessionData = Session.Data()
                                        }
                                    }
                                }
                    }
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive { saveAction() }
                }
    }
}

struct SessionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SessionsView(sessions: .constant(Session.sampleData), saveAction: {})
        }
    }
}
