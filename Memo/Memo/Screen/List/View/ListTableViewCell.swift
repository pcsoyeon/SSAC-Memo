//
//  ListTableViewCell.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

final class ListTableViewCell: UITableViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.numberOfLines = 1
    }
    
    private var dateLabel = UILabel().then {
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 12, weight: .thin)
        $0.numberOfLines = 1
    }
    
    private var contentLabel = UILabel().then {
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 12, weight: .thin)
        $0.numberOfLines = 1
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureUI() {
        contentView.backgroundColor = .foreground
    }
    
    private func setConstraints() {
        contentView.addSubviews([titleLabel, contentLabel, dateLabel, lineView])
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.trailing.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.bottom.equalToSuperview().inset(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Data
    
    func setData(_ data: Memo) {
        titleLabel.text = data.memoTitle
        
        dateLabel.text = "\(data.memoDate)"
        
        contentLabel.text = data.memoContent
    }
}
