//
//  HomeViewCellCollectionViewCell.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 11/05/21.
//

import UIKit

class HomeViewCellCollectionViewCell: UICollectionViewCell {
    
    
    var id: Int = 0
    
    //MARK: - Views
    private(set) var label: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .label
        label.numberOfLines = 3
        
        return label
    }()
    
    private(set) var releaseDate: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .label
        label.numberOfLines = 0
        
        return label
    }()
    
    private(set) var image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        return image
    }()
    
    private(set) var container: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:- Override Methods -
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupConstraints()
    }
    
    //MARK:- Methods -
    fileprivate func setupUIElements() {
        // arrange subviews
        backgroundColor = .clear
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.2
        
        self.addSubview(container)
        self.container.addSubview(image)
        self.container.addSubview(label)
        self.container.addSubview(releaseDate)
    }
    
    fileprivate func setupConstraints() {
        let guide = self.safeAreaLayoutGuide
        
        container.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.left.right.bottom.equalTo(guide)
        }
        
        image.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(container)
            ConstraintMaker.height.equalTo(container).multipliedBy(0.7)
            ConstraintMaker.width.equalTo(container)
        }
                
        label.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(container).offset(10)
            ConstraintMaker.top.equalTo(image.snp.bottom).offset(5)
            ConstraintMaker.width.equalTo(container).multipliedBy(0.7)
        }
        
        releaseDate.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(container).offset(10)
            ConstraintMaker.top.equalTo(label.snp.bottom)
            ConstraintMaker.width.equalTo(container).multipliedBy(0.7)
            ConstraintMaker.bottom.equalTo(container).offset(5)
        }
        
    }
}
