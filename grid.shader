Shader "Grid" {
    
    Properties {
       _GridThickness ("Grid Thickness", Float) = 0.02
       _GridSpacing ("Grid Spacing", Float) = 10.0
       _GridColor ("Grid Color", Color) = (0.5, 0.5, 1.0, 1.0)
       _OutsideColor ("Color Outside Grid", Color) = (0.0, 0.0, 0.0, 0.0)
    }
 
    SubShader {
       Tags {
          "Queue" = "Transparent"
             // draw after all opaque geometry has been drawn
       }
 
       Pass {
          ZWrite Off
             // don't write to depth buffer in order not to occlude other objects
          Blend SrcAlpha OneMinusSrcAlpha
             // use alpha blending
 
          CGPROGRAM
  
          #pragma vertex vert  
          #pragma fragment frag 
  
          uniform float _GridThickness;
          uniform float _GridSpacing;
          uniform float4 _GridColor;
          uniform float4 _OutsideColor;
 
          struct vertexInput {
             float4 vertex : POSITION;
          };
          struct vertexOutput {
             float4 pos : SV_POSITION;
             float4 worldPos : TEXCOORD0;
          };
  
          vertexOutput vert(vertexInput input) {
             vertexOutput output; 
  
             output.pos =  mul(UNITY_MATRIX_MVP, input.vertex);
             output.worldPos = mul(_Object2World, input.vertex);
                // transformation of input.vertex from object coordinates to world coordinates;
             return output;
          }
  
          float4 frag(vertexOutput input) : COLOR {
             if (frac(input.worldPos.x/_GridSpacing) < _GridThickness 
             || frac(input.worldPos.y/_GridSpacing) < _GridThickness) {
                return _GridColor;
             } else {
                return _OutsideColor;
             }
          }
  
          ENDCG  
       }
    }
 }