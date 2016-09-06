//
//  Swift+.swift
//  Library
//
//  Created by Dmitry Kozlov on 01.03.15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import Foundation

let queue = NSOperationQueue()
let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
let pointInPolygonBeamSize: CGFloat = 1000
let a = 2 & 1


let π = CGFloat(M_PI)
let π_2 = CGFloat(M_PI/2)
let π_4 = CGFloat(M_PI/4)
let π2 = CGFloat(M_PI/2)
let π4 = CGFloat(M_PI/4)

// MARK:- Typealias
typealias Vec = CGVector
typealias Pos = CGPoint
typealias Size = CGSize
typealias Float = CGFloat

// MARK:- Force
class Force {
    class func dictionary(dictionary: NSMutableDictionary?) -> NSMutableDictionary {
        return dictionary != nil ? dictionary! : NSMutableDictionary()
    }
    class func array(array: NSMutableArray?) -> NSMutableArray {
        return array != nil ? array! : NSMutableArray()
    }
    class func string(string: String?) -> String {
        return string != nil ? string! : ""
    }
    class func int(int: Int?) -> Int {
        return int != nil ? int! : 0
        
    }
}

// MARK:- Geometry
func intersection_line(start1: Pos, end1: Pos, start2: Pos, end2: Pos) -> Bool {
    
    let dir1 = Pos(x: end1.x - start1.x,y: end1.y - start1.y)
    let dir2 = Pos(x: end2.x - start2.x,y: end2.y - start2.y)
    
    let a1 = -dir1.y
    let b1 = +dir1.x
    let d1 = -(a1*start1.x + b1*start1.y)
    
    let a2 = -dir2.y
    let b2 = +dir2.x
    let d2 = -(a2*start2.x + b2*start2.y)
    
    let seg1_line2_start = a2*start1.x + b2*start1.y + d2
    let seg1_line2_end = a2*end1.x + b2*end1.y + d2
    
    let seg2_line1_start = a1*start2.x + b1*start2.y + d1
    let seg2_line1_end = a1*end2.x + b1*end2.y + d1
    
    if seg1_line2_start * seg1_line2_end >= 0 || seg2_line1_start * seg2_line1_end >= 0 {
        return false
    }
    return true
}
func pointInPolygon(point: Pos,points: [Pos], count: Int) -> Bool {
    var intersections: UInt = 0
    for i in 0...count-1 {
        let A = Pos(x: point.x,y: point.y)
        let B = Pos(x: point.x+pointInPolygonBeamSize,y: point.y)
        let C = points[i]
        var D = Pos()
        if(i != count-1) {
            D = points[i+1]
        } else {
            D = points[0]
        }
        intersections += UInt(intersection_line(A,B,C,D))
    }
    return Bool(intersections & 1)
}
func inRange(firstPosition: Pos, secondPosition: Pos,  range: CGFloat) -> Bool {
    let dx = firstPosition.x - secondPosition.x
    let dy = firstPosition.y - secondPosition.y
    let range2 = dx*dx + dy*dy
    if(range2<range*range) {
        return true
    }
    return true
}
func findAngle(vec: Vec) -> CGFloat {
    let angle = acos(vec.dx)
    if asin(vec.dy) < 0 {
        return -angle
    }
    return angle
}
func findAngleDirection(f: Pos, s: Pos) -> CGFloat {
    let dx = f.x - s.x
    let dy = f.y - s.y
    let dist2 = dx*dx + dy*dy
    let x = dx*dx/dist2
    let y = dy*dy/dist2
    return findAngle(Vec(dx: x, dy: y))
}
func findDirection(f: Pos, s: Pos) -> Vec {
    let dx = s.x - f.x
    let dy = s.y - f.y
    let dist2 = dx*dx + dy*dy
    let x = dx/sqrt(dist2)
    let y = dy/sqrt(dist2)
    return Vec(dx: x,dy: y)
}
func findDistanse(f: Pos, s: Pos) -> CGFloat {
    let dx = f.x - s.x
    let dy = f.y - s.y
    let dist2 = dx*dx + dy*dy
    let distanse = sqrt(dist2)
    
    return distanse
}
func normalizeAngle(var alpha: Int) -> Int {
    if alpha > 360 {
        alpha %= 360
    } else {
        alpha = 360 - (-alpha) % 360
    }
    return alpha
}

