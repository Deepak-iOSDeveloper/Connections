//
//  ContentView.swift
//  Connections
//
//  Created by DEEPAK BEHERA on 11/07/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var image: Image?
    @State private var users = [Users]()
    @State private var addNewSelected = false
    var body: some View {
        NavigationStack {
            VStack {
                if users.isEmpty {
                    Button {
                        addNewSelected = true
                    }label: {
                        ContentUnavailableView("You have no connection yet", systemImage: "person.line.dotted.person", description: Text("Tap to add one"))
                    }
                }
                List(users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        HStack {
                            user.image?
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            Text(user.name)
                        }
                    }
                }
                
            }
            .navigationTitle("My Connections")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        addNewSelected = true
                    }
                }
            }
            .sheet(isPresented: $addNewSelected) {
                AddNewView(users: $users)
            }
            .onAppear(perform: loadData)
        }
    }
    func loadData() {
        let savedURL = URL.documentsDirectory.appendingPathComponent("users.json")
        do {
            let data = try Data(contentsOf: savedURL)
            users = try JSONDecoder().decode([Users].self, from: data)
            print("loaded data successfully")
        }catch {
            print("data load unsuccessful")
        }
    }
}


#Preview {
    ContentView()
}
