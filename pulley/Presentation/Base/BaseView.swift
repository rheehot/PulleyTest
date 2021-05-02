//
//  BaseView.swift
//  pulley
//
//  Created by eli on 2021/05/01.
//

import UIKit
import Then
import SnapKit

class BaseView: UIView {
    // MARK: Properties
    private(set) var didMakeConstraints = false

    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout
    func makeConstraints() {
        // override point.
    }

    override func updateConstraints() {
        if !self.didMakeConstraints {
            self.makeConstraints()
            self.didMakeConstraints = true
        }

        super.updateConstraints()
    }
}
