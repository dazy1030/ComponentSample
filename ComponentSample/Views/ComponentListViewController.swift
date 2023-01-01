//
//  ComponentListViewController.swift
//  ComponentSample
//
//  Created by 小田島 直樹 on 2022/12/31.
//

import UIKit

extension ComponentListViewController {
    enum Section {
        case components
    }
    
    enum Item: Identifiable, CaseIterable {
        case carousel
        
        var name: String {
            switch self {
            case .carousel: return "Carousel"
            }
        }
        
        var id: String {
            name
        }
    }
}

final class ComponentListViewController: UIViewController {
    private let components = Item.allCases
    
    @IBOutlet private weak var componentListCollectionView: UICollectionView! {
        didSet {
            let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let layout = UICollectionViewCompositionalLayout.list(using: configuration)
            componentListCollectionView.collectionViewLayout = layout
            componentListCollectionView.delegate = self
        }
    }
    
    typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    private let cellRegistration = ListCellRegistration { cell, _, item in
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = item.name
        cell.contentConfiguration = contentConfiguration
        cell.accessories = [.disclosureIndicator()]
    }
    
    typealias ListDataSource = UICollectionViewDiffableDataSource<Section, Item>
    private lazy var componentDataSource = ListDataSource(collectionView: componentListCollectionView) { [unowned self] collectionView, indexPath, item in
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.components])
        snapshot.appendItems(components)
        componentDataSource.apply(snapshot)
    }
    
    private func setup() {
        title = "Components"
        view.backgroundColor = .systemGroupedBackground
    }
}

// MARK: - UICollectionViewDelegate

extension ComponentListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let component = components[indexPath.row]
        let viewController: UIViewController
        switch component {
        case .carousel:
            let carouselVC: CarouselViewController = .instantiateFromStoryboard()
            viewController = carouselVC
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
