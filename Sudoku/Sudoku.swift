//
//  Game.swift
//  Sudoku
//
//  Created by Dmitry Kozlov on 15.01.15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import UIKit
import OpenGLES

class Sudoku: UIImageView {
    let menu: MenuController
    var size: CGFloat
    var cellSize: CGFloat
    
    var turns = [Turn]()
    
    var cells = [[Cell]]()
    
    init() {
        let ipadOffset: CGFloat = ipad ? 50 : 0
        size = min(resolution.width, resolution.height) - ipadOffset
        size = size - (size % 9)
        cellSize = (size) / 9
        size++
        
        for i in 0...8 {
            var array = [Cell]()
            for j in 0...8 {
                array.append(Cell(x: i, y: j))
            }
            cells.append(array)
        }
        
        menu = MenuController()
        
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        backgroundColor = blackColor
        drawBackground()
        layer.cornerRadius = 6
        
        userInteractionEnabled = true
        
        addSubview(menu)
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func drawBackground() {
          
    }
}

class Cell {
    var blocked: Bool = false {
        didSet(newBlocked) {
            for label in pcLabels {
                label?.textColor = newBlocked ? blockedNumberColor : numberColor
            }
        }
    }
    
    let x: Int
    let y: Int
    
    var canDrawPen = true
    var canDrawPencil = true
    
    // pen
    var availableNumbers = [Bool](count: 10, repeatedValue: true)
    var label: UILabel?
    var number: Int = 0
    
    // pencil
    var pcNumbers = [Bool](count:10, repeatedValue:false)
    var pcLabels = [UILabel?](count:10, repeatedValue:nil)
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func setNumber(number: Int) -> Bool {
        if blocked || self.number != 0 {
            return false
        }
        let font = UIFont(name: fontName, size: ceil(game.cellSize / 1.5))
        label = UILabel(frame: CGRect(x: CGFloat(x) * game.cellSize, y: CGFloat(y) * game.cellSize, width: game.cellSize, height: game.cellSize))
        label!.font = font
        label!.textAlignment = .Center
        label!.textColor = blocked ? blockedNumberColor : numberColor
        label!.text = "\(number)"
        game.addSubview(label!)
        self.number = number
        return true
    }
    func changeNumber(number: Int) -> Bool {
        if self.number == number || blocked || self.number == 0 {
            return false
        }
        self.number = number
        label!.text = "\(number)"
        return true
    }
    func removeNumber() -> Bool {
        if number == 0 || blocked {
            return false
        }
        label?.removeFromSuperview()
        label = nil
        self.number = 0
        return true
    }
    func setPencil(number: Int) -> Bool {
        let n = number-1
        if !pcNumbers[n] {
            return false
        }
            pcNumbers[n] = true
            let cellSize3 = game.cellSize / 3.0
            let font = UIFont(name: "ChalkboardSE-Regular", size: ceil(cellSize3 / 1.5))
            let xx = CGFloat(x) * game.cellSize + CGFloat(n % 3) * cellSize3
            let yy = CGFloat(y) * game.cellSize + CGFloat(n / 3) * cellSize3
            let label: UILabel? = UILabel(frame: CGRect(x: xx, y: yy, width: cellSize3, height: cellSize3))
            label!.font = font
            label!.textAlignment = .Center
            label!.text = "\(number)"
            label!.textColor = pencilColor
            game.addSubview(label!)
            pcLabels[n] = label
        return true
    }
    func removePencil(number: Int) -> Bool {
        let n = number-1
        if pcNumbers[n] {
            return false
        }
        pcNumbers[n] = false
        pcLabels[n]?.removeFromSuperview()
        pcLabels[n] = nil
        return true
    }
    
    func clear() {
        
    }
}

func coordsToNumber(x: Int, y: Int) -> Int {
    return x + 3 * y
}
func numberToCoords(number: Int) -> CGPoint {
    return CGPoint(x: CGFloat(number % 3), y: CGFloat(number / 3))
}