//
//  GirdConverting.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct GridConverting {

    struct GeoSearchInfo {
        var latitude: Double
        var longtitude: Double
        var xGrid: Int
        var yGRid: Int
    }

    enum Mode {
        case toGrid
        case toCoordinate
    }

    static func gridConvert(
        mode: Mode,
        xComponent: Double,
        yComponent: Double
    ) -> GeoSearchInfo {
        let degreeToRadianFactor = Double.pi / 180.0
        let radianTodegreeFactor = 180.0 / Double.pi
        let gridSize = 5.0
        let earthRadiusByGridSize = 6371.00877 / gridSize
        let originXGrid: Double = 43
        let originYGrid: Double = 136
        let standardLatitude1 = 30.0 * degreeToRadianFactor
        let standardLatitude2 = 60.0 * degreeToRadianFactor
        let originLongtitude = 126.0 * degreeToRadianFactor
        let originLatitude = 38.0 * degreeToRadianFactor

        var snValue = tan(Double.pi * 0.25 + standardLatitude2 * 0.5) / tan(Double.pi * 0.25 + standardLatitude1 * 0.5)
        snValue = log(cos(standardLatitude1) / cos(standardLatitude2)) / log(snValue)
        var sfValue = tan(Double.pi * 0.25 + standardLatitude1 * 0.5)
        sfValue = pow(sfValue, snValue) * cos(standardLatitude1) / snValue
        var roValue = tan(Double.pi * 0.25 + originLatitude * 0.5)
        roValue = earthRadiusByGridSize * sfValue / pow(roValue, snValue)
        var rsValue = GeoSearchInfo(latitude: 0, longtitude: 0, xGrid: 0, yGRid: 0)

        switch mode {
        case .toGrid:
            rsValue.latitude = yComponent
            rsValue.longtitude = xComponent
            var raValue = tan(Double.pi * 0.25 + (yComponent) * degreeToRadianFactor * 0.5)
            raValue = earthRadiusByGridSize * sfValue / pow(raValue, snValue)
            var theta = xComponent * degreeToRadianFactor - originLongtitude

            if theta > Double.pi {
                theta -= 2.0 * Double.pi
            } else if theta < -Double.pi {
                theta += 2.0 * Double.pi
            }

            theta *= snValue
            rsValue.xGrid = Int(floor(raValue * sin(theta) + originXGrid + 0.5))
            rsValue.yGRid = Int(floor(roValue - raValue * cos(theta) + originYGrid + 0.5))
        case .toCoordinate:
            rsValue.xGrid = Int(xComponent)
            rsValue.yGRid = Int(yComponent)
            let xnValue = xComponent - originXGrid
            let ynValue = roValue - yComponent + originYGrid
            var raValue = sqrt(xnValue * xnValue + ynValue * ynValue)

            if snValue < 0.0 {
                raValue = -raValue
            }
            var alat = pow((earthRadiusByGridSize * sfValue / raValue), (1.0 / snValue))
            var theta = 0.0
            alat = 2.0 * atan(alat) - Double.pi * 0.5

            if abs(xnValue) <= 0.0 {
                theta = 0.0
            } else if abs(ynValue) <= 0.0 {
                theta = Double.pi * 0.5
                if xnValue < 0.0 {
                    theta = -theta
                }
            } else {
                theta = atan2(xnValue, ynValue)
            }

            let alon = theta / snValue + originLongtitude
            rsValue.latitude = alat * radianTodegreeFactor
            rsValue.longtitude = alon * radianTodegreeFactor
        }

        return rsValue
    }
}
