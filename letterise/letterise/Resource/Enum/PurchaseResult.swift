//
//  PurchaseResult.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 14/12/23.
//

import Foundation

enum PurchaseResult {
    case insufficientFunds
    case success(letterPackID: String)
    case genericError(String)
    case networkError
}
