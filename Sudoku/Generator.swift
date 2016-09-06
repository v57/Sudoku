//
//  Generator.swift
//  Sudoku
//
//  Created by Dmitry Kozlov on 24.01.15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import Foundation

class GeneratorMap {
    var map = [[[Bool]]](count: 9, repeatedValue: [[Bool]](count: 9, repeatedValue: [Bool](count: 9, repeatedValue: true)))
    var map2 = [[Int]](count: 9, repeatedValue: [Int](count: 9, repeatedValue: 0))
    func generate() -> Bool {
        for i in 0...8 {
            for j in 0...8 {
                var fail = true
                for k in 0...8 {
                    if map[i][j][k] {
                        fail = false
                        break
                    }
                }
                if fail {
                    return false
                }
                var setted = false
                while !setted {
                    setted = setNumber(i, y: j, number: Int(arc4random_uniform(9)))
                }
            }
        }
        return true
    }
    func setNumber(x: Int, y: Int, number: Int) -> Bool {
        if !map[x][y][number] {
            return false
        }
        let cx = x / 3 * 3
        let cy = y / 3 * 3
        for i in 0...8 {
            map[i][y][number] = false
        }
        for i in 0...8 {
            map[x][i][number] = false
        }
        for i in 0...8 {
            map[x][y][i] = false
        }
        for i in 0...2 {
            for j in 0...2 {
                map[cx+i][cy+j][number] = false
            }
        }
        map2[x][y] = number + 1
        return true
    }
}

extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}