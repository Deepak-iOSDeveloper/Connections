//
//  Users.swift
//  Connections
//
//  Created by DEEPAK BEHERA on 11/07/25.
//
import SwiftUI
import CoreLocation

struct Users: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var coordinate: Coordinates?
    var imageData: Data?

    var image: Image? {
        guard let imageData, let uiImage = UIImage(data: imageData) else { return nil }
        return Image(uiImage: uiImage)
    }

    // Example instance
    static var example: Users {
        let sampleUIImage = UIImage(systemName: "swift")!
        let imageData = sampleUIImage.pngData()
        return Users(name: "xyz", imageData: imageData)
    }
}

struct Coordinates: Codable {
    var longitude: Double
    var latitude: Double
}
