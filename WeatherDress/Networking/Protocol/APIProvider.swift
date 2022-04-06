//
//  APIProvider.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

protocol APIProvider {
    var session: URLSession { get }
    func request<T: APIRequest>(
        _ request: T,
        completion: @escaping (Result<Data, NetworkingError>) -> Void
    )
}
