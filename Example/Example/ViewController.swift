//
//  ViewController.swift
//  Example
//
//  Created by 김호성 on 2025.06.04.
//

import RatingView
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingView.delegate = self
        ratingView.interval = .half
    }
}

extension ViewController: RatingViewDelegate {
    func valueChanged(_ value: Float) {
        ratingLabel.text = "\(value)"
    }
}
