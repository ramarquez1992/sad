//
//  MapScene.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/28/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import SpriteKit

class MapScene: SKScene {

    var origin = CGPoint()
    var obstacles = [CGPoint]()
    
    override func didMoveToView(view: SKView) {
        origin = CGPoint(x: CGFloat(size.width) / 2, y: CGFloat(size.height) / 2)
        
        reset()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func reset() {
        self.removeAllChildren()
        obstacles.removeAll()
        
        drawGrid()
    }
    
    // MARK: - Grid display
    private func drawGrid() {
        drawCells()
        drawAxes()
        
        // TODO: draw labels
        
    }
    
    private func drawCells() {
        var pathToDraw: CGMutablePath
        var gridSize = Config.get("gridSize") as CGFloat
        
        for (var i = 0; i < Int(gridSize); ++i) {
            var horizontal = SKShapeNode()
            pathToDraw = CGPathCreateMutable()
            var y = CGFloat(Int(size.height / gridSize) * i)
            CGPathMoveToPoint(pathToDraw, nil, 0, y)
            CGPathAddLineToPoint(pathToDraw, nil, size.width, y)
            horizontal.path = pathToDraw
            horizontal.strokeColor = NSColor(hex: Config.get("gridColor") as String)
            horizontal.lineWidth = Config.get("gridWidth") as CGFloat
            self.addChild(horizontal)
            
            var vertical = SKShapeNode()
            pathToDraw = CGPathCreateMutable()
            var x = CGFloat(Int(size.width / gridSize) * i)
            CGPathMoveToPoint(pathToDraw, nil, x, 0)
            CGPathAddLineToPoint(pathToDraw, nil, x, size.height)
            vertical.path = pathToDraw
            vertical.strokeColor = NSColor(hex: Config.get("gridColor") as String)
            vertical.lineWidth = Config.get("gridWidth") as CGFloat
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
        
        xAxis.strokeColor = NSColor(hex: Config.get("axisColor") as String)
        xAxis.lineWidth = Config.get("axisWidth") as CGFloat
        
        self.addChild(xAxis)
    }
    
    private func drawYAxis() {
        var yAxis = SKShapeNode()
        
        var pathToDraw = CGPathCreateMutable()
        CGPathMoveToPoint(pathToDraw, nil, size.width / 2, 0)
        CGPathAddLineToPoint(pathToDraw, nil, size.width / 2, size.height)
        yAxis.path = pathToDraw
        
        yAxis.strokeColor = NSColor(hex: Config.get("axisColor") as String)
        yAxis.lineWidth = Config.get("axisWidth") as CGFloat
        
        self.addChild(yAxis)
    }
    
    // MARK: - Manage points
    func addRandomPoints(n: Int) {
        if (n > 0) {
            addPoint(getRandomPosition())

            delay(300) {
                self.addRandomPoints(n - 1)
            }
        }
    }
    
    func addPoint(RFData: RangefinderData) {
        // TODO: find real point relative to current position and addPoint()
    }
    
    func addPoint(loc: CGPoint) {
        obstacles.append(loc)
        
        var color = NSColor(hex: Config.get("ptColor") as String)
        var size = CGSize(width: Config.get("ptSize") as Int,
            height: Config.get("ptSize") as Int)
        
        let point = SKSpriteNode(color: color, size: size)
        point.position = loc

        self.addChild(point)
    }

}
