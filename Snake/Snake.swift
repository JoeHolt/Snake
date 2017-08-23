//
//  Snake.swift
//  Snake
//
//  Created by Joe Holt on 8/22/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import Cocoa

class Snake: NSObject {
    
    internal var headPoistion: CGPoint! {
        didSet {
            tail.insert(headPoistion, at: 0)
        }
    }
    internal var tail: [CGPoint] = []
    
    init(initialPoint: CGPoint) {
        self.headPoistion = initialPoint
        tail.insert(headPoistion, at: 0)
    }
    
    internal func addToTail(atPoint: CGPoint) {
        tail.append(atPoint)
    }

}
