import UIKit



let dog = "Hello, I'm a dog"

guard var dataDog = dog.data(using: .utf8) else { fatalError() }


dataDog.withUnsafeBytes { dataBuffer in
    
    if let pointer = dataBuffer.bindMemory(to: UInt8.self).baseAddress {
        
        //Memory Address
        print(pointer)
        //Values saved in memory
        print(pointer.pointee)
        
        print("Array of bytes:")
        for byte in dataBuffer {
            print(byte)
        }
    }
}


//Another way but I don't know why the array values are different
//withUnsafeBytes(of: &dataDog) { dataBuffer in
//
//    print("Array of bytes:")
//
//    for byte in dataBuffer {
//        print(byte)
//    }
//}

//Swift5 Style xD very hard
var bytesArray: [UInt8] = Array(dataDog)

print("Array swift 5")
print(bytesArray)

//We can change the bytes to modify the data
bytesArray[4] = 47 // Change 111 to 47

//Convert the arrat to a new Data
let newData = Data(bytesArray)
//Create the string
guard let newString = String(data: newData, encoding: .utf8) else { fatalError() }

print(newString)

