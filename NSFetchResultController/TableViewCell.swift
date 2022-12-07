//
//  TableViewCell.swift
//  NSFetchResultController
//
//  Created by Даша Волошина on 6.12.22.
//

import UIKit

class TableViewCell: UITableViewCell {
 static let id = "TableViewCell"
    let labelName = UILabel()
    let labelSurName = UILabel()
    let labelBirthday = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        
        contentView.addSubview(labelName)
        contentView.addSubview(labelSurName)
        contentView.addSubview(labelBirthday)
        
        
        labelName.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
        }
        labelSurName.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(240)
            make.top.equalToSuperview().inset(10)
        }
        labelBirthday.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
