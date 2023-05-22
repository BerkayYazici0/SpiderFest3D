// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ahmet/SRP/Opac/Color/LerpTwoColorwithnormal01"
{
	Properties
	{
		_WorldNormal("WorldNormal", Float) = 0
		_Color1("Color 1", Color) = (1,1,1,1)
		_Color2("Color 2", Color) = (1,1,1,1)
		[Toggle]_Fresnel("Fresnel", Float) = 0
		_FresnelColor("FresnelColor", Color) = (1,1,1,1)
		_FresnelScale("FresnelScale", Float) = 0
		_FresnelPower("FresnelPower", Float) = 0
		_Albedo("Albedo", Range( 0 , 1)) = 0
		_Emission("Emission", Range( 0 , 1)) = 0
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
			float3 worldPos;
		};

		uniform float _Fresnel;
		uniform float _WorldNormal;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float4 _FresnelColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _Albedo;
		uniform float _Emission;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color70 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float3 ase_worldNormal = i.worldNormal;
			float3 desaturateInitialColor66 = ase_worldNormal;
			float desaturateDot66 = dot( desaturateInitialColor66, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar66 = lerp( desaturateInitialColor66, desaturateDot66.xxx, 1.0 );
			float4 lerpResult68 = lerp( color70 , float4( desaturateVar66 , 0.0 ) , _WorldNormal);
			float4 lerpResult103 = lerp( _Color1 , _Color2 , lerpResult68);
			float4 blendOpSrc67 = lerpResult68;
			float4 blendOpDest67 = lerpResult103;
			float4 temp_output_67_0 = ( saturate( 2.0f*blendOpDest67*blendOpSrc67 + blendOpDest67*blendOpDest67*(1.0f - 2.0f*blendOpSrc67) ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV115 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode115 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV115, _FresnelPower ) );
			float4 lerpResult114 = lerp( temp_output_67_0 , _FresnelColor , ( fresnelNode115 * _FresnelColor ));
			float4 lerpResult121 = lerp( float4( 0,0,0,0 ) , (( _Fresnel )?( lerpResult114 ):( temp_output_67_0 )) , _Albedo);
			o.Albedo = lerpResult121.rgb;
			float4 lerpResult124 = lerp( float4( 0,0,0,0 ) , (( _Fresnel )?( lerpResult114 ):( temp_output_67_0 )) , _Emission);
			o.Emission = lerpResult124.rgb;
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
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
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
Version=17700
0;3;1920;1016;427.3657;818.7758;1.082025;True;True
Node;AmplifyShaderEditor.WorldNormalVector;65;-1576.079,-703.5638;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DesaturateOpNode;66;-1287.057,-703.751;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1325.125,-539.707;Inherit;False;Property;_WorldNormal;WorldNormal;0;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;70;-1310.161,-894.9136;Inherit;False;Constant;_ColorX;Color X;4;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;118;-982.5544,354.5227;Inherit;False;Property;_FresnelScale;FresnelScale;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;102;-1257.104,-407.8484;Inherit;False;Property;_Color1;Color 1;1;0;Create;True;0;0;False;0;1,1,1,1;0.6207725,0.6910137,0.8490566,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;119;-973.0445,428.224;Inherit;False;Property;_FresnelPower;FresnelPower;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;68;-989.8766,-726.248;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;101;-1266.096,-198.1183;Inherit;False;Property;_Color2;Color 2;2;0;Create;True;0;0;False;0;1,1,1,1;0.6196079,0.6901961,0.8509804,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;103;-611.4092,-228.1549;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;112;-313.2094,107.4413;Float;False;Property;_FresnelColor;FresnelColor;4;0;Create;True;0;0;False;0;1,1,1,1;0.262367,0.4528302,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;115;-550.8495,328.7152;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;5.4;False;3;FLOAT;5.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-46.71425,354.5009;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;67;-166.4686,-434.9769;Inherit;True;SoftLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;114;131.9791,1.551563;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;117;549.7493,-296.0852;Inherit;False;Property;_Fresnel;Fresnel;3;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;123;212.3037,-622.9196;Inherit;False;Property;_Albedo;Albedo;7;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;208.8902,-512.8334;Inherit;False;Property;_Emission;Emission;8;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;903.467,109.5147;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;621.793,-625.847;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;124;663.2251,-458.986;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;120;1156.408,-380.5421;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ahmet/SRP/Opac/Color/LerpTwoColorwithnormal01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;66;0;65;0
WireConnection;68;0;70;0
WireConnection;68;1;66;0
WireConnection;68;2;69;0
WireConnection;103;0;102;0
WireConnection;103;1;101;0
WireConnection;103;2;68;0
WireConnection;115;2;118;0
WireConnection;115;3;119;0
WireConnection;116;0;115;0
WireConnection;116;1;112;0
WireConnection;67;0;68;0
WireConnection;67;1;103;0
WireConnection;114;0;67;0
WireConnection;114;1;112;0
WireConnection;114;2;116;0
WireConnection;117;0;67;0
WireConnection;117;1;114;0
WireConnection;121;1;117;0
WireConnection;121;2;123;0
WireConnection;124;1;117;0
WireConnection;124;2;122;0
WireConnection;120;0;121;0
WireConnection;120;2;124;0
ASEEND*/
//CHKSM=3901A84D7DF27A48E68B92506359182D0A5EE016