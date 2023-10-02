//
//  MusicProviderError.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import Foundation

enum MusicProviderError: Error {
    case fetchingItemsFailed
    case songHasNoPreview
}

extension MusicProviderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fetchingItemsFailed:
            return "Fetching music failed, please try again."
        case .songHasNoPreview:
            return "Selected song has no preview."
        }
    }
}
