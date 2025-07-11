//
//  UserDetailView.swift
//  Connections
//
//  Created by DEEPAK BEHERA on 11/07/25.
//
import SwiftUI

struct UserDetailView: View {
    let user: Users

    var body: some View {
        VStack(spacing: 20) {
            if let image = user.image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(lineWidth: 3).foregroundStyle(.white).opacity(0.5)
                    }
                    .frame(width: 350, height: 450)
            } else {
                Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .foregroundColor(.gray)
            }

            Text(user.name)
                .font(.title)
                .bold()

            Spacer()
        }
        .padding()
        .navigationTitle("Connection Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
