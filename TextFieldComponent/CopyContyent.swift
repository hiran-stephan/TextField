//
//  CopyContyent.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 12/09/24.
//

import Foundation

/*
 Issue Overview:
 In the current implementation, we are using SwiftUI's presentationDetents to control the size of sheets. However, the behavior is inconsistent between iPhone and iPad, which affects how the UI is displayed.
 Details of the Problem:
     1    On iPhone: The presentationDetents modifier works as expected. It allows us to adjust the sheet height, presenting the sheet in different sizes such as .medium, .large, or custom fractions.
     2    On iPad (in Compact Size Class): When the iPad is in split view (or another compact size class situation), the presentationDetents behave similarly to iPhone, allowing us to present the sheet with adjustable heights.
     3    On iPad (Regular Size Class - Fullscreen): When the iPad is in full-screen mode, SwiftUI presents the sheet as a fullscreen dialog rather than a resizable sheet. This is a default behavior on iPad, and we currently do not have the ability to adjust the height of the sheet in regular size class/fullscreen mode.
 Impacts on User Experience:
     •    Inconsistent Presentation: On iPhone, the sheet behaves as intended with customizable heights, but on iPad, the user experiences a fullscreen modal, which may not align with the desired design of showing a partial sheet.
     •    No Control Over Sheet Height on iPad (Fullscreen Mode): We are unable to control or adjust the height of the sheet on iPads in fullscreen mode, leading to a UI experience that does not match the design intent of a resizable sheet.
 Next Steps / Design Considerations:
     •    Review of Design on iPad (Regular Size Class): We need clarification on how the sheet should behave when it is presented in fullscreen mode on iPad. Should we accept the fullscreen dialog, or is there a preference for maintaining a sheet-like appearance?
     •    Potential Workarounds: As of now, there isn’t a straightforward solution in SwiftUI to adjust sheet height in fullscreen on iPads. However, alternative patterns (like using .popover or a custom modal view) could be considered if the current presentation doesn’t align with design expectations.

 */
