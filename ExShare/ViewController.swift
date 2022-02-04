//
//  ViewController.swift
//  ExShare
//
//  Created by 김종권 on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let apiObservable = API.requestSomeAPI()

    apiObservable
      .bind { _ in print("구독1!") }
      .disposed(by: self.disposeBag)

    apiObservable
      .bind { _ in print("구독2!") }
      .disposed(by: self.disposeBag)

    apiObservable
      .bind { _ in print("구독3!") }
      .disposed(by: self.disposeBag)
      
    /*
    request 카운트 1
    구독1!
    request 카운트 2
    구독2!
    request 카운트 3
    구독3!
    */
  }
}
