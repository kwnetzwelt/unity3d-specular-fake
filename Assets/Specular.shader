Shader "Custom/Specular" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_LightDirection ("Light Direction", Vector) = (0,0,0,1)
		_lightSpread ("Light Spread", Range(0.01, 20)) = 2.0
		_LightColor ("Light Color", Color) = (1,0,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert nolightmap

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 normal;
			float3 posWorld;
		};

		half _Glossiness;
		half _Metallic;
		half _lightSpread;
		fixed4 _LightDirection;
		fixed4 _LightColor;
		fixed4 _Color;

		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.posWorld = mul(unity_ObjectToWorld, v.vertex);
			o.normal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float3 normalDirection = IN.normal;
			float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - IN.posWorld.xyz);
			float3 lightDirection = normalize(-_LightDirection.xyz);
			float spec = saturate(dot(normalDirection, lightDirection))
				* pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)), _lightSpread);
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = spec * _LightColor + c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
