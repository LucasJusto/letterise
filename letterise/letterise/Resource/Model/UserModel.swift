//
//  UserModel.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 02/12/23.
//

import Foundation

struct UserModel: Identifiable {
    let id: Int
    let iCloudID: String
    var credits: Int
}
