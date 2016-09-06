//
//  ViewController.swift
//  Sudoku
//
//  Created by Dmitry Kozlov on 15.01.15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import UIKit


var menuImages = [[[UIImage]]]()
// 0: Pen menu
// 1: Pencil menu
// 2: Selection menu
// 3: Selected menu


var game: Sudoku = Sudoku()

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        game.frame = CGRectOffset(game.frame, (resolution.width - game.size) / 2.0, (resolution.height - game.size) / 2.0)
        view.addSubview(game)
        cut()
        view?.backgroundColor = blueColor
        /*
        var maps = [[[Int]]]()
        while maps.count < 1 {
            let g = GeneratorMap()
            let a = g.generate()
            print(Int(a))
            if a {
                maps.append(g.map2)
            }
        }
        for i in 0...8 {
            for j in 0...8 {
                game.addTurn(Turn(type: .penPlace, number: maps[0][i][j], x: i, y: j))
            }
        }
        */
        /*
        for i in 0...8 {
            for j in 0...8 {
                for k in 1...9 {
                    game.addTurn(Turn(type: .pencilPlace, number: k, x: i, y: j))
                }
            }
        }
*/
    }
    
    func cut() {
        var menu = UIImage(named: "Menu")!
        var numbers = UIImage(named: "Numbers")!
        
        let size = CGSize(width: menuSize, height: menuSize)
        
        menu = ImageEditor.resizeImage(menu, size: size, scale: retina)
        numbers = ImageEditor.resizeImage(numbers, size: size, scale: retina)
        
        let menuWhite = ImageEditor.colorImage(menu, color: whiteColor)
        let menuLightGray = ImageEditor.colorImage(menu, color: lightGrayColor)
        let menuGray = ImageEditor.colorImage(menu, color: grayColor)
        let menuBlue = ImageEditor.colorImage(menu, color: blueColor)
        
        let numbersWhite = ImageEditor.colorImage(numbers, color: whiteColor)
        let numbersBlue = ImageEditor.colorImage(numbers, color: blueColor)
        let numbersBlack = ImageEditor.colorImage(numbers, color: blackColor)
        let numbersGray = ImageEditor.colorImage(numbers, color: grayColor)
        
        let images: [[UIImage]] = [
            [menuWhite, numbersBlue],
            [menuLightGray, numbersWhite],
            [menuBlue, numbersWhite],
            [menuGray, numbersWhite],
            [menuGray, numbersBlack]
        ]
        
        for i in 0...4 {
            let image = ImageEditor.combineImages(images[i], size: size)
            menuImages.append(ImageEditor.cutImage(image, width: 3, height: 3))
        }
    }
    
    func generate() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

enum MenuImage: Int {
    case Pen = 0,
    Pencil,
    PenDown,
    PencilDown,
    PenLocked
}