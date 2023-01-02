//
//  UICollectionViewFlowLayoutExtension.swift
//  ComponentSample
//
//  Created by 小田島 直樹 on 2023/01/02.
//

import UIKit

extension UICollectionViewFlowLayout {
    /// スクロール後に中央止めするCollectionViewFlowLayout。
    final private class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
        // 指が離れた後にスクロールが完了する地点を決めるメソッド。
        override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            guard let collectionView = collectionView else { return proposedContentOffset }
            // 表示されている領域にあるものを中央に合わせるセルの候補として抽出。
            let expansionMargin = sectionInset.left + sectionInset.right
            let expandedVisibleRect = CGRect(x: collectionView.contentOffset.x - expansionMargin,
                                             y: 0,
                                             width: collectionView.bounds.width + (expansionMargin * 2),
                                             height: collectionView.bounds.height)
            guard var targetAttributes = layoutAttributesForElements(in: expandedVisibleRect)?.sorted(by: { $0.frame.minX < $1.frame.minX }) else {
                return proposedContentOffset
            }
            // スクロールの慣性の方向によって処理を変える。
            let nextAttributes: UICollectionViewLayoutAttributes?
            if velocity.x == 0 {
                // 指をその場で離した慣性なしの場合は近いセルを中央へ合わせる。
                nextAttributes = layoutAttributesForNearbyCenterX(in: targetAttributes, collectionView: collectionView)
            } else if velocity.x > 0 {
                // 慣性が右に残っている時は右方向で中央から一番近いセルを中央へ合わせる。
                targetAttributes = targetAttributes.filter { $0.center.x > expandedVisibleRect.midX }
                nextAttributes = targetAttributes.first
            } else {
                // 慣性が左に残っている時は左方向で中央から一番近いセルを中央へ合わせる。
                targetAttributes = targetAttributes.filter { $0.center.x < expandedVisibleRect.midX }
                nextAttributes = targetAttributes.last
            }
            guard let attributes = nextAttributes else { return proposedContentOffset }
            // 対象がヘッダーだった場合は先頭に合わせる。
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                return CGPoint(x: 0, y: collectionView.contentOffset.y)
            } else {
                let cellLeftMargin = (collectionView.bounds.width - attributes.bounds.width) * 0.5
                return CGPoint(x: attributes.frame.minX - cellLeftMargin, y: collectionView.contentOffset.y)
            }
        }
        
        /// コレクションビューの中央に最も近いレイアウトを返す。
        private func layoutAttributesForNearbyCenterX(in attributes: [UICollectionViewLayoutAttributes], collectionView: UICollectionView) -> UICollectionViewLayoutAttributes? {
            let screenCenterX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
            let result = attributes.reduce((attributes: nil as UICollectionViewLayoutAttributes?, distance: CGFloat.infinity)) { result, attributes in
                let distance = attributes.frame.midX - screenCenterX
                return abs(distance) < abs(result.distance) ? (attributes, distance) : result
            }
            return result.attributes
        }
    }
    
    static let centerAligned: UICollectionViewFlowLayout = CenterAlignedCollectionViewFlowLayout()
}
