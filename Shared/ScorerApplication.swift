//
//  ScrumdingerApp.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 25/04/2022.
//

import SwiftUI

@main
struct ScorerApp: App {
    @StateObject private var store = SessionsStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SessionsView(sessions: $store.sessions) {
                    SessionsStore.save(sessions: store.sessions) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
            .onAppear {
                SessionsStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let scrums):
                        store.sessions = scrums
                    }
                }
            }
        }
    }
}
