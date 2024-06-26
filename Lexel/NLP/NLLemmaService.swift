//
//  NLLemmaService.swift
//  Lexel
//
//  Created by enzo on 6/9/24.
//

import Foundation
import NaturalLanguage
import OSLog

typealias Lemma = String

protocol ILemmatize {
    func lemmatize(word: String) -> Lemma?
}

class NLLemmaService : ILemmatize {
    
    /// Determines the lemma of the given word
    ///
    /// - Parameters
    ///     - word: The word to be lemmatized
    /// - Returns: The lemma of the given word
    func lemmatize(word: String) -> Lemma? {
        let tagger = NLTagger(tagSchemes: [.lemma])
        let range = word.startIndex..<word.endIndex
        tagger.string = word
        
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
        var ret: Lemma? = nil
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, range in
            if let tag = tag {
                os_log("\(word) : \(tag.rawValue)")
                ret = tag.rawValue
            }
            return true
        }
        
        return ret

    }
}

enum LexelLemmaError : Error {
   case lemmatizationFailed(String)
}
