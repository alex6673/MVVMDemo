//
//  UserTableViewCell.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/12.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

import UIKit

import FluidHighlighter
import Kingfisher
import RxSwift

final class UserTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 32.0;
        imageView.layer.masksToBounds = true;
        return imageView
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    private let siteadminLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .white
        label.backgroundColor = .purple
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        label.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false

        return label
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    private let hstackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .top
        view.spacing = 6
        view.axis = .horizontal
        return view
    }()

    private let vstackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .top
        view.spacing = 6

        view.axis = .vertical
        return view
    }()

    // MARK: - Con(De)structor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
        vstackView.addArrangedSubview(usernameLabel)
        vstackView.addArrangedSubview(siteadminLabel)

        hstackView.addArrangedSubview(avatarImageView)
        hstackView.addArrangedSubview(vstackView)
        
        contentView.addSubview(hstackView)
        contentView.addSubview(lineView)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        usernameLabel.text = nil
        avatarImageView.image = nil
    }
    
    // MARK: - Internal methods
    
    func configure(with model: GithubUser, index: Int) {
                
        fh.enable(normalColor: .white, highlightedColor: .green)
        
        usernameLabel.text = model.login
        usernameLabel.textColor = .black
        
        if let sa = model.site_admin, !sa {
            siteadminLabel.setTitle("STAFF", for: .normal)
        } else {
            siteadminLabel.removeFromSuperview()
        }
        
        avatarImageView.kf.setImage(with: URL(string: model.avatar_url!)!)
        
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        backgroundColor = .gray
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension UserTableViewCell {
    
    private func layout() {
        
        hstackView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        hstackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        hstackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true

        avatarImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        siteadminLabel.widthAnchor.constraint(equalToConstant: 64).isActive = true

        vstackView.centerYAnchor.constraint(equalTo: hstackView.centerYAnchor).isActive = true
        
        lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
    }
    
}
