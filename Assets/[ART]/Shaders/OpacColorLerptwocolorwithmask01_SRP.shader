// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ahmet/SRP/Opac/Color/LerpTwoColorwithmask01"
{
	Properties
	{
		_WorldNormal("WorldNormal", Float) = 0.3
		_Color1("Color 1", Color) = (0.3207547,0.1070996,0,0)
		_Color2("Color 2", Color) = (1,0.4555214,0.0990566,0)
		[Toggle]_Fresnel("Fresnel", Float) = 0
		_FresnelColor("FresnelColor", Color) = (0.262367,0.4528302,0,0)
		_FresnelScale("FresnelScale", Float) = 5.4
		_FresnelPower("FresnelPower", Float) = 5
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Albedo1("Albedo", Range( 0 , 1)) = 0
		_Emission1("Emission", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _Fresnel;
		uniform float _WorldNormal;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform sampler2D _TextureSample1;
		SamplerState sampler_TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float4 _FresnelColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _Albedo1;
		uniform float _Emission1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color70 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_worldNormal = i.worldNormal;
			float3 desaturateInitialColor66 = ase_worldNormal;
			float desaturateDot66 = dot( desaturateInitialColor66, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar66 = lerp( desaturateInitialColor66, desaturateDot66.xxx, 1.0 );
			float4 lerpResult68 = lerp( color70 , float4( desaturateVar66 , 0.0 ) , _WorldNormal);
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float4 lerpResult103 = lerp( _Color1 , _Color2 , tex2D( _TextureSample1, uv_TextureSample1 ).r);
			float4 blendOpSrc67 = lerpResult68;
			float4 blendOpDest67 = lerpResult103;
			float4 temp_output_67_0 = ( saturate( 2.0f*blendOpDest67*blendOpSrc67 + blendOpDest67*blendOpDest67*(1.0f - 2.0f*blendOpSrc67) ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV115 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode115 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV115, _FresnelPower ) );
			float4 lerpResult114 = lerp( temp_output_67_0 , _FresnelColor , ( fresnelNode115 * _FresnelColor ));
			float4 lerpResult126 = lerp( float4( 0,0,0,0 ) , (( _Fresnel )?( lerpResult114 ):( temp_output_67_0 )) , _Albedo1);
			o.Albedo = lerpResult126.rgb;
			float4 lerpResult127 = lerp( float4( 0,0,0,0 ) , (( _Fresnel )?( lerpResult114 ):( temp_output_67_0 )) , _Emission1);
			o.Emission = lerpResult127.rgb;
			float temp_output_111_0 = 0.0;
			o.Metallic = temp_output_111_0;
			o.Smoothness = temp_output_111_0;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
7;12;1906;1007;133.4626;1102.957;1.465238;True;True
Node;AmplifyShaderEditor.WorldNormalVector;65;-1576.079,-703.5638;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;102;-1582.104,-426.8484;Inherit;False;Property;_Color1;Color 1;1;0;Create;True;0;0;False;0;False;0.3207547,0.1070996,0,0;0.294538,0.2452385,0.3113208,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;122;-941.5013,26.41235;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;70;-1310.161,-894.9136;Inherit;False;Constant;_ColorX;Color X;4;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-1325.125,-539.707;Inherit;False;Property;_WorldNormal;WorldNormal;0;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;66;-1287.057,-703.751;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-774.2042,398.2104;Inherit;False;Property;_FresnelPower;FresnelPower;6;0;Create;True;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-783.7141,324.5091;Inherit;False;Property;_FresnelScale;FresnelScale;5;0;Create;True;0;0;False;0;False;5.4;5.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;101;-1538.096,-124.1183;Inherit;False;Property;_Color2;Color 2;2;0;Create;True;0;0;False;0;False;1,0.4555214,0.0990566,0;0.2783909,0.2254361,0.3207547,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;68;-989.8766,-726.248;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;115;-352.0093,298.7016;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;5.4;False;3;FLOAT;5.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;112;-114.3691,77.42768;Float;False;Property;_FresnelColor;FresnelColor;4;0;Create;True;0;0;False;0;False;0.262367,0.4528302,0,0;0.262367,0.4528302,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;103;-611.4092,-228.1549;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;152.126,324.4873;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;67;-121.4481,-406.8391;Inherit;True;SoftLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;114;330.8194,-28.46206;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;125;727.9735,-441.1198;Inherit;False;Property;_Emission1;Emission;9;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;671.936,-675.4562;Inherit;False;Property;_Albedo1;Albedo;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;117;239.415,-759.138;Inherit;False;Property;_Fresnel;Fresnel;3;0;Create;True;0;0;False;0;False;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;111;903.467,109.5147;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;126;1144.983,-884.4209;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;127;1137.889,-507.203;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;128;1582.998,-714.3953;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ahmet/SRP/Opac/Color/LerpTwoColorwithmask01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;66;0;65;0
WireConnection;68;0;70;0
WireConnection;68;1;66;0
WireConnection;68;2;69;0
WireConnection;115;2;118;0
WireConnection;115;3;119;0
WireConnection;103;0;102;0
WireConnection;103;1;101;0
WireConnection;103;2;122;1
WireConnection;116;0;115;0
WireConnection;116;1;112;0
WireConnection;67;0;68;0
WireConnection;67;1;103;0
WireConnection;114;0;67;0
WireConnection;114;1;112;0
WireConnection;114;2;116;0
WireConnection;117;0;67;0
WireConnection;117;1;114;0
WireConnection;126;1;117;0
WireConnection;126;2;124;0
WireConnection;127;1;117;0
WireConnection;127;2;125;0
WireConnection;128;0;126;0
WireConnection;128;2;127;0
WireConnection;128;3;111;0
WireConnection;128;4;111;0
ASEEND*/
//CHKSM=59D213C9FBE484C942BBFEA845E013FBF606B0B2