
Shader "Custom/SpecularOnly" {
	Properties {
		_LightDirection ("Light Direction", Vector) = (0,0,0,1)
		_lightSpread ("Light Spread", Range(0.01, 1)) = 1.0
		_LightColor ("Light Color", Color) = (1,0,1,1)
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 200
		
		ZTest LEqual
		ZWrite Off
		//Blend SrcAlpha OneMinusSrcAlpha
		Blend SrcAlpha One

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf SpecLighting fullforwardshadows vertex:vert nolightmap 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float3 normal;
			float3 posWorld;
		};

		half _lightSpread;
		fixed4 _LightDirection;
		fixed4 _LightColor;


		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.posWorld = mul(unity_ObjectToWorld, v.vertex);
			o.normal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
		}
		fixed4 LightingSpecLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			fixed4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			float3 normalDirection = IN.normal;
			float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - IN.posWorld.xyz);
			float3 lightDirection = normalize(-_LightDirection.xyz);
			float spec = saturate(dot(normalDirection, lightDirection))
				* pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)), _lightSpread * 20);
			
			o.Albedo = spec *_LightColor.rgb;
			
			o.Alpha = spec;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
