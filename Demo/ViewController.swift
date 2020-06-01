//
//  ViewController.swift
//  Demo
//
//  Created by Elsayed Hussein on 6/1/20.
//  Copyright © 2020 Elsayed Hussein. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Variables
    
    //MARK: - Outlets
    @IBOutlet weak var textView: UITextView!
    
    
    //MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapTextViewGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTapped))
        textView.addGestureRecognizer(tapTextViewGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(recognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Actions
    
    //MARK: - Methods
    @objc func textViewDidTapped(recognizer: UITapGestureRecognizer) {
        guard let myTextView = recognizer.view as? UITextView else {
            return
        }
        let layoutManager = myTextView.layoutManager
        var location = recognizer.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left
        location.y -= myTextView.textContainerInset.top

        let glyphIndex: Int = myTextView.layoutManager.glyphIndex(for: location, in: myTextView.textContainer, fractionOfDistanceThroughGlyph: nil)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: myTextView.textContainer)
        
        if glyphRect.contains(location) {
            let characterIndex: Int = layoutManager.characterIndexForGlyph(at: glyphIndex)
            let attributeName = NSAttributedString.Key.link
            let attributeValue = myTextView.textStorage.attribute(attributeName, at: characterIndex, effectiveRange: nil)
            if let urlString = attributeValue as? String, let url = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("There is a problem in your link.")
                }
            } else {
                textView.isEditable = true
                textView.becomeFirstResponder()
            }
        }
    }
    @objc func viewDidTapped(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.resignFirstResponder()
    }
}
