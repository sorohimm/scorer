//
//  CardView.swift
//  scorer (iOS)
//
//  Created by Nimm Zso on 25/04/2022.
//

import SwiftUI

struct CardView: View {

    let session: Session
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        return df
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(session.title)
                .accessibilityAddTraits(.isHeader)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(dateFormatter.string(from: session.date))", systemImage: "calendar")
                Spacer()
                Label("\(session.roundData.interimResult)", systemImage: "scope")
            }
            .font(.caption)
        }
        .padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var session = Session.sampleData[0]
    static var previews: some View {
        CardView(session: session)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
