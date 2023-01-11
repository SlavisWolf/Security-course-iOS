//
//  FileUpload.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 12/10/22.
//


struct FileUpload: Codable {
    var name: String
    var image: String
}

struct ResponseUpload: Codable {
    var message: String
    var time: Double
}
