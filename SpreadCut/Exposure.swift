//
//  Exposure.swift
//  SpreadCut
//
//  Created by apple on 06.10.21.
//

import Foundation

class Exposure{
    var exposeAverageDistance: Int
    var exposeClosestDistance: Int
    var exposeDuration: Int
    var lastExpose: String
    init(exposeAverageDistance: Int, exposeClosestDistance: Int, exposeDuration: Int, lastExpose: String){
        self.exposeAverageDistance = exposeAverageDistance
        self.exposeClosestDistance = exposeClosestDistance
        self.exposeDuration = exposeDuration
        self.lastExpose = lastExpose
    }
}
