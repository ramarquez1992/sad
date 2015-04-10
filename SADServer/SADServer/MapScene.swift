//
//  MapScene.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/28/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import SpriteKit

class MapScene: SKScene {

    var displayScale = CGFloat(1)
    var gridSize: CGFloat {
        get {
            return Config.get("initialGridSize") as! CGFloat * displayScale
        }
    }
    
    var origin = CGPoint()
    var obstacles = [CGPoint]()
    var drone = Drone()
    
    override func didMoveToView(view: SKView) {
        origin = CGPoint(x: CGFloat(size.width) / 2, y: CGFloat(size.height) / 2)
        
        reset()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func clear() {
        self.removeAllChildren()
        drawGrid()
        self.addChild(drone)
    }
    
    func redraw() {
        clear()
        
        drone.position = scaleInchesToPixels(drone.physicalPosition)
        
        for o in obstacles {
            drawPoint(o)
        }
    }
    
    func reset() {
        clear()
        obstacles.removeAll()
        drone.reset(origin, physicalPos: scalePixelsToInches(origin))
    }
    
    // MARK: - Grid display
    private func drawGrid() {
        drawCells()
        drawAxes()
    }
    
    private func drawCells() {
        var pathToDraw: CGMutablePath
        
        for (var i = 0; i < Int(gridSize); ++i) {
            var horizontal = SKShapeNode()
            pathToDraw = CGPathCreateMutable()
            var y = CGFloat(Int(size.height / gridSize) * i)
            CGPathMoveToPoint(pathToDraw, nil, 0, y)
            CGPathAddLineToPoint(pathToDraw, nil, size.width, y)
            horizontal.path = pathToDraw
            horizontal.strokeColor = NSColor(hex: Config.get("gridColor") as! String)
            horizontal.lineWidth = Config.get("gridWidth") as! CGFloat
            self.addChild(horizontal)
            
            var vertical = SKShapeNode()
            pathToDraw = CGPathCreateMutable()
            var x = CGFloat(Int(size.width / gridSize) * i)
            CGPathMoveToPoint(pathToDraw, nil, x, 0)
            CGPathAddLineToPoint(pathToDraw, nil, x, size.height)
            vertical.path = pathToDraw
            vertical.strokeColor = NSColor(hex: Config.get("gridColor")as! String)
            vertical.lineWidth = Config.get("gridWidth") as! CGFloat
            self.addChild(vertical)
            
        }
    }
    
    private func drawAxes() {
        drawXAxis()
        drawYAxis()
    }
    
    private func drawXAxis() {
        var xAxis = SKShapeNode()
        
        var pathToDraw = CGPathCreateMutable()
        CGPathMoveToPoint(pathToDraw, nil, 0, size.height / 2)
        CGPathAddLineToPoint(pathToDraw, nil, size.width, size.height / 2)
        xAxis.path = pathToDraw
        
        xAxis.strokeColor = NSColor(hex: Config.get("axisColor") as! String)
        xAxis.lineWidth = Config.get("axisWidth") as! CGFloat
        
        self.addChild(xAxis)
    }
    
    private func drawYAxis() {
        var yAxis = SKShapeNode()
        
        var pathToDraw = CGPathCreateMutable()
        CGPathMoveToPoint(pathToDraw, nil, size.width / 2, 0)
        CGPathAddLineToPoint(pathToDraw, nil, size.width / 2, size.height)
        yAxis.path = pathToDraw
        
        yAxis.strokeColor = NSColor(hex: Config.get("axisColor") as! String)
        yAxis.lineWidth = Config.get("axisWidth") as! CGFloat
        
        self.addChild(yAxis)
    }
    
    func zoom(scaleFactor: CGFloat) {
        displayScale *= scaleFactor
        
        var originalDronePosition = drone.physicalPosition
        drone.physicalPosition = drone.physicalPosition * scaleFactor
        
        for (var i = 0; i < obstacles.count; ++i) {
            obstacles[i] = (obstacles[i] - originalDronePosition) + drone.physicalPosition
        }
        
        redraw()
    }
    
    // MARK: - Manage points
    func addPoint(RFData: RangefinderData) {
        var trueDegrees =  drone.heading + (RFData.angle - 90)

        if (trueDegrees < 0) {
            trueDegrees = 360 - abs(trueDegrees)
        }

        var pt = drone.physicalPosition + (angleToUnitVector(trueDegrees) * RFData.distance)
        
        obstacles.append(pt)
        drawPoint(pt)
    }
    
    private func drawPoint(loc: CGPoint) {
        var color = NSColor(hex: Config.get("ptColor") as! String)
        var size = CGSize(width: Config.get("ptSize") as! Int,
            height: Config.get("ptSize") as! Int)
        
        let point = SKSpriteNode(color: color, size: size)
        point.position = scaleInchesToPixels(loc)

        self.addChild(point)
    }
    
    // MARK: - Scaling
    private func getPixelsPerInch() -> CGFloat {
        var oneFoot = size.width / gridSize
        var oneInch = oneFoot / 12
        
        return oneInch
    }
    
    private func inchesToPixels(inches: CGFloat) -> CGFloat {
        return (inches * getPixelsPerInch())
    }
    
    private func pixelsToInches(pixels: CGFloat) -> CGFloat {
        return (pixels / getPixelsPerInch())
    }
    
    private func scaleInchesToPixels(pt: CGPoint) -> CGPoint {
        return CGPoint(x: inchesToPixels(pt.x), y: inchesToPixels(pt.y))
    }
    
    private func scalePixelsToInches(pt: CGPoint) -> CGPoint {
        return CGPoint(x: pixelsToInches(pt.x), y: pixelsToInches(pt.y))
    }

}
