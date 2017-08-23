//
//  GameScene.swift
//  Snake
//
//  Created by Joe Holt on 8/22/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let gridSize = 20           //Size of snake grid
    private let frameUpdate = 15        //How often the frame will update(x/60)
    private var mainView: SKView!       //Scenekit view
    private var snake: Snake!           //Snake
    private var shouldExtendSnake: Bool = false //Tell wheather or not to add food to snake
    private var currentFrame = 0        //Counts what frame in order to tell when to update
    private var currentDirection: CGPoint = CGPoint(x: 0, y: 0  ) //Directoin snake will go
    
    override func didMove(to view: SKView) {
        self.mainView = view
        backgroundColor = SKColor.black
        view.showsFPS = true
        snake = Snake(initialPoint: CGPoint(x: 0, y: 0))
        spawnFood()
    }
    
    override func update(_ currentTime: TimeInterval) {
        currentFrame += 1
        if currentFrame == frameUpdate {
            // Change location
            var newPoint = snake.headPoistion
            newPoint?.x += currentDirection.x
            newPoint?.y += currentDirection.y
            //Check for death
            //Edges
            let max = gridSize/2 + 2
            if Int(snake.headPoistion!.x) > max || Int(snake.headPoistion!.x) < -max || Int(snake.headPoistion!.y) > max || Int(snake.headPoistion!.y) < -max {
                //Snake out of bounds
                reset()
                return
            }
            //Run into self
            for point in snake.tail {
                if point == newPoint && currentDirection != CGPoint(x: 0, y: 0) {
                    reset()
                    break
                }
            }
            //Remove last node and check if snake should be made bigger
            if shouldExtendSnake == false {
                removeSquare(x: Int((snake.tail.last?.x)!), y: Int((snake.tail.last?.y)!))
                snake.tail.removeLast()
            } else {
                shouldExtendSnake = false
            }
            //Draw new square at new location
            snake.headPoistion = newPoint
            drawSquare(x: Int(snake.headPoistion.x), y: Int(snake.headPoistion.y))
            currentFrame = 0
        }
    }
    
    override func keyDown(with event: NSEvent) {
        handleKeyEvent(event: event)
    }
    
    private func handleKeyEvent(event: NSEvent) {
        let charachters = event.characters
        for char in charachters! {
            switch char {
            case "w":
                currentDirection = CGPoint(x: 0, y: 1)
            case "a":
                currentDirection = CGPoint(x: -1, y: 0)
            case "s":
                currentDirection = CGPoint(x: 0, y: -1)
            case "d":
                currentDirection = CGPoint(x: 1, y: 0)
            case "z":
                didEatFood()
            default:
                break
            }
        }
    }
    
    private func reset() {
        currentFrame = 0
        snake = Snake(initialPoint: CGPoint(x: 0, y: 0))
        currentDirection = CGPoint(x: 0, y: 0)
        for child in children {
            child.removeFromParent()
        }
        shouldExtendSnake = false
        spawnFood()
    }
    
    private func spawnFood() {
        let randX = Int(arc4random_uniform(UInt32(gridSize))) - Int(gridSize/2)
        let randY = Int(arc4random_uniform(UInt32(gridSize))) - Int(gridSize/2)
        drawSquare(x: randX, y: randY, color: SKColor.purple)
    }
    
    private func didEatFood() {
        shouldExtendSnake = true
    }
    
    private func drawSquare(x: Int, y: Int, color: SKColor = SKColor.white) {
        let height = mainView.frame.size.height/CGFloat(gridSize)
        let xDim = (mainView.frame.size.width/CGFloat(gridSize)) * CGFloat(x)
        let yDim = (mainView.frame.size.height/CGFloat(gridSize)) * CGFloat(y)
        let square = SKSpriteNode()
        square.position = CGPoint(x: xDim, y: yDim)
        square.size = CGSize(width: height - 2, height: height - 2)
        square.color = color
        addChild(square)
    }
    
    private func removeSquare(x: Int, y: Int) {
        let xDim = (mainView.frame.size.width/CGFloat(gridSize)) * CGFloat(x)
        let yDim = (mainView.frame.size.height/CGFloat(gridSize)) * CGFloat(y)
        let nodesAtPoint = nodes(at: CGPoint(x: xDim, y: yDim))
        for node in nodesAtPoint {
            node.removeFromParent()
        }
    }
}
