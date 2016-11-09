Shader "d3cr1pt0r/VolumetricSphere"
{
	Properties
	{
		_Center ("Center", Vector) = (0,0,0,0)
		_Radius ("Radius", Range(0, 5)) = 0.5
		_Steps ("Steps", Range(0, 500)) = 64
		_StepSize ("Step Size", Range(0, 1)) = 0.01
		_MinDist ("Minimum Distance", Range(0, 0.1)) = 0.1
		_Color ("Color", Color) = (1,0,0,1)
		_Magic ("Magic", Range(1, 100)) = 1
		_Eps ("EPS", Range(0.01, 1)) = 0.01
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vertex_shader
			#pragma fragment fragment_shader
			
			#include "UnityCG.cginc"
			#include "Raymarching.cginc"

			float3 _Center;
			float _Radius;
			float _Steps;
			float _StepSize;
			float _MinDist;
			fixed4 _Color;
			float _Magic;
			float _Eps;

			struct vertex_input
			{
				float4 vertex : POSITION;
			};

			struct fragment_input
			{
				float4 vertex : SV_POSITION;
				float3 world_pos : TEXCOORD0;
			};
			
			fragment_input vertex_shader (vertex_input v)
			{
				fragment_input o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.world_pos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}
			
			fixed4 fragment_shader (fragment_input i) : SV_Target
			{
				float3 viewDirection = normalize(i.world_pos - _WorldSpaceCameraPos);

				//return raymarchSphere1(i.world_pos, viewDirection, _Center, _Radius, _Steps, _StepSize);
				//return raymarchSphere2(i.world_pos, viewDirection, _Center, _Radius, _MinDist, _Steps, _Magic);
				return raymarchSphere3(i.world_pos, viewDirection, _Center, _Radius, _MinDist, _Steps, _Eps);
			}
			ENDCG
		}
	}
}