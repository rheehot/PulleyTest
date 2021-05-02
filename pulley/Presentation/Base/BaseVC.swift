//
//  BaseVC.swift
//  pulley
//
//  Created by eli on 2021/05/01.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class BaseVC: UIViewController {
    // MARK: Properties
    private(set) var didMakeConstraints = false
    var disposeBag = DisposeBag()

    // MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.setNeedsUpdateConstraints()
    }

    // MARK: Layout
    func makeConstraints() {
        // override point
    }

    override func updateViewConstraints() {
        if !self.didMakeConstraints {
            self.makeConstraints()
            self.didMakeConstraints = true
        }

        super.updateViewConstraints()
    }
}
