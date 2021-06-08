//
//  CanvasLayer.swift
//  BazaartProject
//
//  Created by Yedidya Reiss on 19/05/2021.
//

import UIKit

@objc class CanvasLayer: UIView {

    private static var currentImageIndex = 0
        
    @objc static func layer() -> CanvasLayer {
        return CanvasLayer()
    }
    
    @objc init() {
        let img = Self.nextImage()
        let screenWidth = UIScreen.main.bounds.width;
        let fr = CGRect(origin: .zero, size: CGSize(width: screenWidth/3, height: screenWidth/3))
        
        super.init(frame: fr)
        
        let imgV = UIImageView(frame: fr)
        imgV.image = img
        addSubview(imgV)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(gestureDidPan(_:)))
        addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func nextImage() -> UIImage {
        let IMG_COUNT = 5
        let img = UIImage(named: "\(currentImageIndex % IMG_COUNT)")!
        currentImageIndex += 1
        return img
    }
    
    @objc private func gestureDidPan(_ gesture:UIPanGestureRecognizer) {
        let location = gesture.location(in: superview)
        setLocation(point: location)
    }
    
    @objc func setLocation(point:CGPoint) {
        center = point
    }


}
