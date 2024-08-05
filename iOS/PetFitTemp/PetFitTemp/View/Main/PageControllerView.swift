//
//  PageControllerView.swift
//  petfit
//
//  Created by 서혜림 on 7/31/24.
//

import UIKit

class PageControlView: UIView {
    var numberOfPages: Int = 0 {
        didSet {
            setupPageIndicators()
        }
    }
    var currentPage: Int = 0 {
        didSet {
            updatePageIndicators()
        }
    }
    
    private var indicators: [UIView] = []
    
    private func setupPageIndicators() {
        indicators.forEach { $0.removeFromSuperview() }
        indicators.removeAll()
        
        for _ in 0..<numberOfPages {
            let indicator = UIView()
            indicator.layer.cornerRadius = 4
            indicator.backgroundColor = .gray
            indicator.translatesAutoresizingMaskIntoConstraints = false
            addSubview(indicator)
            indicators.append(indicator)
        }
        
        setNeedsLayout()
    }
    
    private func updatePageIndicators() {
        for (index, indicator) in indicators.enumerated() {
            indicator.backgroundColor = index == currentPage ? .black : .gray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let indicatorSize: CGFloat = 8
        let indicatorSpacing: CGFloat = 8
        let totalWidth: CGFloat = CGFloat(numberOfPages) * (indicatorSize + indicatorSpacing) - indicatorSpacing
        
        var xOffset: CGFloat = (bounds.width - totalWidth) / 2
        let yOffset: CGFloat = (bounds.height - indicatorSize) / 2
        
        for indicator in indicators {
            indicator.frame = CGRect(x: xOffset, y: yOffset, width: indicatorSize, height: indicatorSize)
            xOffset += indicatorSize + indicatorSpacing
        }
    }
}
