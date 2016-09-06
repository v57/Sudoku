//
//  Turn.swift
//  Sudoku
//
//  Created by Dmitry Kozlov on 23.01.15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import Foundation

extension Sudoku {
    func addTurn(turn: Turn) {
        let cell = cells[turn.x][turn.y]
        switch turn.type {
        case .penPlace:
            let completed = cell.setNumber(turn.number)
            if completed {
                for i in 1...9 {
                    cell.removePencil(i)
                }
            }
        case .penRemove:
            let completed = cell.removeNumber()
        case .pencilPlace:
            let completed = cell.setPencil(turn.number)
        case .pencilRemove:
            let completed = cell.removePencil(turn.number)
        case .penChange:
            let completed = cell.changeNumber(turn.number)
        }
    }
    
    func removeTurn() {
        
    }
    
    func recoverTurn() {
        
    }
}

class Turn {
    let type: TurnType
    let number: Int
    let secondNumber: Int
    let x: Int
    let y: Int
    
    init(type: TurnType, number: Int, secondNumber: Int, x: Int, y: Int) {
        self.type = type
        self.number = number
        self.secondNumber = secondNumber
        self.x = x
        self.y = y
    }
    
    
    enum TurnType {
        case penPlace, penRemove, penChange, pencilPlace, pencilRemove
        func reverse() -> TurnType{
            switch self {
            case .penPlace:
                return penRemove
            case .penRemove:
                return .penPlace
            case .pencilPlace:
                return .pencilRemove
            case .pencilRemove:
                return .pencilPlace
            case .penChange:
                return .penChange
            }
        }
    }
}