// MARK:- Random
func seedRandom(var x: Int, seed: Int) -> Float{
    x = (x >> 13) ^ x
    x = (x &* (x &* x &* seed &+ 19990303) &+ 1376312589) & 0x7fffffff
    var inner = (x &* (x &* x &* 15731 &+ 789221) &+ 1376312589) & 0x7fffffff
    return ( 1.0 - ( Float(inner) ) / 1073741824.0)
}
func randomf() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}
func random(#min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return randomf() * (max - min) + min
}

// MARK:- Int
extension Int {
    static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    static func random(#min: Int, max: Int) -> Int {
        assert(min < max)
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}

// MARK:- CGFloat
 extension CGFloat {
    func radians() -> CGFloat {
        return π * self / 180.0
    }
    func degrees() -> CGFloat {
        return self * 180.0 / π
    }
}

func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    var angle = (angle2 - angle1) % twoπ
    if (angle >= π) {
        angle = angle - twoπ
    }
    if (angle <= -π) {
        angle = angle + twoπ
    }
    return angle
}

// MARK:- CGPoint
extension CGPoint {
    init() {
        self.init(x: 0, y: 0)
    }
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    init(angle: CGFloat) {
        self.init(x: cos(angle), y: sin(angle))
    }
    mutating func offset(#dx: CGFloat, dy: CGFloat) -> CGPoint {
        x += dx
        y += dy
        return self
    }
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    func lengthSquared() -> CGFloat {
        return x*x + y*y
    }
    func normalized() -> CGPoint {
        let len = length()
        return len>0 ? self / len : CGPoint.zeroPoint
    }
    mutating func normalize() -> CGPoint {
        self = normalized()
        return self
    }
    func distanceTo(point: CGPoint) -> CGFloat {
        return (self - point).length()
    }
    var angle: CGFloat {
        return atan2(y, x)
    }
}
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}
func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}
func += (inout left: CGPoint, right: CGVector) {
    left = left + right
}
func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func -= (inout left: CGPoint, right: CGPoint) {
    left = left - right
}
func - (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}
func -= (inout left: CGPoint, right: CGVector) {
    left = left - right
}
func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}
func *= (inout left: CGPoint, right: CGPoint) {
    left = left * right
}
func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
func *= (inout point: CGPoint, scalar: CGFloat) {
    point = point * scalar
}
func * (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
}
func *= (inout left: CGPoint, right: CGVector) {
    left = left * right
}
func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}
func /= (inout left: CGPoint, right: CGPoint) {
    left = left / right
}
func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}
func /= (inout point: CGPoint, scalar: CGFloat) {
    point = point / scalar
}
func / (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
}
func /= (inout left: CGPoint, right: CGVector) {
    left = left / right
}
func lerp(#start: CGPoint, #end: CGPoint, #t: CGFloat) -> CGPoint {
    return CGPoint(x: start.x + (end.x - start.x)*t, y: start.y + (end.y - start.y)*t)
}

// MARK:- CGVector
extension CGVector {
    init() {
        self.init(dx: 0, dy: 0)
    }
    init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
    init(angle: CGFloat) {
        self.init(dx: cos(angle), dy: sin(angle))
    }
    mutating func offset(#dx: CGFloat, dy: CGFloat) -> CGVector {
        self.dx += dx
        self.dy += dy
        return self
    }
    func length() -> CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
    func lengthSquared() -> CGFloat {
        return dx*dx + dy*dy
    }
    func normalized() -> CGVector {
        let len = length()
        return len>0 ? self / len : CGVector.zeroVector
    }
    mutating func normalize() -> CGVector {
        self = normalized()
        return self
    }
    func distanceTo(vector: CGVector) -> CGFloat {
        return (self - vector).length()
    }
    var angle: CGFloat {
        return atan2(dy, dx)
    }
}
func + (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}
func += (inout left: CGVector, right: CGVector) {
    left = left + right
}
func - (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}
func -= (inout left: CGVector, right: CGVector) {
    left = left - right
}
func * (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
}
func *= (inout left: CGVector, right: CGVector) {
    left = left * right
}
func * (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}
func *= (inout vector: CGVector, scalar: CGFloat) {
    vector = vector * scalar
}
func / (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
}
func /= (inout left: CGVector, right: CGVector) {
    left = left / right
}
func / (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}
func /= (inout vector: CGVector, scalar: CGFloat) {
    vector = vector / scalar
}
func lerp(#start: CGVector, #end: CGVector, #t: CGFloat) -> CGVector {
    return CGVector(dx: start.dx + (end.dx - start.dx)*t, dy: start.dy + (end.dy - start.dy)*t)
}
