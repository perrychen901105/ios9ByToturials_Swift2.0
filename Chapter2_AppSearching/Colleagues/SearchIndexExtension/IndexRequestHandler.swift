//
//  IndexRequestHandler.swift
//  SearchIndexExtension
//
//  Created by PerryChen on 10/20/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import CoreSpotlight

class IndexRequestHandler: CSIndexExtensionRequestHandler {

    override func searchableIndex(searchableIndex: CSSearchableIndex, reindexAllSearchableItemsWithAcknowledgementHandler acknowledgementHandler: () -> Void) {
        // Reindex all data with the provided index
        
        acknowledgementHandler()
    }

    override func searchableIndex(searchableIndex: CSSearchableIndex, reindexSearchableItemsWithIdentifiers identifiers: [String], acknowledgementHandler: () -> Void) {
        // Reindex any items with the given identifiers and the provided index
        
        acknowledgementHandler()
    }

}
