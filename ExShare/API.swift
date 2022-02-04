//
//  API.swift
//  ExShare
//
//  Created by 김종권 on 2022/02/04.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

enum API {
  private static var count = 0
  
  static func requestSomeAPI() -> Observable<String> {
    Single<String>.create { single in
      let params: [String: Any] = [
        "lon": 113,
        "lat": 23.1,
        "ac": 0,
        "unit": "metric",
        "output": "json",
        "tzshift": 0
      ]
      AF
        .request(
          "https://www.7timer.info/bin/astro.php",
          method: .get,
          parameters: params
        )
        .responseString { response in
          Self.count += 1
          print("request 카운트 \(Self.count)")
          switch response.result {
          case let .success(string):
            single(.success(string))
          case let .failure(error):
            single(.failure(error))
          }
        }
      
      return Disposables.create()
    }
    .asObservable()
  }
}

// https://www.7timer.info/bin/astro.php?lon=113.2&lat=23.1&ac=0&unit=metric&output=json&tzshift=0
