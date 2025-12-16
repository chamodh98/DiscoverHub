//
//  ViewModel.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-16.
//

import Foundation

protocol ViewModel: ObservableObject {
    associatedtype Service
    var service: Service { get }
    func load() async
}
