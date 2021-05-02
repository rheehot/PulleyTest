//
//  ImagePickerService.swift
//  pulley
//
//  Created by eli on 2021/05/01.
//

import RxSwift
import RxCocoa
import UIKit

protocol ImagePickerServiceType: AnyObject {
    func selectImage() -> Observable<UIImage?>
}

final class ImagePickerService: ImagePickerServiceType {
    // MARK: `ImagePickerServiceType` implementation
    func selectImage() -> Observable<UIImage?> {
        let controller = UIImagePickerController()
        let topViewController = UIApplication.topViewController()!
        topViewController.present(controller, animated: true, completion: nil)
        
        return controller.rx.didFinishPickingMediaWithInfo
            .map{ [weak controller] result in
                controller?.dismiss(animated: true)
                return result[.originalImage] as? UIImage
            }
    }
}
