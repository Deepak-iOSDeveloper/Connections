//
//  UserDetailView.swift
//  Connections
//
//  Created by DEEPAK BEHERA on 11/07/25.
//
import SwiftUI
import MapKit

struct UserDetailView: View {
    let user: Users
    @State private var showHybrid = false
    @State private var is3D = false
    @State private var selectedTab = "image"
    @State private var cameraPosition: MapCameraPosition
    
    init(user: Users) {
        self.user = user
        if let coordinate = user.coordinate {
            let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let camera = MapCamera(centerCoordinate: center, distance: 500, heading: 0, pitch: 60)
            _cameraPosition = State(initialValue: .camera(camera))
        } else {
            _cameraPosition = State(initialValue: .automatic)
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                
                // Image Tab
                ImageView(user: user)
                    .tabItem {
                        Label("Image tab", systemImage: "photo.circle")
                    }
                    .tag("image")
                
                // Map Tab
                MapTabView(user: user, showHybrid: $showHybrid, is3D: $is3D, cameraPosition: $cameraPosition)
                    .tabItem {
                        Label("Map tab", systemImage: "map.circle")
                    }
                    .tag("map")
            }
        }
    }
}

