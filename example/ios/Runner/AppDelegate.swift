/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

import Flutter
import flutter_callkit_voximplant

@UIApplicationMain
final class AppDelegate: FlutterAppDelegate {
    private let callKitPlugin = FlutterCallkitPlugin.sharedInstance

    @UserDefault("blockedNumbers", defaultValue: [])
    private var blockedNumbers: [BlockableNumber]

    @UserDefault("identifiedNumbers", defaultValue: [])
    private var identifiedNumbers: [IdentifiableNumber]

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        callKitPlugin.getBlockedPhoneNumbers = { [weak self] in
            guard let self = self else { return [] }
            return self.blockedNumbers.compactMap {
                if $0.isRemoved {
                    return nil
                } else {
                    return FCXCallDirectoryPhoneNumber(number: $0.number)
                }
            }
        }

        callKitPlugin.didAddBlockedPhoneNumbers = { [weak self] numbers in
            guard let self = self else { return }
            self.blockedNumbers.append(
                contentsOf: numbers.map { BlockableNumber(blockableNumber: $0) }
            )
            self.blockedNumbers.sort()
        }
        
        callKitPlugin.didRemoveBlockedPhoneNumbers = { [weak self] numbers in
            guard let self = self else { return }
            self.blockedNumbers = self.blockedNumbers.map { number in
                if numbers.contains(where: { $0.number == number.number }) {
                    return number.copyWithRemovalMark
                } else {
                    return number
                }
            }
        }

        callKitPlugin.getIdentifiablePhoneNumbers = { [weak self] in
            guard let self = self else { return [] }
            return self.identifiedNumbers.compactMap {
                if $0.isRemoved {
                    return nil
                } else {
                    return FCXIdentifiablePhoneNumber(number: $0.number, label: $0.label)
                }
            }
        }

        callKitPlugin.didAddIdentifiablePhoneNumbers = { [weak self] numbers in
            guard let self = self else { return }
            self.identifiedNumbers.append(
                contentsOf: numbers.map { IdentifiableNumber(identifiableNumber: $0) }
            )
            self.identifiedNumbers.sort()
        }

        callKitPlugin.didRemoveIdentifiablePhoneNumbers = { [weak self] numbers in
            guard let self = self else { return }
            self.identifiedNumbers = self.identifiedNumbers.map { number in
                if numbers.contains(where: { $0.number == number.number }) {
                    return number.copyWithRemovalMark
                } else {
                    return number
                }
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

fileprivate extension BlockableNumber {
    init(blockableNumber: FCXCallDirectoryPhoneNumber, removed: Bool = false) {
        self.number = blockableNumber.number
        self.modificationDate = Date()
        self.isRemoved = removed
    }

    var copyWithRemovalMark: BlockableNumber {
        BlockableNumber(
            number: number,
            modificationDate: Date(),
            isRemoved: true
        )
    }
}

fileprivate extension IdentifiableNumber {
    init(identifiableNumber: FCXIdentifiablePhoneNumber, removed: Bool = false) {
        self.number = identifiableNumber.number
        self.label = identifiableNumber.label
        self.modificationDate = Date()
        self.isRemoved = removed
    }

    var copyWithRemovalMark: IdentifiableNumber {
        IdentifiableNumber(
            number: number,
            label: label,
            modificationDate: Date(),
            isRemoved: true
        )
    }
}
