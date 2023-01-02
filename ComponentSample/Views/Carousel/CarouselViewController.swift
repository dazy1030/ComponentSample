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
    /// セルが初回表示かどうかのフラグ。
    private var isFirstAppear = true
    /// 無限スクロールさせるかのフラグ。
    private var isInfiniteScroll = true
    private let lineSpacing = 16.0
    
    @IBOutlet private weak var carouselCollectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout.centerAligned
            // 横スクロールを指定。
            layout.scrollDirection = .horizontal
            // 仕様通りに隙間を指定。
            layout.minimumLineSpacing = lineSpacing
            carouselCollectionView.collectionViewLayout = layout
            // インジケータを非表示。
            carouselCollectionView.showsHorizontalScrollIndicator = false
            // スクロール後の減速を高速に設定。
            carouselCollectionView.decelerationRate = .fast
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // 画面サイズによって無限スクロールが有効化切り替わる場合があるためリロードする。
        carouselCollectionView.reloadData()
    }
    
    private func setup() {
        title = "Carousel"
        carouselCollectionView.backgroundColor = nil
        view.backgroundColor = .systemGroupedBackground
    }
    
    /// 仕様通りのセルの幅を計算する。
    private func calcItemWidth(fromCollectionViewWidth collectionViewWidth: CGFloat) -> CGFloat {
        if collectionViewWidth < 375 {
            return 280 * collectionViewWidth / 375
        } else {
            return 280
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionViewWidth = collectionView.frame.width
        let itemWidth = calcItemWidth(fromCollectionViewWidth: collectionViewWidth)
        if CGFloat(items.count) * itemWidth + CGFloat(items.count - 1) * lineSpacing <= collectionViewWidth {
            // 全てのアイテムが画面内に収まる場合は無限スクロールさせない。
            isInfiniteScroll = false
            return items.count
        } else {
            // 無限スクロールで前後をつなげるために、前と後ろに同じものを表示させる。
            isInfiniteScroll = true
            return items.count * 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: items[indexPath.row % items.count])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        return CGSize(width: calcItemWidth(fromCollectionViewWidth: collectionViewWidth), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 無限スクロールでない時にもセルを中央に表示するための処理。
        guard !isInfiniteScroll else { return .zero }
        let itemWidth = calcItemWidth(fromCollectionViewWidth: collectionView.frame.width)
        // 左右の端のアイテムが中央表示されるインセット。
        let inset = (collectionView.frame.width - itemWidth) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // セルの初回表示時はページングの中央表示がされていないので中央に寄せる。
        guard isInfiniteScroll, isFirstAppear, indexPath.row == 0 else { return }
        collectionView.scrollToItem(at: IndexPath(row: items.count, section: 0), at: .centeredHorizontally, animated: false)
        isFirstAppear = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isInfiniteScroll else { return }
        // 真ん中のグループ以外の時は真ん中へスクロールさせる。
        let groupWidth = scrollView.contentSize.width / 3
        if scrollView.contentOffset.x < groupWidth {
            // 左のグループの時。
            scrollView.contentOffset.x += groupWidth
        } else if scrollView.contentOffset.x > groupWidth * 2 {
            // 右のグループの時。
            scrollView.contentOffset.x -=  groupWidth
        }
    }
}
