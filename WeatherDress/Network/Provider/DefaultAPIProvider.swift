//
//  APIProvider.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/03/29.
//

import Foundation

final class DefaultAPIProvider: APIProvider {
    let session = URLSession.shared

    func request<T: APIRequest>(
        _ request: T,
        completion: @escaping (Result<T.Response, NetworkingError>) -> Void
    ) {
        guard let urlRequest = request.urlReqeust else {
            return
        }

        let task = self.session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(.serverError))
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                      return completion(.failure(.invalidResponse))
                  }

            guard let data = data else {
                return completion(.failure(.invalidData))
            }

            let decoder = JSONDecoder()
            guard let decoded = try? decoder.decode(T.Response.self, from: data) else {
                return completion(.failure(.parsingError))
            }

            return completion(.success(decoded))
        }
        task.resume()
    }
}
