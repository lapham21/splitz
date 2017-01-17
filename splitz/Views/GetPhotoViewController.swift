//
//  GetPhotoViewController.swift
//  splitz
//
//  Created by Nolan Lapham on 1/16/17.
//  Copyright © 2017 Nolan Lapham. All rights reserved.
//

import UIKit

class GetPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	// MARK: Model
	
	var receiptText: String?
	var activityIndicator: UIActivityIndicatorView?
	
	// MARK: Outlets and Actions
	
	@IBAction func takePhotoButtonPressed(_ sender: UIButton) {
		takePhoto()
	}
	@IBAction func selectPhotoButtonPressed(_ sender: UIButton) {
		selectPhoto()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	// Utility Functions
	
	private func takePhoto() {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = .camera
		self.present(imagePicker, animated: true, completion: nil)
	}
	
	private func selectPhoto() {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = .photoLibrary
		self.present(imagePicker, animated: true, completion: nil)
	}
	
	// MARK: Image Recognition
	
	func performImageRecognition(_ image: UIImage) {

		let tesseract = G8Tesseract()
		tesseract.language = "eng"
		tesseract.engineMode = .tesseractCubeCombined
		tesseract.pageSegmentationMode = .auto
		tesseract.maximumRecognitionTime = 60.0
		tesseract.image = image.g8_blackAndWhite()
		tesseract.recognize()

		// TODO: Throw an error if the text isnt recognized
		guard let receiptText = tesseract.recognizedText else { return }

		removeActivityIndicator()
		
		self.present(ReceiptViewController(withText: receiptText), animated: true, completion: nil)
	}
	
	func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
		var scaledSize = CGSize(width: maxDimension, height: maxDimension)
		var scaleFactor: CGFloat
		
		if image.size.width > image.size.height {
			scaleFactor = image.size.height / image.size.width
			scaledSize.width = maxDimension
			scaledSize.height = scaledSize.width * scaleFactor
		} else {
			scaleFactor = image.size.width / image.size.height
			scaledSize.height = maxDimension
			scaledSize.width = scaledSize.height * scaleFactor
		}
		
		UIGraphicsBeginImageContext(scaledSize)
		image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		guard let returnImage = scaledImage else { return image }
		
		return returnImage
	}
	
	// MARK: Activity Indicator methods
	
	private func addActivityIndicator() {
		activityIndicator = UIActivityIndicatorView(frame: view.bounds)
		
		guard let activityIndicator = activityIndicator else { return }
		activityIndicator.activityIndicatorViewStyle = .whiteLarge
		activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
		activityIndicator.startAnimating()
		view.addSubview(activityIndicator)
	}
	
	private func removeActivityIndicator() {
		activityIndicator?.removeFromSuperview()
		activityIndicator = nil
	}
	
	// MARK: UIImagePickerDelegate

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
		let scaledImage = scaleImage(image: selectedPhoto, maxDimension: 640)
		
		addActivityIndicator()
		
		dismiss(animated: true) {
			self.performImageRecognition(scaledImage)
		}
	}
}
