//
//  RootViewController.swift
//  ComponentSample
//
//  Created by 小田島 直樹 on 2022/12/31.
//

import UIKit

extension RootViewController {
    enum Section {
        case components
    }
    
    enum Item: Identifiable, CaseIterable {
        case sample
        
        var name: String {
            switch self {
            case .sample: return "Sample"
            }
        }
        
        var id: String {
            name
        }
    }
}

final class RootViewController: UIViewController {
    @IBOutlet private weak var componentCollectionView: UICollectionView! {
        didSet {
            let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let layout = UICollectionViewCompositionalLayout.list(using: configuration)
            componentCollectionView.collectionViewLayout = layout
            componentCollectionView.delegate = self
        }
    }
    
    typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    private let cellRegistration = ListCellRegistration { cell, _, item in
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = item.name
        cell.contentConfiguration = contentConfiguration
        cell.accessories = [.disclosureIndicator()]
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private lazy var componentDataSource = DataSource(collectionView: componentCollectionView) { [unowned self] collectionView, indexPath, item in
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.components])
        snapshot.appendItems(Item.allCases)
        componentDataSource.apply(snapshot)
    }
    
    private func setup() {
        title = "Components"
        view.backgroundColor = .systemGroupedBackground
    }
}

// MARK: - UICollectionViewDelegate

extension RootViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
