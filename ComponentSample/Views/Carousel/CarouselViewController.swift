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
    enum Item: CaseIterable {
        case red
        case orange
        case yellow
        case green
        case blue
        case indigo
        case purple
        
        var color: UIColor {
            switch self {
            case .red: return .systemRed
            case .orange: return .systemOrange
            case .yellow: return .systemYellow
            case .green: return .systemGreen
            case .blue: return .systemBlue
            case .indigo: return .systemIndigo
            case .purple: return .systemPurple
            }
        }
    }
    
    private let items = Item.allCases
    
    @IBOutlet private weak var carouselCollectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            // 横スクロールを指定。
            layout.scrollDirection = .horizontal
            // 仕様通りに隙間を指定。
            layout.minimumLineSpacing = 16.0
            carouselCollectionView.collectionViewLayout = layout
            // インジケータを非表示。
            carouselCollectionView.showsHorizontalScrollIndicator = false
            carouselCollectionView.dataSource = self
            carouselCollectionView.delegate = self
        }
    }
    /// 表示するセルの設定を行う。
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, _, item in
        cell.contentView.backgroundColor = item.color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "Carousel"
        carouselCollectionView.backgroundColor = nil
        view.backgroundColor = .systemGroupedBackground
    }
}

// MARK: - UICollectionViewDataSource

extension CarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: items[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 仕様通りのセルのサイズを指定。
        let collectionViewWidth = collectionView.frame.width
        let cellWidth: CGFloat
        if collectionViewWidth < 375 {
            cellWidth = 280 * collectionViewWidth / 375
        } else {
            cellWidth = 280
        }
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
}
