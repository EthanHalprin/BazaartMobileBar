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
    
    required init(canvasView: CanvasView, size: CGFloat) {
        canvas = canvasView
        portSize = size
    }
    
    /// build ports (rects) in 8 places on the edges of Canvas
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
    
    /// Find nearest port to the given point (by distance calculation - Pythagors)
    func getRelativeNearPort(_ point: CGPoint) -> PortView? {
        var nearest: PortView?
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
    
    /// Look for intersected port with given view. If not found - compute the nearest one
    func scanPortsIntersections(for panView: MobileBarView) -> PortView? {
        var intersected: Int?
        var i = 0
        
        while intersected == nil && i<ports.count {
            if panView.frame.intersects(ports[i].frame) {
                intersected = i
            } else {
                i += 1
            }
        }
        var destinationPort: PortView?
        if let intersect = intersected {
            destinationPort = ports[intersect]
        } else {
            guard let port = getRelativeNearPort(panView.center) else {
                fatalError("Nearest PortView nil")
            }
            destinationPort = port
        }
        
        return destinationPort
    }

}

// MARK: - PortsManager Extension - Aux
extension PortsManager {
    
    fileprivate func addPort(origin: CGPoint, horizontal: Bool = false) {
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

    fileprivate func ComputeDistance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let A = abs(a.x - b.x)
        let B = abs(a.y - b.y)
        let C = sqrt(pow(A, 2) + pow(B, 2))
        return C
    }
}
