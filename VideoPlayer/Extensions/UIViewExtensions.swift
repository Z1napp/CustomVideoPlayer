//
//  UIViewExtensions.swift
//  VideoPlayer
//
//  Created by Vadym Piatkovskyi on 09.02.2022.
//

import Foundation
import UIKit.UIView

extension UIView {
    @discardableResult
    func subviewFromNib<T: UIView>() -> T? {
        guard let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        
        frame = view.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        return view
    }
}
