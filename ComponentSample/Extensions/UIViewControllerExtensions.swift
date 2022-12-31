//
//  UIViewControllerExtensions.swift
//  ComponentSample
//
//  Created by 小田島 直樹 on 2022/12/31.
//

import UIKit

extension UIViewController {
    /// 型と同じ名前のStoryboardファイルからインスタンスを生成する
    static func instantiateFromStoryboard<T>(creator: ((NSCoder) -> T?)? = nil) -> T where T: UIViewController {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateInitialViewController(creator: creator)!
    }
}
