//
//  MobileRuler.swift
//  BazaartProject
//
//  Created by Ethan on 07/06/2021.
//

//---Ethan-------------

import Foundation

enum Orientation {
    case horizontal
    case vertical
}


class MobileBarView: UIView {
  
    fileprivate var stackView: UIStackView!
    fileprivate let buttonSize: CGFloat = 40.0
    var fileOriginPoint: CGPoint!
    var ports = [Port]()
    var orientation = Orientation.vertical


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setOrientation(_ newOrientation: Orientation) {
        switch orientation {
        case .horizontal:
            if newOrientation == .vertical {
                rotate(angle: 90.0)
            }
        case .vertical:
            if newOrientation == .horizontal {
                rotate(angle: 270.0)
            }
        }
        self.orientation = newOrientation
    }
    
    fileprivate func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let affineTransformation = self.transform.rotated(by: radians)
        self.transform = affineTransformation
        
        stackView.arrangedSubviews.forEach({ subView in
            let rads = (360.0 - angle) / 180.0 * CGFloat.pi
            let transformation = subView.transform.rotated(by: rads)
            subView.transform = transformation
        })
    }

    fileprivate func setup() {
        backgroundColor = .white
        self.layer.cornerRadius = 12.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10

        stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.addArrangedSubview(buildButton("plus",   selector: #selector(onAddTouchUpInside)))
        stackView.addArrangedSubview(buildButton("camera", selector: #selector(onSaveTouchUpInside)))
        stackView.addArrangedSubview(buildButton("trash",  selector: #selector(onDeleteTouchUpInside)))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    fileprivate func buildButton(_ systemIcon: String, selector: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.setImage(UIImage(systemName: systemIcon), for: .normal)
        //button.addTarget(self, action: #selector(onAddTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    @objc func onAddTouchUpInside() {
        NotificationCenter.default.post(name: Notification.Name("UserRequestAddLayer"), object: nil)
    }
    @objc func onDeleteTouchUpInside() {
        NotificationCenter.default.post(name: Notification.Name("UserRequestDeleteLayer"), object: nil)
    }
    @objc func onSaveTouchUpInside() {
        NotificationCenter.default.post(name: Notification.Name("UserRequestSaveLayer"), object: nil)
    }

}
//---------------------
