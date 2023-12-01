import Foundation
import SwiftUI

public struct InteractiveImageModifier: ViewModifier {
    @State private var contentSize: CGSize = .zero
    
    @State private var zoomScale: CGFloat = 1
    @State private var lastZoomScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    private let springResponse: CGFloat = 0.35
    private let springDamping: CGFloat = 0.7
    
    private let minZoomScale: CGFloat = 1
    private let maxZoomScale: CGFloat = 5
    
    private let swipeDownThresholdVelocity: CGFloat = 10
    private let swipeDownThresholdDistance: CGFloat = 200
    
    var onDismiss: () -> Void

    public init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(zoomScale)
            .offset(offset)
            .gesture(doubleTapGesture)
            .gesture(combinedGesture)
            .background(GeometryReader { geometryProxy in
                Color.clear
                    .onAppear {
                        contentSize = geometryProxy.size
                    }
            })
    }
    
    private var doubleTapGesture: some Gesture {
        // TODO: Double tap to zoom in, perhaps using simultaneous DragGesture
        TapGesture(count: 2).onEnded {
            withAnimation {
                resetImageState()
            }
        }
    }
    
    private var combinedGesture: some Gesture {
        // Doesn't actually work simultaenously
        SimultaneousGesture(
            MagnifyGesture()
                .onChanged { value in
                    let delta = value.magnification / lastZoomScale
                    lastZoomScale = value.magnification
                    zoomScale *= delta
                    // TODO: Fix zoom anchor
                }
                .onEnded { value in
                    lastZoomScale = 1
                    zoomScale = max(minZoomScale, min(zoomScale, maxZoomScale))
                    fling(with: CGSize(width: value.startAnchor.x, height: value.startAnchor.x))
                },
            DragGesture(minimumDistance: .zero)
                .onChanged { value in
                    offset = CGSize(
                        width: lastOffset.width + value.translation.width,
                        height: lastOffset.height + value.translation.height
                    )
                }
                .onEnded { value in
                    if shouldDismissView(for: value) {
                        onDismiss()
                    } else {
                        let velocity = value.predictedEndTranslation
                        self.fling(with: velocity)
                    }
                }
        )
    }
    
    private func resetImageState() {
        zoomScale = 1
        offset = .zero
        lastOffset = .zero
    }
    
    private func fling(with velocity: CGSize) {
        let adjustedVelocity = CGSize(
            width: velocity.width / zoomScale,
            height: velocity.height / zoomScale
        )
        
        let flingDistance = CGSize(width: adjustedVelocity.width, height: adjustedVelocity.height)
        let proposedNewOffset = CGSize(width: offset.width + flingDistance.width, height: offset.height + flingDistance.height)
        let boundedOffset = adjustOffsetForBounds(proposedNewOffset)
        
        withAnimation(.spring(response: springResponse, dampingFraction: springDamping)) {
            self.offset = boundedOffset
            self.lastOffset = boundedOffset
        }
    }
    
    private func adjustOffsetForBounds(_ newOffset: CGSize) -> CGSize {
        let maxOffsetX = contentSize.width * (zoomScale - 1) / 2
        let maxOffsetY = contentSize.height * (zoomScale - 1) / 2
        let adjustedX = max(-maxOffsetX, min(newOffset.width, maxOffsetX))
        let adjustedY = max(-maxOffsetY, min(newOffset.height, maxOffsetY))
        return CGSize(width: adjustedX, height: adjustedY)
    }
    
    private func shouldDismissView(for gestureValue: DragGesture.Value) -> Bool {
        guard zoomScale == 1 else { return false }
        let verticalMovement = gestureValue.translation.height - lastOffset.height
        let verticalVelocity = gestureValue.predictedEndTranslation.height - gestureValue.translation.height
        return verticalMovement > swipeDownThresholdDistance && verticalVelocity > swipeDownThresholdVelocity
    }
}
