//
//  RatingView.swift
//  RatingView
//
//  Created by 김호성 on 2025.06.04.
//

import Foundation
import UIKit

@IBDesignable public class RatingView: UIView {
    
    public weak var delegate: RatingViewDelegate?
    
    private let stackView: UIStackView = UIStackView()
    private var ratingItemViews: [RatingItemView] = []
    
    private var hapticGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    public enum Interval: Int {
        case one = 1
        case half = 2
    }
    public var interval: Interval = .half
    
    @IBInspectable public var maximumRating: Int = 5 {
        didSet {
            updateView()
        }
    }
    @IBInspectable public var rating: Float = 0 {
        didSet {
            didSetRating()
        }
    }
    private func didSetRating() {
        ratingItemViews.enumerated().forEach({ index, ratingItemView in
            ratingItemView.fill = max(0, min(rating-Float(index), 1))
        })
        delegate?.valueChanged(rating)
    }
    
    @IBInspectable public var isAnimationEnabled: Bool = true
    @IBInspectable public var isHapticEnabled: Bool = true
    
    @IBInspectable public var symbolImage: UIImage = UIImage(systemName: "star.fill")!
    
    @IBInspectable public var accentColor: UIColor? {
        didSet {
            didSetAccentColor()
        }
    }
    private func didSetAccentColor() {
        ratingItemViews.forEach({ ratingItemView in
            ratingItemView.accentColor = accentColor
        })
    }
    
    @IBInspectable public var baseColor: UIColor? {
        didSet {
            didSetBaseColor()
        }
    }
    private func didSetBaseColor() {
        ratingItemViews.forEach({ ratingItemView in
            ratingItemView.baseColor = baseColor
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        updateView()
        configureStackView()
        configureGestureRecognizer()
    }
    
    
    private func updateView() {
        ratingItemViews = (0..<maximumRating).map({ _ in RatingItemView(image: symbolImage) })
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        ratingItemViews.forEach({ ratingItemView in
            stackView.addArrangedSubview(ratingItemView)
        })
        didSetBaseColor()
        didSetAccentColor()
        didSetRating()
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func animate(rating: Float) {
        guard isAnimationEnabled else { return }
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            ratingItemViews.forEach({ ratingItemView in
                ratingItemView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            if 0 < rating && rating <= Float(maximumRating) {
                ratingItemViews[Int(ceil(rating))-1].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
        })
    }
    
    private func generateHaptic() {
        if isHapticEnabled {
            hapticGenerator.impactOccurred()
        }
    }
    
    // MARK: - Gesture
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        gestureHandler(recognizer: recognizer)
    }
    
    @objc private func tapGestureHandler(recognizer: UITapGestureRecognizer) {
        gestureHandler(recognizer: recognizer)
    }
    
    private func configureGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapGestureHandler(recognizer: )))
        tapGestureRecognizer.minimumPressDuration = 0
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func gestureHandler(recognizer: UIGestureRecognizer) {
        let discretizedRating: Float = Float(Int(recognizer.location(in: self).x / self.bounds.width * CGFloat(maximumRating) * CGFloat(interval.rawValue))+1) / Float(interval.rawValue)
        let validRangeRating: Float = max(0, min(discretizedRating, Float(maximumRating)))
        switch recognizer.state {
        case .began:
            generateHaptic()
            animate(rating: discretizedRating)
            delegate?.touchDown(validRangeRating)
        case .changed:
            guard validRangeRating != rating else { return }
            generateHaptic()
            animate(rating: discretizedRating)
        case .ended:
            delegate?.touchUp(validRangeRating)
            animate(rating: 0)
        default:
            break
        }
        rating = validRangeRating
    }
}

extension RatingView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizers?.contains(otherGestureRecognizer) ?? false
    }
}

public protocol RatingViewDelegate: AnyObject {
    func valueChanged(_ value: Float)
    func touchDown(_ value: Float)
    func touchUp(_ value: Float)
}

extension RatingViewDelegate {
    public func valueChanged(_ value: Float) {
        print("value changed: \(value)")
    }
    
    public func touchDown(_ value: Float) {
        print("touch down: \(value)")
    }
    
    public func touchUp(_ value: Float) {
        print("touch up: \(value)")
    }
}
