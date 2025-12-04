//
//  ViewController.swift
//  Example
//
//  Created by 김호성 on 2025.06.04.
//

import RatingView
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ratingLabel1: UILabel!
    @IBOutlet weak var ratingView1: RatingView!
    
    @IBOutlet weak var ratingLabel2: UILabel!
    @IBOutlet weak var ratingView2: RatingView!
    
    @IBOutlet weak var ratingLabel3: UILabel!
    @IBOutlet weak var ratingView3: RatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingView1.delegate = self
        ratingView1.interval = .half
        
        ratingView2.delegate = self
        ratingView2.interval = .one
        
        ratingView3.delegate = self
    }
}

extension ViewController: RatingViewDelegate {
    func valueChanged(_ ratingView: RatingView, value: Float) {
        if ratingView === ratingView1 {
            ratingLabel1.text = "\(value)"
        } else if ratingView === ratingView2 {
            ratingLabel2.text = "\(value)"
        } else if ratingView === ratingView3 {
            ratingLabel3.text = "\(value)"
        }
    }
}
