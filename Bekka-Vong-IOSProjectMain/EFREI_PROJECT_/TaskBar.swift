import UIKit

class TaskBar: UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
     var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 65
     return sizeThatFits
    }

}
