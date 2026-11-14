//
//  StudyDeckIntent.swift
//  IntentsFeature
//
//  Created by Vladimir Gusev on 19.09.2026.
//

public import AppIntents
import Foundation
#if os(iOS)
private import UIKit
#endif

/// "Study Korean in Amgi" — opens the app straight into the reviewer.
public struct StudyDeckIntent: AppIntent {
    public init() {}

    public static let title: LocalizedStringResource = "Study Deck"
    public static let description = IntentDescription(
        "Opens Amgi and starts reviewing a deck.",
        categoryName: "Review"
    )
    public static let openAppWhenRun = true

    @Parameter(title: "Deck")
    public var deck: AmgiDeckEntity

    public static var parameterSummary: some ParameterSummary {
        Summary("Study \(\.$deck)")
    }

    public func perform() async throws -> some IntentResult {
        guard let deckId = deck.deckId,
              let url = URL(string: "amgi://review?deckId=\(deckId)")
        else { throw AmgiIntentError.badDeckId }
        #if os(iOS)
        await MainActor.run {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        #endif
        return .result()
    }
}
