//
//  BalanceTableViewCell.swift
//  HomeModule
//
//  Created by Gerald on 21/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import UIKit

class BalanceListTableViewCell: UITableViewCell {
    
    private struct Constants {
        
        static let cellId = "BalanceCollectionViewCell"
        
        static let cellSize = CGSize(width: 130, height: 60)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    var items: [CurrencyBalanceProtocol] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout();
        layout.itemSize = Constants.cellSize
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.collectionViewLayout = flowLayout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func configureCell(cell: BalanceCollectionViewCell, data: CurrencyBalanceProtocol){
        
        cell.balance = data.hm_formattedBalance
    }
    
}

// MARK: -
// MARK: UICollectionViewDataSource extension
extension BalanceListTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId,
                                                         for: indexPath) as? BalanceCollectionViewCell {
            let item = items[indexPath.row]
            configureCell(cell: cell, data: item)
            return cell
        }
        return UICollectionViewCell()
    }
}
