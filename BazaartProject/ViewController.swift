//
//  ViewController.swift
//  BazaartProject
//
//  Created by Yedidya Reiss on 19/05/2021.
//

import UIKit

class ViewController: UIViewController {

    private var canvasView: CanvasView!
    
    //---Ethan-------------
    var mobileBarView: MobileBarView!
    var mbvOriginPoint: CGPoint!
    var ports = [Port]()
    var portSize: CGFloat!
    //---------------------

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let width = view.bounds.width - 40
        let height = width * 4 / 3
        let size = CGSize(width: width, height: height)
        let canvas = CanvasView(frame: CGRect(origin: .zero, size: size))
        canvas.center = view.center
        view.addSubview(canvas)
        
        self.canvasView = canvas
        
        let margin: CGFloat = 40
        let buttons = [addButton(),deleteButton(),saveButton()]
        _ = buttons.reduce(CGPoint(x: margin, y: view.frame.height - 80)) { prev, btn -> CGPoint in
            view.addSubview(btn)
            btn.center = CGPoint(x: prev.x + btn.bounds.width / 2, y: prev.y)
            return CGPoint(x: prev.x + btn.bounds.width + margin, y: prev.y)
        }
        
        //---Ethan-------------

        // Build Ports and add gestures
        portSize = canvasView.bounds.width / 5.0
        setPorts()

        // Build the Mobile Bar
        mobileBarView = MobileBarView(frame: CGRect(x: 0.0, y: 0.0, width: 35, height: 100))
        canvas.addSubview(mobileBarView)
        mobileBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mobileBarView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        addPanGesture(mobileBarView)
        //---------------------
    }
    
    private func addButton() -> UIButton {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.addTarget(self, action: #selector(addDidPressed), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        return btn
    }
    
    private func deleteButton() -> UIButton {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.addTarget(self, action: #selector(deleteDidPressed), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        return btn
    }
    
    private func saveButton() -> UIButton {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.addTarget(self, action: #selector(saveDidPressed), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "camera"), for: .normal)
        return btn
    }
    
    @objc func addDidPressed() {
        _ = canvasView.addLayer()
    }
    
    @objc func deleteDidPressed() {
        _ = canvasView.deleteLastLayer()
    }
    
    @objc func saveDidPressed() {
        _ = canvasView.renderCanvas()
    }
}

//---Ethan-------------
typealias Port = UIView
extension ViewController {
    //
    // Anchors
    //
    func setPorts() {
        guard let _ = self.portSize else {
            fatalError("Port size nil")
        }
        let width  = canvasView.bounds.width
        let height = canvasView.bounds.height
        
        // Top-Left
        addPort(origin: CGPoint.zero)
        // Top-Middle
        addPort(origin: CGPoint(x: width / 2.0 - portSize / 2.0, y: 0))
        // Top-Right
        addPort(origin: CGPoint(x: width - portSize, y: 0))
        // Middle-Left
        addPort(origin: CGPoint(x: 0, y: height / 2.0 - portSize / 2.0))
        // Middle-Right
        addPort(origin: CGPoint(x: width - portSize, y: height / 2.0 - portSize / 2.0))
        // Bottom-Left
        addPort(origin: CGPoint(x: 0, y: height - portSize))
        // Bottom-Middle
        addPort(origin: CGPoint(x: width / 2.0 - portSize / 2.0, y: height - portSize))
        // Bottom-Right
        addPort(origin: CGPoint(x: width - portSize, y: height - portSize))
    }
    
    func addPort(origin: CGPoint) {
        let port1 = UIView(frame: CGRect(x: origin.x,
                                         y: origin.y,
                                         width: portSize,
                                         height: portSize))
        port1.backgroundColor = UIColor.yellow
        port1.layer.cornerRadius = 12
        port1.layer.borderWidth = 2
        port1.layer.borderColor = UIColor.black.cgColor
        canvasView.addSubview(port1)
        self.ports.append(port1)
    }
    //
    // Pan Gesture
    //
    func addPanGesture(_ view: UIView) {
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(ViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
        view.isUserInteractionEnabled = true
    }

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        // this is the moving view
        guard let panView = sender.view, panView is MobileBarView else {
            fatalError("Pan view nil")
        }
        
        // If you want to adjust a view's location to keep it under the user's finger,
        // request the translation in that view's superview's coordinate system.
        let translation = sender.translation(in: self.canvasView)
        
        switch sender.state {
        case .began, .changed:
            // displace according to translation
            panView.center = CGPoint(x: panView.center.x + translation.x,
                                     y: panView.center.y + translation.y)
            
            #if DEBUG
            print("PanView.center = \(panView.center)")
            #endif
            
            // reset translation
            sender.setTranslation(CGPoint.zero, in: self.canvasView)
            
            
        case .ended:
            //
            // Ports Check
            //
            checkPortsLoggings(panView as! MobileBarView)
        default:
            break
        }
    }
    
    fileprivate func checkPortsLoggings(_ panView: MobileBarView) {
        
        var intersected: Int?
        var i = 0
        
        while intersected == nil && i<ports.count {
            if panView.frame.intersects(ports[i].frame) {
                intersected = i
            } else {
                i += 1
            }
        }
        var destination: Port?
        if let intersect = intersected {
            destination = self.ports[intersect]
        } else {
            destination = getRelativeNearPort(panView.center)
        }
            
        UIView.animateKeyframes(withDuration: 0.7,
                                delay: 0.0,
                                options: .allowUserInteraction,
                                animations: {
                                    panView.center = destination!.center
                                    panView.rotate(angle: 90.0)
                                },
                                completion: { _ in })
   }
    
    func getRelativeNearPort(_ point: CGPoint) -> Port {
        var nearest = Port()
        var min: CGFloat = CGFloat(Int.max)
        
        self.ports.forEach({ port in
            let distance = ComputeDistance(point, port.center)
            if distance < min  {
                min = distance
                nearest = port
            }
        })
        
        return nearest
    }
    
    func ComputeDistance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let A = abs(a.x - b.x)
        let B = abs(a.y - b.y)
        let C = sqrt(pow(A, 2) + pow(B, 2))
        return C
    }
}

// MARK: - UIView Extension -


//---------------------
