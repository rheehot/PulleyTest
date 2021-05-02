//
//  UIImagePickerViewController+RxCreate.swift
//  pulley
//
//  Created by eli on 2021/05/01.
//

import RxSwift
import RxCocoa
import UIKit

final class RxImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, UINavigationControllerDelegate & UIImagePickerControllerDelegate>, DelegateProxyType, UINavigationControllerDelegate & UIImagePickerControllerDelegate {

    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }

    static func registerKnownImplementations() {
        self.register { RxImagePickerDelegateProxy(parentObject: $0, delegateProxy: RxImagePickerDelegateProxy.self) }
     }
}

extension Reactive where Base: UIImagePickerController {

    var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
        return RxImagePickerDelegateProxy.proxy(for: base)
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
    }
}

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
