//
//  SliderView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI


struct SliderView: View {
    
    // MARK: Properties
    let sliderHeight: Double = 5
    
    @StateObject var musicPlayer: MusicPlayer
    
    @Binding var startingSecond: Double
    
    @State private var startedDragging = false
    @State private var sliderWidth: Double = 0
    @State private var sliderWidthBeforeDragging: Double = 0
    @State private var maxValue = UIScreen.main.bounds.width*0.95
    
    // MARK: Content
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack (alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(Color.bienso)
                    
                    Rectangle()
                        .foregroundStyle(Color.white)
                        .frame(width: CGFloat(sliderWidth), height: sliderHeight)
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ gesture in
                                startedDragging(with: gesture.translation.width)
                                updateStartingSecond()
                            })
                            .onEnded({ _ in
                                    startedDragging =  false
                                })
                        )
                }
                .frame(width: geometry.size.width, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: sliderHeight/2))
            }
        }
        .onChange(of: musicPlayer.progress) {
            withAnimation(.easeIn) {
                sliderWidth = max(0, musicPlayer.progress * maxValue)
            }
        }
    }
    
    // MARK: Functions
    private func startedDragging(with dragValue: Double) {
        if !startedDragging  {
            sliderWidthBeforeDragging = sliderWidth
        }
        startedDragging =  true
        
        sliderWidth = sliderWidthBeforeDragging + dragValue
        
        if sliderWidth < 0 {
            sliderWidth = 0
        } else if sliderWidth > maxValue {
            sliderWidth = maxValue
        }
    }
    
    private func updateStartingSecond() {
        let value = mapValueToAudioDuration(sliderWidth)
        startingSecond = value
    }
    
    private func mapValueToAudioDuration(_ value: Double) -> Double {
        let minValue = 0.0
        let maxMappedValue = 30.0
        
        let clampedValue = min(max(value, minValue), maxValue)
        let normalizedValue = (clampedValue - minValue) / (maxValue - minValue)
        let mappedValue = (normalizedValue * (maxMappedValue))
        
        return mappedValue
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SliderView(musicPlayer: MusicPlayer.shared,
               startingSecond: .constant(0))
    .frame(height: 5)
}
