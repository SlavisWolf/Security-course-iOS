//
//  ImagePickerViewController.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 10/11/22.
//

import UIKit
import PhotosUI
import ContactsUI

class ImagePickerViewController: UIViewController, PHPickerViewControllerDelegate, CNContactPickerDelegate {
    
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var contactCard: UIView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var contactMail: UILabel!
    @IBOutlet weak var contactAddress: UILabel!
    
    
    @IBOutlet weak var photoView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: Actions
    @IBAction func pickPhoto() {
        
        var configuration = PHPickerConfiguration(photoLibrary: .shared() )
        let newFilter = PHPickerFilter.any(of: [.images])
        // Set the filter type according to the user’s selection.
        configuration.filter = newFilter
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .automatic
        // Set the selection behavior to respect the user’s selection order.
        configuration.selection = .ordered
        // Set the selection limit to 0 to enable multiselection.
        configuration.selectionLimit = 1
        // Set the preselected asset identifiers with the identifiers that the app tracks.
        configuration.preselectedAssetIdentifiers = []
        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        present(photoPicker, animated: true)
    }
    
    @IBAction func pickContact() {
        let contactController = CNContactPickerViewController()
        contactController.delegate = self
        present(contactController, animated: true)
    }
    
    
    @IBAction func cardClicked(_ sender: UITapGestureRecognizer) {
        
        guard let contactName = contactName.text else { return }
        
        let provider = contactName as NSItemProviderWriting
    
        // if local only is in true we block that the pasteboard will be sharing through hangoff feature in other devices
        UIPasteboard.general.setObjects([provider], localOnly: true, expirationDate: Date().addingTimeInterval(40) )
    }
    
    
    //MARK: PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        guard results.count == 1, let result = results.first else {
            photoView.image = nil
            return
        }
        
        if let identifier = result.assetIdentifier {
            securePrint("Asset identifier: \(identifier)")
        }
        
        let itemProvider = result.itemProvider
        
        guard itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) else { return }
        itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in

            guard let data,
                  let cgImageSource = CGImageSourceCreateWithData(data as CFData, nil),
                  let properties = CGImageSourceCopyPropertiesAtIndex(cgImageSource, 0, nil),
                  let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil)
            else {
                DispatchQueue.main.async {
                    self.photoView.image = nil
                }
                if let error {
                    securePrint("Error getting the image data: \(error.localizedDescription)")
                }

                return
            }
            securePrint(properties)
            let imageToShow = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
            DispatchQueue.main.async {
                self.photoView.image = imageToShow
            }
        }
    }
    
    //MARK: CNContactPickerDelegate
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        securePrint(contact)
        
        // Name
        let name = "\(contact.givenName) \(contact.familyName)"
        
        // Write 'CNLabel' to see all constants related with the label property of the CNLabeledValue objects you can use this to filter what kind of email,addres etc... you want
        
        let mail = contact.emailAddresses.first?.value as? String
        
        var address: String?
        
        if let addressObject = contact.postalAddresses.first?.value {
            address = "\(addressObject.street) \(addressObject.city) \(addressObject.state) \(addressObject.postalCode) \(addressObject.country)"
        }
        
        let phone  = contact.phoneNumbers.first?.value.stringValue
        
        contactName.text = name
        contactMail.text = mail
        contactAddress.text = address
        contactPhone.text = phone
        
        
        contactMail.isHidden = mail?.isEmpty ?? true
        contactPhone.isHidden = phone?.isEmpty ?? true
        contactAddress.isHidden = address?.isEmpty ?? true
        
        contactCard.isHidden = false
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        contactCard.isHidden = true
        contactMail.isHidden = true
        contactPhone.isHidden = true
        contactAddress.isHidden = true
    }
}
