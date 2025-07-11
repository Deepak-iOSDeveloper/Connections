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

    @Binding var users: [Users]
    @Environment(\.dismiss) var dismiss

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
                    saveData()
                    dismiss()
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
    
    func saveData() {
        let savedURL = URL.documentsDirectory.appendingPathComponent("users.json")

        let newUser = Users(name: name, imageData: imageData)
        users.append(newUser)

        do {
            let encodedData = try JSONEncoder().encode(users)
            try encodedData.write(to: savedURL)
            print("Users saved to disk.")
        } catch {
            print("Failed to save users: \(error.localizedDescription)")
        }
    }

}
