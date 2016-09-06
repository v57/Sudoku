//
//  Touch.swift
//  Sudoku
//
//  Created by Dmitry Kozlov on 29.01.15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import UIKit
extension Sudoku {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let pos = touch.locationInView(self)
        
        var tx = Int(pos.x / cellSize)
        var ty = Int(pos.y / cellSize)
        
        if tx > 8 {
            tx = 8
        }
        if ty > 8 {
            ty = 8
        }
        
        //selectedCell = cells[tx][ty]
        menu.touchDown(pos, cell: cells[tx][ty])
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let pos = touch.locationInView(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let pos = touch.locationInView(self)
        menu.touchUp(pos)
        /*
        let p = pen.end()
        let pc = pencil.end()
        
        if p > 0 {
            if selectedCell.number == p {
                addTurn(Turn(type: .penRemove, number: p, secondNumber: 0, x: selectedCell.x, y: selectedCell.y))
            } else if selectedCell.number > 0 {
                addTurn(Turn(type: .penChange, number: p, secondNumber: selectedCell.number, x: selectedCell.x, y: selectedCell.y))
            } else {
                addTurn(Turn(type: .penPlace, number: p, secondNumber: 0, x: selectedCell.x, y: selectedCell.y))
            }
        } else if pc > 0 {
            if selectedCell.pcNumbers[pc-1] {
                addTurn(Turn(type: .pencilRemove, number: p, secondNumber: 0, x: selectedCell.x, y: selectedCell.y))
            } else {
                addTurn(Turn(type: .pencilPlace, number: p, secondNumber: 0, x: selectedCell.x, y: selectedCell.y))
            }
        }
*/
    }
}