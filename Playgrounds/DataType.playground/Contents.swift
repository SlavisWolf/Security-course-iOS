import UIKit

var greeting = "Hello, playground"


// Cast string to type Data
let text = "Hello Kitty!"
print("original text: \(text)")

// UTF8 is a standard
guard let kittyData = text.data(using: .utf8) else { fatalError() }

//Cast again to string
guard let kitty = String(data: kittyData, encoding: .utf8) else { fatalError() }
print("reconverted text: \(kitty)")

// Base 64

let kitty64 = kittyData.base64EncodedData(options: .lineLength64Characters)
let kitty64String = kittyData.base64EncodedString(options: .lineLength64Characters)
print("Base 64 string: \(kitty64String)")
//Decode base64
//Create a new Data Object decoded with a encoded base64 data
let kittyDecoded = Data(base64Encoded: kitty64)
//Same with a base64 String
let kittyDecodedWithString = Data(base64Encoded: kitty64String, options: .ignoreUnknownCharacters) // Good practice to use ignoreUnknownCharacters to avoid the inyection of strange characters
