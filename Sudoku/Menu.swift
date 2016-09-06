//
//  Menu.swift
//  Sudoku
//
//  Created by Dmitry Kozlov on 23.01.15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import UIKit


class MenuController: UIView {
    let pen: MenuView = MenuView(type: .Pen)
    let pencil: MenuView = MenuView(type: .Pencil)
    var vertical = false
    var cell: Cell?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        addSubview(pen)
        addSubview(pencil)
        NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
    }
    
    func touchDown(pos: CGPoint, cell: Cell) {
        self.frame = CGRect(origin: pos, size: CGSize())
        self.cell = cell
        pen.touchDown(0)
        pencil.touchDown(π)
    }
    func touchMoved(pos: CGPoint) {
        
    }
    func touchUp(pos: CGPoint) {
        pen.touchUp()
        pencil.touchUp()
        
    }
    
    func tick() {
        pen.angle += 0.1
        pencil.angle += 0.1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuView: UIView {
    let imageViews: [UIImageView]
    let type: DrawType
    var angle: CGFloat {
        didSet {
            frame = CGRect(x: cos(angle) * menuSize, y: sin(angle) * menuSize, width: 0, height: 0)
        }
    }
    init(type: DrawType) {
        self.type = type
        var views = [UIImageView]()
        angle = type == .Pen ? 0 : π
        for i in 0...8 {
            let coords = numberToCoords(i)
            let view = UIImageView(frame: CGRect(x: coords.x * iconSize - menuSize / 2.0, y: coords.y * iconSize - menuSize / 2.0, width: iconSize, height: iconSize))
            views.append(view)
        }
        imageViews = views
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        for view in imageViews {
            addSubview(view)
        }
        self.hidden = true
    }
    
    func touchDown(angle: CGFloat) {
        self.hidden = false
        let imageIndex = type == .Pen ? 0 : 1
        for i in 0...8 {
            let coords = numberToCoords(i)
            let x = Int(coords.x)
            let y = Int(coords.y)
            imageViews[i].image = menuImages[imageIndex][x][y]
        }
    }
    
    func touchMoved() {
        
    }
    
    func touchUp() {
        self.hidden = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
class Menu: UIView {
    let right: Bool
    let size: CGFloat
    let size2: CGFloat
    let offset: CGFloat
    let iconSize: CGFloat
    let corner: CGFloat
    
    var views = [[UIImageView]]()
    
    var imageTypes: [[Int]]
    var imageTypesHighlighted: [[Int]]
    
    var sx = 3
    var sy = 3
    
    var active = true
    
    var cell: Cell?
    
    init(right: Bool) {
        self.right = right
        size = CGFloat(menuSize)
        size2 = size / 2.0
        offset = right ? size / 1.5 : size / -1.5
        iconSize = CGFloat(size) / 3.0
        corner = iconSize * -1.5
        imageTypes = [[Int]](count: 3, repeatedValue: [Int](count: 3, repeatedValue: Int(!right)))
        imageTypesHighlighted = [[Int]](count: 3, repeatedValue: [Int](count: 3, repeatedValue: 2))
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        //backgroundColor = right ? UIColor.blueColor() : UIColor.lightGrayColor()
        alpha = 0.0
        hidden = true
        layer.cornerRadius = 10
        
        
        for i in 0...2 {
            var array = [UIImageView]()
            for j in 0...2 {
                let ox = corner + iconSize * CGFloat(i) + (CGFloat(i) - 1) * 2
                let oy = corner + iconSize * CGFloat(j) + (CGFloat(j) - 1) * 2
                let view = UIImageView(frame: CGRect(x: ox, y: oy, width: iconSize, height: iconSize))
                self.addSubview(view)
                array.append(view)
            }
            views.append(array)
        }
    }
    
    func start(cell: Cell) {
        if !right && game.selectedCell.number != 0 {
            active = false
            return
        } else {
            active = true
        }
        let ox = game.frame.origin.x
        let oy = game.frame.origin.y
        var x = pos.x + ox
        var y = pos.y + oy
        
        var mode = resolution.width > resolution.height // 1: left-right 0: top-bottom
        if mode {
            x += offset
            if y < size2 {
                y = size2
            } else if y > resolution.height - size2 {
                y = resolution.height - size2
            }
            if right {
                if x + size2 > resolution.width {
                    y -= size
                    if y < size2 {
                        y += size * 2
                    }
                    x = resolution.width - size2
                } else {
                    
                }
            } else {
                if x < size2 {
                    y -= size
                    if y < size2 {
                        y += size * 2
                    }
                    x = size2
                }
            }
        } else {
            y -= offset
            if x < size2 {
                x = size2
            } else if x > resolution.width - size2 {
                x = resolution.width - size2
            }
            if right {
                if y < size2 {
                    x -= size
                    if x < size2 {
                        x += size * 2
                    }
                    y = size2
                }
            } else {
                if y + size2 > resolution.height {
                    x -= size
                    if x < size2 {
                        x += size * 2
                    }
                    y = resolution.height - size2
                } else {
                    
                }
            }
        }
        self.frame = CGRect(x: pos.x, y: pos.y, width: 0, height: 0)
        
        self.superview?.bringSubviewToFront(self)
        hidden = false
        UIView.animateWithDuration(0.2, animations: {
            self.alpha = 1.0
            self.frame = CGRect(x: x-ox, y: y-oy, width: 0, height: 0)
        })
    }
    
    func moved(pos: CGPoint) {
        if !active {
            return
        }
        let x = Int((pos.x - frame.origin.x - corner) / iconSize + 1) - 1
        let y = Int((pos.y - frame.origin.y - corner) / iconSize + 1) - 1
        
        let selected = sx != 3 && sy != 3
        
        if x >= 0 && x < 3 && y >= 0 && y < 3 {
            if x != sx || y != sy {
                if selected {views[sx][sy].highlighted = false}
                views[x][y].highlighted = true
                
                sx = x
                sy = y
            }
        } else if selected {
            views[sx][sy].highlighted = false
            sx = 3
            sy = 3
        }
    }
    
    
    func end() -> Int {
        if !active {
            return 0
        }
        UIView.animateWithDuration(0.2, animations: {
            self.alpha = 0.0
            }, completion: {
                completed in if completed {self.hidden = true}
            }
        )
        if sx != 3 && sy != 3 {
            let n = (sx+1) + 3 * sy
            views[sx][sy].highlighted = false
            sx = 3
            sy = 3
            return n
        }
        return 0
    }
    
    func loadImages() {
        for i in 0...2 {
            for j in 0...2 {
                views[i][j].image = menuImages[imageTypes[i][j]][i][j]
                views[i][j].highlightedImage = menuImages[imageTypesHighlighted[i][j]][i][j]
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
enum DrawType {
    case Pen, Pencil
}