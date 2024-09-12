//
//  CustomSheet.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 12/09/24.
//


import SwiftUI

struct CustomSheet<Content: View>: View {
    let content: Content
    let maxHeight: CGFloat
    let minHeight: CGFloat
    @Binding var isOpen: Bool
    @State private var offset: CGFloat = 0
    var sheetWidth: CGFloat?  // Optional custom width for the sheet
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeight: CGFloat, sheetWidth: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isOpen = isOpen
        self.maxHeight = maxHeight
        self.minHeight = minHeight
        self.sheetWidth = sheetWidth
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
//                Spacer()
                VStack(spacing: 0) {
                    // Drag Handle at the very top center of the sheet
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 40, height: 6)
                        .padding(.top, 8)  // Padding to give space from top
                        .frame(maxWidth: .infinity, alignment: .center)  // Center the handle horizontally
                    
                    // Sheet Content
                    self.content
                        .padding(.top, 8)  // Padding for the content to ensure it starts after the handle
                }
                .frame(width: self.sheetWidth ?? geometry.size.width * 0.9,  // Set width as 90% of screen width or custom width
                       height: max(self.minHeight, self.maxHeight + self.offset))
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .offset(y: self.isOpen ? 0 : geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height - (max(self.minHeight, self.maxHeight) / 2) + self.offset) // Center horizontally and position at the bottom
                .animation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.5), value: isOpen)  // Smooth spring animation
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let newOffset = gesture.translation.height
                            if newOffset > 0 {
                                self.offset = newOffset
                            }
                        }
                        .onEnded { _ in
                            if self.offset > self.maxHeight / 2 {
                                // Close the sheet if dragged down sufficiently
                                self.isOpen = false
                            }
                            self.offset = 0
                        }
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}




