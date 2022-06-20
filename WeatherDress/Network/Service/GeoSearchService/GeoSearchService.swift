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

    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }

    func coordinateToAddress(
        xCoordinate: Double,
        yCoordinate: Double
    ) -> Single<LocationInfo> {
        return Single.create { single in
            let request = GeocodeRequest(
                xCoordinate: xCoordinate,
                yCoordinate: yCoordinate
            )
            self.apiProvider.request(request) { result in
                switch result {
                case .success(let response):
                    guard let addressComponent = response.documents.first,
                          let locationInfo = LocationInfo(geocodeAddress: addressComponent)
                    else {
                        return
                    }
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
            let request = AddressSearchRequest(query: query)

            self.apiProvider.request(request) { result in
                switch result {
                case .success(let response):
                    let addressList = response.documents.compactMap { LocationInfo(searchedAddressSet: $0) }
                    single(.success(addressList))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
