//
//  RealmService.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import Foundation
import RxSwift
import RealmSwift

class RealmService: LocalDatabaseService {
    let manager: RealmManager

    init?() {
        guard let manager = RealmManager.shared else {
            return nil
        }
        self.manager = manager
    }

    func fetch() -> [LocationInfo] {
        let result = self.manager.fetch(object: StorableLocationInfo.self)
        let locations = result.compactMap { LocationInfo($0) } as [LocationInfo]
        return locations
    }

    func create(_ location: LocationInfo) -> Completable {
        return Completable.create { completable in
            self.manager.create(location.storable()) { result in
                switch result {
                case .success:
                    completable(.completed)
                case .failure(let error):
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func delete(_ location: LocationInfo) -> Completable {
        return Completable.create { completable in
            guard let predicate = self.manager.fetch(object: StorableLocationInfo.self)
                    .where({ $0.identifer == location.identifier.uuidString }).first
            else {
                return Disposables.create()
            }
            self.manager.delete(predicate) { result in
                switch result {
                case .success:
                    completable(.completed)
                case .failure(let error):
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}

private extension LocationInfo {
    private var storableLocationInfo: StorableLocationInfo {
        let storableAddress = StorableAddress()
        storableAddress.fullAddress = self.address.fullAddress
        storableAddress.firstRegion = self.address.firstRegion
        storableAddress.secondRegion = self.address.secondRegion
        storableAddress.thirdRegion = self.address.thirdRegion ?? ""
        storableAddress.fourthRegion = self.address.fourthRegion ?? ""
        let storableLocationInfo = StorableLocationInfo()
        storableLocationInfo.identifer = self.identifier.uuidString
        storableLocationInfo.longtitude = self.longtitude
        storableLocationInfo.latitude = self.latitude
        storableLocationInfo.address = storableAddress

        return storableLocationInfo
    }

    func storable() -> StorableLocationInfo {
        return self.storableLocationInfo
    }

    init?(_ storableLocationInfo: StorableLocationInfo) {
        guard let address = storableLocationInfo.address,
              let identifer = UUID(uuidString: storableLocationInfo.identifer) else {
            return nil
        }
        self.identifier = identifer
        self.longtitude = storableLocationInfo.longtitude
        self.latitude = storableLocationInfo.latitude
        self.address = Address(
            fullAddress: address.fullAddress,
            firstRegion: address.firstRegion,
            secondRegion: address.secondRegion,
            thirdRegion: address.thirdRegion,
            fourthRegion: address.fourthRegion
        )
    }
}
