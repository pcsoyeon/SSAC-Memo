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
    
    var titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 1
    }
    
    private var dateLabel = UILabel().then {
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 12, weight: .thin)
        $0.numberOfLines = 1
    }
    
    var contentLabel = UILabel().then {
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 1
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    // MARK: - Property
    
    private lazy var dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
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
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(80)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Custom Metod
    
    private func calculateLabelWidth(text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.sizeToFit()
        return label.frame.width
    }
    
    private func customDateFormatter(date: Date) -> String {
        let timeInterval = Date().timeIntervalSince(date) / 86400
        
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "aa hh:mm"
        } else if timeInterval >= 1 && timeInterval <= 7 {
            dateFormatter.dateFormat = "EEEE"
        } else {
            dateFormatter.dateFormat = "yyyy.MM.dd aa hh:mm:ss"
        }
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Data
    
    func setData(_ data: Memo) {
        titleLabel.text = data.memoTitle
        
        dateLabel.text = customDateFormatter(date: data.memoDate)
        
        dateLabel.snp.updateConstraints { make in
            make.width.equalTo(calculateLabelWidth(text: dateFormatter.string(from: data.memoDate)))
        }
        
        contentLabel.text = data.memoContent
    }
}
