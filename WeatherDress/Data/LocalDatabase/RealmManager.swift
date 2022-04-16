//
//  RealmManager.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import Foundation
import RealmSwift
import RxSwift

enum RealmError: Error {
    case createFailure
    case deleteFailure
}

class RealmManager {
    static let shared = RealmManager()
    let realm: Realm

    init?() {
        guard let realm = try? Realm() else { return nil }
        self.realm = realm
    }

    func fetch<T: Object>(object: T.Type) -> Results<T> {
        return self.realm.objects(T.self)
    }

    func create<T: Object>(_ object: T, completion: @escaping (Result<T, RealmError>) -> Void) {
        do {
            try self.realm.write({
                realm.add(object)
            })
            completion(.success(object))
        } catch {
            completion(.failure(RealmError.createFailure))
        }
    }

    func delete<T: Object>(_ object: T, completion: @escaping (Result<T, RealmError>) -> Void) {
        do {
            try self.realm.write({
                realm.delete(object)
            })
            completion(.success(object))
        } catch {
            completion(.failure(RealmError.deleteFailure))
        }
    }
}
