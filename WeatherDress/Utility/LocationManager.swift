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

    private var locationPublisher = BehaviorSubject<CLLocation>(value: CLLocation())
    private var authorizationPublisher = BehaviorSubject<CLAuthorizationStatus>(value: .notDetermined)
    private var lastLocation: CLLocation?

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

    func authorizationStatus() -> Observable<CLAuthorizationStatus> {
        return self.authorizationPublisher
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.locationPublisher.onNext(CLLocation())
        case .authorizedAlways, .authorizedWhenInUse:
            self.manager.startUpdatingLocation()
        case .notDetermined:
            self.manager.requestWhenInUseAuthorization()
        default:
            self.locationPublisher.onNext(CLLocation())
        }
        self.authorizationPublisher.onNext(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else {
            return
        }

        if last.coordinate != self.lastLocation?.coordinate {
            self.locationPublisher.onNext(last)
            self.lastLocation = last
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            return self.locationPublisher.onError(LocationError.unexpected)
        }
        switch error.code {
        case .denied:
            self.lastLocation = nil
        case .locationUnknown:
            self.lastLocation = nil
        default:
            self.lastLocation = nil
        }
    }
}

enum LocationError: Error {
    case denied
    case unexpected
    case invalid
    case disabledService
}
