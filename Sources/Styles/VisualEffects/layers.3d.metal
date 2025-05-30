//
//  layers.3d.metal
//  VocalRemover
//
//  Created by Vaida on 2025-05-29.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] float2 layers_3d(float2 position, float2 size) {
    float x = position[0];
    float y = position[1] - x * 0.6;
    return float2(x, y);
}
