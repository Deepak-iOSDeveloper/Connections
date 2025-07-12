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
    @State private var showLocation = false
    @State private var showHybrid = false
    @State private var is3D = false

    @State private var cameraPosition: MapCameraPosition
    init(user: Users) {
        self.user = user
        if let coordinate = user.coordinate {
            let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let distance: CLLocationDistance = 500 // meters
            let pitch: CLLocationDirection = 60    // for 3D
            let heading: CLLocationDirection = 0

            let camera = MapCamera(centerCoordinate: center, distance: distance, heading: heading, pitch: pitch)
            _cameraPosition = State(initialValue: .camera(camera))
        } else {
            _cameraPosition = State(initialValue: .automatic)
        }
    }

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
            Toggle("Show meet point on map", isOn: $showLocation)
            Text(user.name)
                .font(.title)
                .bold()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Connection Detail")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showLocation) {
            VStack(spacing: 16) {
                HStack {
                    Button(showHybrid ? "Standard" : "Hybrid") {
                        showHybrid.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    Button(is3D ? "2D View" : "3D View") {
                        toggleCamera2Dor3D()
                    }
                    .buttonStyle(.borderedProminent)
                }

                Map(position: $cameraPosition, interactionModes: .all) {
                    if let coordinate = user.coordinate {
                        Annotation(user.name, coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundStyle(.red)
                                Text(user.name)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                .mapStyle(showHybrid ? .hybrid : .standard)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
        }
    }
    func toggleCamera2Dor3D() {
        guard let coordinate = user.coordinate else { return }

        let pitch: CLLocationDirection = is3D ? 0 : 60
        is3D.toggle()

        let camera = MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
            distance: 500,
            heading: 0,
            pitch: pitch
        )

        cameraPosition = .camera(camera)
    }

}
