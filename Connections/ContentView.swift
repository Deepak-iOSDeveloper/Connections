//
//  ContentView.swift
//  Connections
//
//  Created by DEEPAK BEHERA on 11/07/25.
//

import SwiftUI
import PhotosUI
import CoreLocation

struct ContentView: View {
    @State private var image: Image?
    @State private var users = [Users]()
    @State private var addNewSelected = false
    let location = LocationFetcher()
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
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $addNewSelected, onDismiss: loadData) {
                AddNewView(users: $users, location: location)
            }
            .onAppear(perform: loadData)
            .onAppear {
                location.start()
            }
        }
    }
    func loadData() {
        let savedURL = URL.documentsDirectory.appendingPathComponent("users.json")
        do {
            let data = try Data(contentsOf: savedURL)
            users = try JSONDecoder().decode([Users].self, from: data)
        } catch {
            print("Failed to load users: \(error.localizedDescription)")
        }
    }


}
class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        lastKnownLocation = location.first?.coordinate
    }
}
#Preview {
    ContentView()
}
