// 
// Copyright 2024 New Vector Ltd
//
// SPDX-License-Identifier: AGPL-3.0-only
// Please see LICENSE in the repository root for full details.
//

import SwiftUI

/// The button component for sending messages and media.
public struct SendButton: View {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    
    /// The action to perform when the user triggers the button.
    public let action: () -> Void
    
    private var iconColor: Color { isEnabled ? .compound.iconOnSolidPrimary : .compound.iconQuaternary }
    private var gradient: Gradient { isEnabled ? Color.compound.gradientSendButton : .init(colors: [.clear]) }
    private var colorSchemeOverride: ColorScheme { isEnabled ? .light : colorScheme }
    
    /// Creates a send button that performs the provided action.
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            CompoundIcon(\.sendSolid, size: .medium, relativeTo: .compound.headingLG)
                .foregroundStyle(iconColor)
                .scaledPadding(6, relativeTo: .compound.headingLG)
                .background { buttonShape }
                .environment(\.colorScheme, colorSchemeOverride)
                .compositingGroup()
        }
    }
    
    var buttonShape: some View {
        Circle()
            .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
            .overlay {
                Circle()
                    .fill(EllipticalGradient(gradient: gradient))
                    .opacity(0.4)
                    .blendMode(.overlay)
            }
    }
}

// MARK: - Previews

import Prefire

public struct SendButton_Previews: PreviewProvider, PrefireProvider {
    public static var previews: some View {
        VStack(spacing: 0) {
            states
                .padding(20)
                .background(.compound.bgCanvasDefault)
            states
                .padding(20)
                .background(.compound.bgCanvasDefault)
                .environment(\.colorScheme, .dark)
        }
        .cornerRadius(20)
    }
    
    public static var states: some View {
        HStack(spacing: 30) {
            SendButton { }
                .disabled(true)
            SendButton { }
        }
    }
}
