//
//  ReceiptViewController.swift
//  splitz
//
//  Created by Nolan Lapham on 1/16/17.
//  Copyright © 2017 Nolan Lapham. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {

	let receiptText: String
	
	@IBOutlet weak var textView: UITextView!
	
	// MARK: ViewController Lifecycle
	
	init(withText text: String) {
		receiptText = text
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		textView.text = receiptText
	}
}
