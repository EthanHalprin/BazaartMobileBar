//
//  MobileRuler.swift
//  BazaartProject
//
//  Created by Ethan on 07/06/2021.
//

//---Ethan-------------

import Foundation

class MobileBarView: UIView {
  
    fileprivate var stackView: UIStackView!
    fileprivate let buttonSize: CGFloat = 40.0
    var fileOriginPoint: CGPoint!
    var ports = [Port]()
    var isLogged = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

extension MobileBarView {
      
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
        stackView.addArrangedSubview(buildButton("plus"))
        stackView.addArrangedSubview(buildButton("camera"))
        stackView.addArrangedSubview(buildButton("trash"))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    fileprivate func buildButton(_ systemIcon: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.setImage(UIImage(systemName: systemIcon), for: .normal)
        return button
    }

}
//---------------------
