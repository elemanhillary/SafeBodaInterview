//
//  UITableView+.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation
import UIKit

extension UITableView {
    func register(_ cellClasses: UITableViewCell.Type...) {
        cellClasses.forEach { cellClass in
            register(UINib(nibName: cellClass.nameOfClass, bundle: nil), forCellReuseIdentifier: cellClass.nameOfClass)
        }
    }
    
    func configure<T: ConfigurableCells & UITableViewCell>(_ cellType: T.Type, with data: T.DataType, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue \(cellType)")
        }
        cell.build(with: data)
        return cell
    }
}
