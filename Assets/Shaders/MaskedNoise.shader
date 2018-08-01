Shader "Custom/MaskedNoise"
{
	Properties
	{
        _IdleColor ("Idle Color", Color) = (1,1,1,1)
        _NoiseTexture ("Noise Texture", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
        _NoiseLerp ("Noise lerp", Range (0,1)) = 0
        _NoiseScale ("Noise scale", Range (0,1000)) = 0
        _FlashPosition ("Flash Position", Vector) = (0,0,0,0) 

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

            float4 _IdleColor;
            sampler2D _NoiseTexture;
            sampler2D _Mask;
            float _NoiseLerp;
            float _NoiseScale;
            float4 _FlashPosition;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                //Clip by mask
                fixed4 mask_value = tex2D(_Mask, i.uv);
                clip(mask_value - 0.5);

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

                //Color flash
                const float flash_period = 3;
                float time_value = _Time.z / flash_period;

                //float flash_position = snoise(float3(floor(time_value), 0, 0));
                //float flash_position2 = snoise(float3(floor(time_value + 1), 0, 0));
                float2 flash_center = float2(_FlashPosition.x, _FlashPosition.y);
                if (distance(flash_center, i.uv) < 0.1)
                {
                    float flash_amount = sin(frac(time_value) * PI) / 1.5;
                    float4 noise_with_flash = lerp(noise_color, fixed4(1,0,0,1), flash_amount);
                }


                fixed4 final_color = lerp(_IdleColor, noise_color, _NoiseLerp);
				return final_color;
			}
			ENDCG
		}
	}
}
