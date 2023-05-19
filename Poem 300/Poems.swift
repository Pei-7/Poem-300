//
//  Poems.swift
//  Poem 300
//
//  Created by 陳佩琪 on 2023/5/18.
//



import UIKit
import CodableCSV


struct Poems :Codable {
    let title: String
    let poet: String
    let organization: String
    let content: String
    let question: String
    let answer: String
}


extension Poems {
    static var data: [Self] {
        var array = [Self]()
        if let data = NSDataAsset(name: "poem300")?.data {
            let decoder = CSVDecoder {
                $0.headerStrategy = .firstLine
            }
            do {
                array = try decoder.decode([Self].self, from: data)
            } catch {
                print(error)
            }
        }
        return array
    }
}

