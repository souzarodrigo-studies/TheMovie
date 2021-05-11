//
//  HomeView.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 10/05/21.
//


import UIKit
import SnapKit
import RxCocoa

class HomeView: UIView {

    // MARK: - Properties
    
    lazy var headerView: HeaderView = {
        let view = HeaderView()
        return view
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeView.createSectionLayout(section: sectionIndex)
        })
        view.accessibilityLabel = "GridMoviesCollectionView"
        view.register(HomeViewCellCollectionViewCell.self, forCellWithReuseIdentifier: "MoviesGridCell")
        return view
    }()
    
    //MARK: - Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.accessibilityLabel = "MoviesGridView"
        
        setupUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Override Methods
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupConstraints()
    }
    
    // MARK: - Helpers
    
    fileprivate func setupUIElements() {
        // arrange subviews
        backgroundColor = .secondarySystemBackground
        collectionView.backgroundColor = .secondarySystemBackground
    }
    
    func setupConstraints() {
        
        self.addSubview(headerView)
        let guide = self.safeAreaLayoutGuide
        headerView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(guide)
            ConstraintMaker.top.equalTo(guide)
            ConstraintMaker.height.equalTo(80)
            ConstraintMaker.width.equalTo(self.bounds.width)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(headerView.snp.bottom)
            ConstraintMaker.bottom.left.right.equalToSuperview()
        }
    }
    
    /// Criar Collection layout para essa view
    /// - Parameter section: --
    /// - Returns: Retorna o layout montado da tela
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        
        // Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
                
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10)
        
        // Group
        // Vertical group
//        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .absolute(400)
//            ),
//            subitem: item,
//            count: 2
//        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(400)
            ),
            subitem: item,
            count: 1
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        return section
        
        
    }
    
}
