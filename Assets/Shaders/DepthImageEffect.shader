// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ImageEffect/DepthImageEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 scrPos:TEXCOORD1;

			};

            v2f vert (appdata_base v)
            {
               v2f o;
               o.pos = UnityObjectToClipPos (v.vertex);
               o.scrPos=ComputeScreenPos(o.pos);
               //for some reason, the y position of the depth texture comes out inverted
               o.scrPos.y = 1 - o.scrPos.y;
               return o;
            }
			
			sampler2D _MainTex;
            sampler2D _CameraDepthTexture;

			half4 frag (v2f i) : COLOR
            {
               float depthValue = Linear01Depth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).g);
               half4 depth;

               depth.r = depthValue;
               depth.g = depthValue;
               depth.b = depthValue;

               depth.a = 1;
               return depth;
            }
			ENDCG
		}
	}
}
