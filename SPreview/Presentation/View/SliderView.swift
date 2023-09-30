//
//  SliderView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI


struct SliderView: View {
    
    // MARK: Properties
    var sliderWidth: CGFloat = 5
    let sliderHeight: CGFloat = 5
    
    @State var slider: Float = 0
    @State var dragGestureTranslation: CGFloat = 0
    @State var lastDragValue: CGFloat = 0
    
    // MARK: Content
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack (alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(Color.bienso)
                    
                    Rectangle()
                        .foregroundStyle(Color.white)
                        .frame(width: sliderWidth + CGFloat(slider), height: sliderHeight)
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ dragValue in
                                let translation = dragValue.translation
                                
                                dragGestureTranslation = CGFloat(translation.width) + lastDragValue
                                
                                dragGestureTranslation = dragGestureTranslation >= 0 ? dragGestureTranslation : 0
                                
                                dragGestureTranslation = dragGestureTranslation > (geometry.size.width - sliderWidth) ? (geometry.size.width - sliderWidth) :  dragGestureTranslation
                                
                                self.slider = min(max(0, Float(dragGestureTranslation)), Float(dragGestureTranslation))
                                
                            })
                                .onEnded({ dragValue in
                                    dragGestureTranslation = dragGestureTranslation >= 0 ? dragGestureTranslation : 0
                                    
                                    dragGestureTranslation = dragGestureTranslation > (geometry.size.width - sliderWidth) ? (geometry.size.width - sliderWidth) : dragGestureTranslation
                                    
                                    lastDragValue = dragGestureTranslation
                                })
                        )
                }
                .frame(width: geometry.size.width, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: sliderHeight/2))
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SliderView()
        .frame(height: 5)
}
