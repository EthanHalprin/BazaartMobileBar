//
//  PortsManager.swift
//  BazaartProject
//
//  Created by Ethan on 08/06/2021.
//

import Foundation

class PortsManager {
    
    var ports = [PortView]()
    var portSize: CGFloat!
    var canvas: CanvasView!
    
    required init(canvasView: CanvasView) {
        canvas = canvasView
    }
    
    func setPorts() {
        guard let _ = self.portSize else {
            fatalError("Port size nil")
        }
        let width  = canvas.bounds.width
        let height = canvas.bounds.height
        
        // Top-Left
        addPort(origin: CGPoint.zero)
        // Top-Middle
        addPort(origin: CGPoint(x: width / 2.0 - portSize / 2.0, y: 0), horizontal: true)
        // Top-Right
        addPort(origin: CGPoint(x: width - portSize, y: 0))
        // Middle-Left
        addPort(origin: CGPoint(x: 0, y: height / 2.0 - portSize / 2.0))
        // Middle-Right
        addPort(origin: CGPoint(x: width - portSize, y: height / 2.0 - portSize / 2.0))
        // Bottom-Left
        addPort(origin: CGPoint(x: 0, y: height - portSize))
        // Bottom-Middle
        addPort(origin: CGPoint(x: width / 2.0 - portSize / 2.0, y: height - portSize), horizontal: true)
        // Bottom-Right
        addPort(origin: CGPoint(x: width - portSize, y: height - portSize))
    }
    func addPort(origin: CGPoint, horizontal: Bool = false) {
        let port = PortView(frame: CGRect(x: origin.x,
                                         y: origin.y,
                                         width: portSize,
                                         height: portSize))
        port.backgroundColor = UIColor.yellow
        port.layer.cornerRadius = 12
        port.layer.borderWidth = 2
        port.layer.borderColor = UIColor.black.cgColor
        port.isHorizontal = horizontal
        canvas.addSubview(port)
        self.ports.append(port)
    }

    
}
