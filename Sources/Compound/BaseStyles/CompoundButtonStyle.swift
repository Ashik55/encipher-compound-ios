//
// Copyright 2022 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Prefire
import SwiftUI

public extension ButtonStyle where Self == CompoundButtonStyle {
    /// A button style that applies Compound design tokens to a button with various configuration options.
    /// - Parameter kind: The kind of button being shown such as primary or secondary.
    /// - Parameter size: The button size to use. Defaults to `large`.
    static func compound(_ kind: Self.Kind, size: Self.Size = .large) -> CompoundButtonStyle {
        CompoundButtonStyle(kind: kind, size: size)
    }
}

/// Default button style for standalone buttons.
public struct CompoundButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    
    var kind: Kind
    public enum Kind {
        /// A filled button usually representing the default action.
        case primary
        /// A stroked button usually representing alternate actions.
        case secondary
    }
    
    var size: Size
    public enum Size {
        /// A button that is a regular size.
        case medium
        /// A button that is prominently sized.
        case large
    }
    
    private var horizontalPadding: CGFloat { size == .large ? 12 : 7 }
    private var verticalPadding: CGFloat { size == .large ? 14 : 7 }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity)
            .font(.compound.bodyLGSemibold)
            .foregroundColor(textColor(role: configuration.role))
            .multilineTextAlignment(.center)
            .background {
                makeBackground(configuration: configuration)
            }
            .contentShape(Capsule())
    }
    
    @ViewBuilder
    private func makeBackground(configuration: Self.Configuration) -> some View {
        if kind == .primary {
            Capsule().fill(buttonColor(configuration: configuration))
        } else {
            Capsule().stroke(buttonColor(configuration: configuration))
        }
    }
    
    private func buttonColor(configuration: Self.Configuration) -> Color {
        guard isEnabled else { return .compound.bgActionPrimaryDisabled }
        if configuration.role == .destructive {
            return .compound.bgCriticalPrimary.opacity(configuration.isPressed ? 0.6 : 1)
        } else {
            return configuration.isPressed ? .compound.bgActionPrimaryPressed : .compound.bgActionPrimaryRest
        }
    }
    
    private func textColor(role: ButtonRole?) -> Color {
        if kind == .primary {
            return .compound.textOnSolidPrimary
        } else {
            guard isEnabled else { return .compound.textDisabled }
            return role == .destructive ? .compound.textCriticalPrimary : .compound.textActionPrimary
        }
    }
}

public struct CompoundButtonStyle_Previews: PreviewProvider, PrefireProvider {
    public static var previews: some View {
        ScrollView {
            Section {
                states(.large)
                    .padding(.bottom, 40)
            } header: {
                Text("Large")
                    .foregroundStyle(.compound.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
            }
            
            Section {
                states(.medium)
            } header: {
                Text("Medium")
                    .foregroundStyle(.compound.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
            }
        }
        .padding()
    }
    
    public static func states(_ size: CompoundButtonStyle.Size) -> some View {
        VStack {
            Button("Primary") { }
                .buttonStyle(.compound(.primary, size: size))
            
            Button("Destructive", role: .destructive) { }
                .buttonStyle(.compound(.primary, size: size))
            
            Button("Disabled") { }
                .buttonStyle(.compound(.primary, size: size))
                .disabled(true)
            
            Button("Secondary") { }
                .buttonStyle(.compound(.secondary, size: size))
            
            Button("Destructive", role: .destructive) { }
                .buttonStyle(.compound(.secondary, size: size))
            
            Button("Disabled") { }
                .buttonStyle(.compound(.secondary, size: size))
                .disabled(true)
        }
    }
}