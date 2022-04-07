//
//  GirdConverting.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct GridConverting {
    enum Mode {
        case toGrid
        case toCoordinate
    }
    static func convertGRID_GPS(
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

        var sn = tan(Double.pi * 0.25 + standardLatitude2 * 0.5) / tan(Double.pi * 0.25 + standardLatitude1 * 0.5)
        sn = log(cos(standardLatitude1) / cos(standardLatitude2)) / log(sn)
        var sf = tan(Double.pi * 0.25 + standardLatitude1 * 0.5)
        sf = pow(sf, sn) * cos(standardLatitude1) / sn
        var ro = tan(Double.pi * 0.25 + originLatitude * 0.5)
        ro = earthRadiusByGridSize * sf / pow(ro, sn)
        var rs = GeoSearchInfo(latitude: 0, longtitude: 0, xGrid: 0, yGRid: 0)

        if mode == .toGrid {
            rs.latitude = yComponent
            rs.longtitude = xComponent
            var ra = tan(Double.pi * 0.25 + (yComponent) * degreeToRadianFactor * 0.5)
            ra = earthRadiusByGridSize * sf / pow(ra, sn)
            var theta = xComponent * degreeToRadianFactor - originLongtitude
            if theta > Double.pi {
                theta -= 2.0 * Double.pi
            }
            if theta < -Double.pi {
                theta += 2.0 * Double.pi
            }

            theta *= sn
            rs.xGrid = Int(floor(ra * sin(theta) + originXGrid + 0.5))
            rs.yGRid = Int(floor(ro - ra * cos(theta) + originYGrid + 0.5))
        }
        else if mode == .toCoordinate {
            rs.xGrid = Int(xComponent)
            rs.yGRid = Int(yComponent)
            let xn = xComponent - originXGrid
            let yn = ro - yComponent + originYGrid
            var ra = sqrt(xn * xn + yn * yn)
            if sn < 0.0 {
                ra = -ra
            }
            var alat = pow((earthRadiusByGridSize * sf / ra), (1.0 / sn))
            alat = 2.0 * atan(alat) - Double.pi * 0.5

            var theta = 0.0
            if abs(xn) <= 0.0 {
                theta = 0.0
            } else {
                if abs(yn) <= 0.0 {
                    theta = Double.pi * 0.5
                    if xn < 0.0 {
                        theta = -theta
                    }
                } else {
                    theta = atan2(xn, yn)
                }
            }
            let alon = theta / sn + originLongtitude
            rs.latitude = alat * radianTodegreeFactor
            rs.longtitude = alon * radianTodegreeFactor
        }
        return rs
    }

    struct GeoSearchInfo {
        public var latitude: Double
        public var longtitude: Double

        public var xGrid: Int
        public var yGRid: Int
    }
}
