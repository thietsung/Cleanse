//
//  TaggedProvider.swift
//  Cleanse
//
//  Created by Mike Lewis on 5/3/16.
//  Copyright © 2016 Square, Inc. All rights reserved.
//

import Foundation

public struct TaggedProvider<Tag: Cleanse.Tag> : ProviderProtocol {
    public typealias Element = Tag.Element

    let getter: () -> Element
    
    public init(getter: () -> Element) {
        self.getter = getter
    }

    public func get() -> Element {
        return getter()
    }
}

protocol AnyTaggedProvider : AnyProvider {
    static var tag: _AnyTag.Type  { get }
}

extension TaggedProvider : AnyTaggedProvider {
    static func makeNew(getter getter: () -> Any) -> AnyProvider {
        return TaggedProvider(getter: { getter() as! Element })
    }
    
    /// Cannot be represented w/o tags
    var anyGetterProvider: AnyProvider? {
        return nil
    }
    
    static var tag: _AnyTag.Type {
        return Tag.self
    }
}

extension TaggedProvider : ProviderConvertible {
    public func asProvider() -> Provider<Element> {
        return Provider(getter: self.getter)
    }
}

extension TaggedProvider : ProxyFactoryInitializable {
    static func makeProxyObject<F : ProxyFactory>(proxyFactory proxyFactory: F) -> TaggedProvider<Tag> {
        return TaggedProvider { proxyFactory.of() }
    }
}

