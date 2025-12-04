//
//  RatingItemView.swift
//  RatingView
//
//  Created by 김호성 on 2025.03.31.
//

import UIKit

class RatingItemView: UIView {
    
    let imageView: UIImageView = UIImageView()
    
    var accentColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    var baseColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var fill: Float? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    init(image: UIImage) {
        super.init(frame: .zero)
        
        initializeView(image: image)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initializeView()
    }
    
    private func initializeView(image: UIImage? = nil) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mask = imageView
    }
    
    override func draw(_ rect: CGRect) {
        guard let accentColor = accentColor, let baseColor = baseColor, let fill = fill else { return }
        let width = rect.width
        let height = rect.height
        
        let backgroundRect = CGRect(x: 0, y: 0, width: width, height: height)
        let backgroundPath = UIBezierPath(rect: backgroundRect)
        baseColor.setFill()
        backgroundPath.fill()
        
        let fillRect = CGRect(x: 0, y: 0, width: CGFloat(fill)*width, height: height)
        let fillPath = UIBezierPath(rect: fillRect)
        accentColor.setFill()
        fillPath.fill()
    }
}
