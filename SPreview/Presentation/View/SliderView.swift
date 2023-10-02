//
//  SliderView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI


struct SliderView: View {
    
    // MARK: Properties
    let sliderHeight: CGFloat = 5
    
    @Binding var startAnimatig: Bool
    @Binding var reset: Bool {
        didSet {
            print("rest")
            withAnimation {
                slider = 0
                
            }
        animationDuration = 30.0
        }
    }
    @Binding var seekToSecond: CGFloat
    
    @State var slider: CGFloat = 0
    @State var dragGestureTranslation: CGFloat = 0
    @State var lastDragValue: CGFloat = 0
    @State private var maxValue: CGFloat = UIScreen.main.bounds.width*0.95
    @State var animate = false
    
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var animationDuration: Double = 30.0
    
    // MARK: Content
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack (alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(Color.bienso)
                    
                    Rectangle()
                        .foregroundStyle(Color.white)
                        .frame(width: CGFloat(slider), height: sliderHeight)
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ dragValue in
                                let translation = dragValue.translation
                                
                                dragGestureTranslation = CGFloat(translation.width) + lastDragValue
                                
                                dragGestureTranslation = dragGestureTranslation >= 0 ? dragGestureTranslation : 0
                                
                                dragGestureTranslation = dragGestureTranslation > (geometry.size.width - slider) ? (geometry.size.width - slider) :  dragGestureTranslation
                                
                                self.slider = min(max(0, dragGestureTranslation), dragGestureTranslation)
                                
                                mapValue(value: slider )
                                //                                timer.upstream.connect().cancel()
                                
                            })
                                .onEnded({ dragValue in
                                    dragGestureTranslation = dragGestureTranslation >= 0 ? dragGestureTranslation : 0
                                    
                                    dragGestureTranslation = dragGestureTranslation > (geometry.size.width - slider) ? (geometry.size.width - slider) : dragGestureTranslation
                                    
                                    lastDragValue = dragGestureTranslation
                                    mapValue(value: slider)
                                    //                                    timer.upstream.connect().cancel()
                                })
                        )
                        .onReceive(timer) { _ in
                            // 3
                            animationDuration -= 0.1
                            if animationDuration <= 0.0 {
                                timer.upstream.connect().cancel()
                            } else {
                                withAnimation(.easeIn) {
                                    slider += maxValue/30.0/10.0
                                }
                            }
                        }
                }
                .frame(width: geometry.size.width, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: sliderHeight/2))
            }
        }
        .onChange(of: startAnimatig){
            if startAnimatig {
                timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
               
            } else {
                timer.upstream.connect().cancel()
            }
        }
        
    }
    
    func mapValue(value: Double)  {
        let minValue = 0.0
        let minMappedValue = 0.0
        let maxMappedValue = 30.0
        
        // Ensure the value is within the given range
        let clampedValue = min(max(value, minValue), maxValue)
        
        // Calculate the mapped value
        let normalizedValue = (clampedValue - minValue) / (maxValue - minValue)
        let mappedValue = (normalizedValue * (maxMappedValue - minMappedValue)) + minMappedValue
        
        animationDuration = 30-mappedValue
        seekToSecond = mappedValue
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    SliderView( startAnimatig: .constant(false),
                reset: .constant(false),
                seekToSecond: .constant(0))
    .frame(height: 5)
}
