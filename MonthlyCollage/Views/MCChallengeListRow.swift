//
//  MCChallengeListRow.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/09.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCChallengeListRow: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(challenge.name)
                .font(.title)
            
            HStack(content: {
                Text(challenge.id.uuidString)
                    .font(.caption)
                
                Spacer()

                Text(DateFormatter.longStyle.string(from: challenge.date))
                    .font(.caption)
            })
        })
    }
}

struct MCChallengeListRow_Previews: PreviewProvider {
    static var previews: some View {
        MCChallengeListRow(challenge: Challenge.preview())
            .previewLayout(.fixed(width: 375, height: 70))
    }
}
