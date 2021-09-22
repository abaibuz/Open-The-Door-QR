//
//  MyExtension.swift
//  Open the Door(QR)
//
//  Created by Baibuz Oleksandr on 21.09.2021.
//

import Foundation
import UIKit
import MessageUI

extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
    
    //-------------
    func substring(fromIndex: Int, toIndex: Int) -> String? {
        if fromIndex < toIndex && toIndex <= self.count /*use string.characters.count for swift3*/{
            let startIndex = self.index(self.startIndex, offsetBy: fromIndex)
            let endIndex = self.index(self.startIndex, offsetBy: toIndex)
            return String(self[startIndex..<endIndex])
        }else{
            return nil
        }
    }


}
