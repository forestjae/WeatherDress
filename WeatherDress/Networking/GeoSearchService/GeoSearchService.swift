//
//  GeoSearchService.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation
import RxSwift

final class GeoSearchService {
    let apiProvider: APIProvider
    let serviceKey = Bundle.main.kakaoApiKey

    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }

    func coordinateToAddress(
        xCoordinate: Double,
        yCoordinate: Double
    ) -> Single<LocationInfo> {
        return Single.create { single in
            let request = GeocodeRequest(
                function: .geocode,
                xCoordinate: xCoordinate,
                yCoordinate: yCoordinate
            )
            self.apiProvider.request(request) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(GeocodeResponse.self, from: data) else { return }
                    guard let addressComponent = decoded.documents.first else { return }
                    guard let locationInfo = LocationInfo(geocodeAddress: addressComponent) else { return }
                    single(.success(locationInfo))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    func searchAddress(by query: String) -> Single<[LocationInfo]> {
        return Single.create { single in
            let request = AddressSearchRequest(function: .addressSearch, query: query)

            self.apiProvider.request(request) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(AddressSearchResponse.self, from: data) else { return }
                    let addressList = decoded.documents.compactMap { LocationInfo(searchedAddressSet: $0) }
                    single(.success(addressList))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
