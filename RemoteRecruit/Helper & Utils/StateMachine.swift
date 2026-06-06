//
//  StateMachine.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//


enum StateMachine: Equatable {
    case idle
    case loading
    case empty
    case success
    case failure(String)
}
