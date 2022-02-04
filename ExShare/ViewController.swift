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
  private let button: UIButton = {
    let button = UIButton()
    button.setTitle("버튼", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    return button
  }()
  private var didTapButtonObservable: Observable<Void> {
    self.button.rx.tap.asObservable()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.button)
    self.button.translatesAutoresizingMaskIntoConstraints = false
    self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    
    self.subscribeUsingShareBuffer()
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
  
  private func subscribeUsingShareBuffer() {
    var count = 0
    let tapObservable = self.didTapButtonObservable
      .map { _ -> Int in
        count += 1
        return count
      }
      .share(replay: 2, scope: .forever)

    let firstSubscription = tapObservable
      .do(onNext: { print($0) })
      .subscribe()
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      firstSubscription.dispose() // <-
      print("두 번째 Subscriber 구독 시작!")
      tapObservable
        .do(onNext: { print($0) })
        .subscribe()
        .disposed(by: self.disposeBag)
    }
    
    
    /*
     request 카운트 1
     request 카운트 2
     request 카운트 3
     구독3!
     */
  }
}
