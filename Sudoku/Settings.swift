//
//  Settings.swift
//  Sudoku
//
//  Created by Dmitry Kozlov on 29.01.15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import UIKit

// Device settings
var resolution = UIScreen.mainScreen().bounds.size
let retina = UIScreen.mainScreen().scale
var center = CGPoint(x: resolution.width/2, y: resolution.height/2)
let ipad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
let menuSize: CGFloat = ipad ? 150 : 120
let iconSize: CGFloat = menuSize / 3

// Color settings
let whiteColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
let blueColor = UIColor(red: 0.07, green: 0.5, blue: 1.0, alpha: 1.0)
let lightGrayColor = UIColor.lightGrayColor()
let grayColor = UIColor.grayColor()
let darkGrayColor = UIColor.darkGrayColor()
let blackColor = UIColor.blackColor()

// Table settings
let numberColor = whiteColor
let blockedNumberColor = blackColor
let pencilColor = whiteColor
let fontName = "ChalkboardSE-Regular"

let tableFirstColor = Color(red: 18, green: 127, blue: 255)
let tableSecondColor = Color(red: 38, green: 147, blue: 255)
let tableGridColor = Color(red: 247, green: 247, blue: 247)
