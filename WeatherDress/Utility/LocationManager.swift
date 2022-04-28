//
//  LocationManager.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation
import CoreLocation
import RxSwift

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    private var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
        return manager
    }()
    private var locationPublisher = PublishSubject<CLLocation>()

    override init() {
        super.init()
        self.manager.delegate = self
    }

    func currentLocation() -> Observable<CLLocation> {
        guard CLLocationManager.locationServicesEnabled() else {
            return .error(LocationError.disabledService)
        }

        self.manager.startUpdatingLocation()
        return self.locationPublisher
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.locationPublisher.onError(LocationError.denied)
        case .authorizedAlways, .authorizedWhenInUse:
            self.manager.startUpdatingLocation()
        case .notDetermined:
            self.manager.requestWhenInUseAuthorization()
        default:
            self.locationPublisher.onError(LocationError.unexpected)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else { return }

        self.locationPublisher.onNext(last)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            return self.locationPublisher.onError(LocationError.unexpected)
        }
        switch error.code {
        case .denied:
            self.locationPublisher.onError(LocationError.denied)
        case .locationUnknown:
            self.locationPublisher.onError(LocationError.invalid)
        default:
            self.locationPublisher.onError(LocationError.unexpected)
        }
    }
}

enum LocationError: Error {
    case denied
    case unexpected
    case invalid
    case disabledService
}
