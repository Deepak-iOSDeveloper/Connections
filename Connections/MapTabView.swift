//
//  MapTabView.swift
//  Connections
//
//  Created by DEEPAK BEHERA on 13/07/25.
//
import SwiftUI
import MapKit

struct MapTabView: View {
    let user: Users
    @Binding var showHybrid: Bool
    @Binding var is3D: Bool
    @Binding var cameraPosition: MapCameraPosition

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack {
                if let coordinate = user.coordinate {
                    // Buttons above map
                    Spacer()
                    HStack(spacing: 20) {
                        Button(showHybrid ? "Standard" : "Hybrid") {
                            showHybrid.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(is3D ? "2D View" : "3D View") {
                            toggleCamera2Dor3D()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.bottom, 10)
                    
                    // Map in circular view
                    Map(position: $cameraPosition, interactionModes: .all) {
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
                    .mapStyle(showHybrid ? .hybrid : .standard)
                    .frame(width: 350, height: 450)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(lineWidth: 3)
                            .foregroundStyle(.white)
                            .opacity(0.5)
                    }
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
        }
    }

    private func toggleCamera2Dor3D() {
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
