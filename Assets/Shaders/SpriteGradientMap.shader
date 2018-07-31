Shader "Unlit/SpriteGradientMap"
{
     Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1,1,1,1)
        [HideInInspector] _Flip ("Flip", Vector) = (1,1,1,1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
 
        _GradientMap ("Gradient map", 2D) = "white" {}
    }
 
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }
 
        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha
        Pass
 
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_instancing
            #pragma multi_compile _ PIXELSNAP_ON
            #pragma multi_compile _ ETC1_EXTERNAL_ALPHA
            #include "UnitySprites.cginc"
            #include "SimplexNoise3D.hlsl"

 
            v2f vert(appdata_t IN)
            {
                v2f OUT;
 
                UNITY_SETUP_INSTANCE_ID (IN);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
 
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color * _Color * _RendererColor;
                //OUT.uv = IN.texcoord.xy;

                return OUT;
            }
 
            sampler2D _GradientMap;
 
            fixed4 frag(v2f i) : SV_Target
            {
                //Getting the noise
                const float epsilon = 0.0001;
                float2 uv = i.texcoord * 4.0 + float2(0.2, 0.5) * _Time.y;
                float o = 0.5;
                float s = 1.0;
                float w = 0.25;
               
                for (int i = 0; i < 6; i++)
                {
                    float3 coord = float3(uv * s, _Time.y);
                    float3 period = float3(s, s, 1.0) * 2.0;
                    o += snoise(coord) * w;

                    //o +=  (coord) * w;
                    s *= 2.0;
                    w *= 0.5;
                }

                //fixed4 c = SampleSpriteTexture (i.texcoord + _Time[0]);
                fixed4 c = float4(o, o, o, 1);
                //float grayscale = dot(c.rgb, float3(0.3, 0.59, 0.11));
                fixed4 gradientCol = tex2D(_GradientMap, float2(o, 0));
                return gradientCol;
            }
 
        ENDCG
        }
    }
 
Fallback "Transparent/VertexLit"
}