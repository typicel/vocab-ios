//
//  NLLemmaService.swift
//  Lexel
//
//  Created by enzo on 6/9/24.
//

import Foundation
import NaturalLanguage

typealias Lemma = String

protocol ILemmatize {
    func lemmatize(word: String) -> Lemma
}

class NLLemmaService : ILemmatize {
    
    /// Determines the lemma of the given word
    ///
    /// - Parameters
    ///     - word: The word to be lemmatized
    /// - Returns: The lemma of the given word
    func lemmatize(word: String) -> Lemma {
        print("lemmatizing \(word)")
        
        let tagger = NLTagger(tagSchemes: [.lemma])
        let range = word.startIndex..<word.endIndex
        tagger.string = word
        
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
        var ret: String = word
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, range in
            if let tag = tag {
                ret = tag.rawValue
            }
            return true
        }
        
        print("\(word): \(ret)")
        return ret
        
    }
}