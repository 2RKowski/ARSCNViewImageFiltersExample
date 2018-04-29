//
//  SceneFilterTechnique.metal
//  ARSCNViewImageFiltersExample
//
//  Created by Lësha Turkowski on 4/29/18.
//  Copyright © 2018 Lësha Turkowski. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

struct VertexInput {
    float4 position [[ attribute(SCNVertexSemanticPosition) ]];
    float2 texcoord [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct VertexOut {
    float4 position [[position]];
    float2 texcoord;
};

vertex VertexOut scene_filter_vertex(VertexInput in [[stage_in]])
{
    VertexOut out;
    out.position = in.position;
    out.texcoord =  float2((in.position.x + 1.0) * 0.5 , (in.position.y + 1.0) * -0.5);
    return out;
}

fragment half4 scene_filter_fragment(VertexOut vert [[stage_in]],
                                texture2d<half, access::sample> scene [[texture(0)]])
{
    constexpr sampler samp = sampler(coord::normalized, address::repeat, filter::nearest);
    constexpr half3 weights = half3(0.2126, 0.7152, 0.0722);
    
    half4 color = scene.sample(samp, vert.texcoord);
    color.rgb = half3(dot(color.rgb, weights));
    
    return color;
}
