//swiftlint:disable control_statement
import UIKit

// MARK: - Properties
public extension UIView {

    public var tableViewCell: UITableViewCell? {
        var tableViewcell: UIView? = self
        while(tableViewcell != nil) {
            if tableViewcell! is UITableViewCell {
                break
            }
            tableViewcell = tableViewcell!.superview
        }
        return tableViewcell as? UITableViewCell
    }

    public func tableViewIndexPathIn(_ tableView: UITableView) -> IndexPath? {
        if let cell = self.tableViewCell {
            return tableView.indexPath(for: cell) as IndexPath?
        } else {
            return nil
        }
    }
}
