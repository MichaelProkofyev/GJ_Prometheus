Shader "Custom/EndNoise"
{
	Properties
	{
        _NoiseScale ("Noise scale", Range (0,1000)) = 0
		_NoiseTexture ("Noise Texture", 2D) = "white" {}

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
            #include "SimplexNoise3D.hlsl"
            //#include "SimplexNoise2D.hlsl"
            static const float PI = 3.14159265f;


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

            float _NoiseScale;
			sampler2D _NoiseTexture;


			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                //Getting the noise
                float2 uv = i.uv * _NoiseScale; //+ float2(0.2, 0.5) * _Time.y;
                float noise_value = 0.5;
                float s = 1.0;
                float w = 0.25;

                for (int iter = 0; iter < 6; iter++)
                {
                    float3 coord = float3(uv * s, _Time.z);
                    float3 period = float3(s, s, 1.0) * 2.0;
                    noise_value += snoise(coord ) * w;

                    s *= 2.0;
                    w *= 0.5;
                }
                //NON LINEAR RANDOM COLOR SAMPLING
                noise_value = saturate(noise_value);
                fixed4 noise_color = tex2D(_NoiseTexture, float2(0.5, noise_value));

				return noise_color;
			}
			ENDCG
		}
	}
}
