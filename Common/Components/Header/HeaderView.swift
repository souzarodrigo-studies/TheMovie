//
//  HeaderView.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 10/05/21.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    // MARK: - States
    
    

    // MARK: - Properties
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "10 de maio de 2021"
        label.textColor = .lightGray
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "Bem vindo"
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray
        
        return iv
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    
    private func configureUI() {
        
        profileImageView.setDimensions(width: 44, height: 44)
        profileImageView.layer.cornerRadius = 44 / 2
        
        addSubview(profileImageView)
        addSubview(welcomeLabel)
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { ConstraintMaker in
            ConstraintMaker.top.equalTo(self).offset(20)
            ConstraintMaker.left.equalTo(self).offset(10)
        }
        
        welcomeLabel.snp.makeConstraints { ConstraintMaker in
            ConstraintMaker.top.equalTo(dateLabel.snp.bottom)
            ConstraintMaker.left.equalTo(self).offset(10)
        }
        
        profileImageView.snp.makeConstraints { ConstraintMaker in
            ConstraintMaker.top.equalTo(self).offset(30)
            ConstraintMaker.right.equalTo(self).offset(-10)
        }
        
    }
    
}
