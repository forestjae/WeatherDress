//
//  NetworkingError.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

enum NetworkingError: Error {
    case serverError
    case invalidResponse
    case invalidData
    case parsingError
}
