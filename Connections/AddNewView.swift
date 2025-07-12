//
//  AddNewView.swift
//  Connections
//
//  Created by DEEPAK BEHERA on 11/07/25.
//
import SwiftUI
import PhotosUI

struct AddNewView: View {
    @State private var pickerImage: PhotosPickerItem?
    @State private var image: Image?
    @State private var imageData: Data?
    @State private var selected = false
    @State private var name: String = ""
    @State private var nameSaved = false
    @Binding var users: [Users]
    @Environment(\.dismiss) var dismiss
    let location: LocationFetcher
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $pickerImage) {
                    if let image {
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    } else {
                        ContentUnavailableView("No selfie selected", systemImage: "camera.viewfinder", description: Text("Tap to add new image"))
                    }
                }
            }
            .navigationTitle("Add New Connection")
            .onChange(of: pickerImage) { getImage() }
            .onChange(of: image) { selected = true }
            .alert("Add name", isPresented: $selected) {
                TextField("Add name of the connection", text: $name)
                Button("OK") {
                    nameSaved = true
                }
            }
            .confirmationDialog("Location access", isPresented: $nameSaved) {
                Button("Add location") {
                    saveDataWithLocationRetry()
                }
            }
        }
    }

    func getImage() {
        Task {
            guard let data = try await pickerImage?.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else { return }
            imageData = data
            image = Image(uiImage: uiImage)
        }
    }
    
    func saveDataWithLocationRetry(retries: Int = 5) {
        if let location = location.lastKnownLocation {
            let coordinates = Coordinates(longitude: location.longitude, latitude: location.latitude)
            let newUser = Users(name: name, coordinate: coordinates, imageData: imageData)
            users.append(newUser)
            saveToDisk()
            dismiss()
        } else if retries > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                saveDataWithLocationRetry(retries: retries - 1)
            }
        } else {
            let newUser = Users(name: name, coordinate: nil, imageData: imageData)
            users.append(newUser)
            saveToDisk()
            dismiss()
        }
    }

    func saveToDisk() {
        let savedURL = URL.documentsDirectory.appendingPathComponent("users.json")
        do {
            let encodedData = try JSONEncoder().encode(users)
            try encodedData.write(to: savedURL)
        } catch {
            print("Failed to save users: \(error.localizedDescription)")
        }
    }



}
