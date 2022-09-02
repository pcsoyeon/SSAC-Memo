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
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.numberOfLines = 1
    }
    
    private var labelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 10
        $0.alignment = .fill
    }
    
    private var dateLabel = UILabel().then {
        $0.text = "날짜"
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 12, weight: .thin)
        $0.numberOfLines = 1
    }
    
    private var contentLabel = UILabel().then {
        $0.text = "내용"
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 12, weight: .thin)
        $0.numberOfLines = 1
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = .systemGray2
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
        contentView.addSubviews([titleLabel, labelStackView, lineView])
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(contentLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
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
