/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

import Foundation
import CallKit

@available(iOSApplicationExtension 11.0, *)
final class CallDirectoryHandler: CXCallDirectoryProvider {
    @UserDefault("blockedNumbers", defaultValue: [])
    private var blockedNumbers: [BlockableNumber]

    @UserDefault("identifiedNumbers", defaultValue: [])
    private var identifiedNumbers: [IdentifiableNumber]

    @NullableUserDefault("lastUpdate")
    private var lastUpdate: Date?

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        // Check whether this is an "incremental" data request. If so, only provide the set of phone number blocking
        // and identification entries which have been added or removed since the last time this extension's data was loaded.
        // But the extension must still be prepared to provide the full set of data at any time, so add all blocking
        // and identification phone numbers if the request is not incremental.
        // To perform an incremental update, the 'lastUpdate' used (date of the previous update).
        if let lastUpdate = lastUpdate, context.isIncremental {
            addOrRemoveIncrementalBlockingPhoneNumbers(to: context, since: lastUpdate)
            addOrRemoveIncrementalIdentificationPhoneNumbers(to: context, since: lastUpdate)
        } else {
            addAllBlockingPhoneNumbers(to: context)
            addAllIdentificationPhoneNumbers(to: context)
        }

        lastUpdate = Date()

        context.completeRequest()
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve all phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        blockedNumbers.forEach {
            context.addBlockingEntry(withNextSequentialPhoneNumber: $0.number)
        }
    }

    private func addOrRemoveIncrementalBlockingPhoneNumbers(
        to context: CXCallDirectoryExtensionContext,
        since date: Date
    ) {
        // Retrieve any changes to the set of phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        blockedNumbers
            .filter { $0.modificationDate > date }
            .forEach {
                if $0.isRemoved {
                    context.removeBlockingEntry(withPhoneNumber: $0.number)
                } else {
                    context.addBlockingEntry(withNextSequentialPhoneNumber: $0.number)
                }
            }
        // Record the most-recently loaded set of blocking entries in data store for the next incremental load...
    }

    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        identifiedNumbers.forEach {
            context.addIdentificationEntry(
                withNextSequentialPhoneNumber: $0.number,
                label: $0.label
            )
        }
    }

    private func addOrRemoveIncrementalIdentificationPhoneNumbers(
        to context: CXCallDirectoryExtensionContext,
        since date: Date
    ) {
        // Retrieve any changes to the set of phone numbers to identify (and their identification labels) from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        identifiedNumbers
            .filter { $0.modificationDate > date }
            .forEach {
                if $0.isRemoved {
                    context.removeIdentificationEntry(withPhoneNumber: $0.number)
                } else {
                    context.addIdentificationEntry(
                        withNextSequentialPhoneNumber: $0.number,
                        label: $0.label
                    )
                }
            }
        // Record the most-recently loaded set of identification entries in data store for the next incremental load...
    }

}

@available(iOSApplicationExtension 11.0, *)
extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occurred while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }

}
