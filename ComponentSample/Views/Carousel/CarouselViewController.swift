//
//  CarouselViewController.swift
//  ComponentSample
//
//  Created by 小田島 直樹 on 2023/01/01.
//

import UIKit

/// カルーセルUIとは、複数のビューをページング（しないものもある）横スクロールで表示するUI。
/// # 仕様
/// - ページングして中途半端な状態でスクロールが止まらない。
/// - 先頭と最後のビューは隣り合っていて無限にスクロールできる。
/// - 前と次のビューの端が見えている。
/// - UIPageControlでページの番目を表示する。
/// - 表示するのは、赤・橙・黃・緑・青・藍・紫それぞれの単色で塗った7つのビュー。
/// - 画面幅が375pxで一つビューのサイズが280x192（35:24）。
/// - 画面幅が375px以下の時は一つのビューのサイズを35:24で維持したままスケールさせる。
/// - 画面幅が375px以上の時は一つのビューのサイズはそのままで、カルーセル全体の横幅を伸ばす。
/// - ビュー間の隙間は16px。
final class CarouselViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "Carousel"
        view.backgroundColor = .systemGroupedBackground
    }
}
