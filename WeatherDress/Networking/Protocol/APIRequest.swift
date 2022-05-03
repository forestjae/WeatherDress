//
//  APIRequest.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/03/29.
//

import Foundation

protocol APIRequest {
    associatedtype Response: APIResponse

    var method: HTTPMethod { get }
    var baseURL: URL? { get }
    var path: String { get }
    var url: URL? { get }
    var parameters: [String: String] { get }
    var headers: [String: String]? { get }
}

extension APIRequest {
    var url: URL? {
        guard let url = self.baseURL?.appendingPathComponent(self.path) else {
            return nil
        }
        var urlComponents = URLComponents(string: url.absoluteString)
        let urlQuries = self.parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        urlComponents?.percentEncodedQueryItems = urlQuries

        return urlComponents?.url
    }

    var urlReqeust: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        if let headers = self.headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }
}
