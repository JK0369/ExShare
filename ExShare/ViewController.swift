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
  private let myPublichSubject = PublishSubject<String>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    subscribeUsingShareBuffer()
  }
  
  private func subscribeUsingSubject() {
    API.requestSomeAPI()
      .bind { [weak self] in self?.myPublichSubject.onNext($0) }
      .disposed(by: self.disposeBag)

    myPublichSubject
      .bind { _ in print("구독1!") }
      .disposed(by: self.disposeBag)

    myPublichSubject
      .bind { _ in print("구독2!") }
      .disposed(by: self.disposeBag)

    myPublichSubject
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
  
  private func subscribeUsingShare() {
    let requestObservable = API.requestSomeAPI().share()
    requestObservable
      .bind { _ in print("구독1!") }
      .disposed(by: self.disposeBag)

    requestObservable
      .bind { _ in print("구독2!") }
      .disposed(by: self.disposeBag)

    requestObservable
      .bind { _ in print("구독3!") }
      .disposed(by: self.disposeBag)

    /*
     request 카운트 1
     구독1!
     구독2!
     구독3!
     */
  }
  
  private var disposeBagFirst = DisposeBag()
  private var disposeBagSecond = DisposeBag()
  private var disposeBagThird = DisposeBag()
  private func subscribeUsingShareBuffer() {
    let requestObservable = API.requestSomeAPI().share(replay: 1, scope: .whileConnected)
    
    requestObservable
      .bind { _ in print("구독1!") }
      .disposed(by: self.disposeBagFirst)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.disposeBagFirst = DisposeBag()
      requestObservable
        .bind { _ in print("구독2!") }
        .disposed(by: self.disposeBagSecond)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() +  6) {
      self.disposeBagSecond = DisposeBag()
      requestObservable
        .bind { _ in print("구독3!") }
        .disposed(by: self.disposeBagThird)
    }
    
    /*
     request 카운트 1
     구독1!
     구독2!
     구독3!
     */
  }
}
