// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ahmet/SRP/Opac/Color/LerpThreeColorwithmask01"
{
	Properties
	{
		_WorldNormal("WorldNormal", Float) = 0.3
		_Color3("Color 1", Color) = (0.3207547,0.1070996,0,0)
		_Color4("Color 2", Color) = (1,0.4555214,0.0990566,0)
		[Toggle]_Fresnel("Fresnel", Float) = 0
		_Color5("Color 3", Color) = (1,0.4555214,0.0990566,0)
		_FresnelColor("FresnelColor", Color) = (0.262367,0.4528302,0,0)
		_FresnelScale("FresnelScale", Float) = 5.4
		_FresnelPower("FresnelPower", Float) = 5
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Albedo("Albedo", Range( 0 , 1)) = 0
		_Emission("Emission", Range( 0 , 1)) = 0
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
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform float4 _Color3;
		SamplerState sampler_TextureSample2;
		uniform float4 _Color4;
		uniform float4 _Color5;
		uniform float4 _FresnelColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _Albedo;
		uniform float _Emission;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color70 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_worldNormal = i.worldNormal;
			float3 desaturateInitialColor66 = ase_worldNormal;
			float desaturateDot66 = dot( desaturateInitialColor66, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar66 = lerp( desaturateInitialColor66, desaturateDot66.xxx, 1.0 );
			float4 lerpResult68 = lerp( color70 , float4( desaturateVar66 , 0.0 ) , _WorldNormal);
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float4 tex2DNode136 = tex2D( _TextureSample2, uv_TextureSample2 );
			float4 lerpResult129 = lerp( tex2DNode136 , _Color3 , tex2DNode136.r);
			float4 lerpResult131 = lerp( lerpResult129 , _Color4 , tex2DNode136.g);
			float4 lerpResult135 = lerp( lerpResult131 , _Color5 , tex2DNode136.b);
			float4 blendOpSrc67 = lerpResult68;
			float4 blendOpDest67 = lerpResult135;
			float4 temp_output_67_0 = ( saturate( 2.0f*blendOpDest67*blendOpSrc67 + blendOpDest67*blendOpDest67*(1.0f - 2.0f*blendOpSrc67) ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV115 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode115 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV115, _FresnelPower ) );
			float4 lerpResult114 = lerp( temp_output_67_0 , _FresnelColor , ( fresnelNode115 * _FresnelColor ));
			float4 lerpResult138 = lerp( float4( 0,0,0,0 ) , (( _Fresnel )?( lerpResult114 ):( temp_output_67_0 )) , _Albedo);
			o.Albedo = lerpResult138.rgb;
			float4 lerpResult139 = lerp( float4( 0,0,0,0 ) , (( _Fresnel )?( lerpResult114 ):( temp_output_67_0 )) , _Emission);
			o.Emission = lerpResult139.rgb;
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
7;12;1906;1007;70.33142;883.4158;1.230869;True;True
Node;AmplifyShaderEditor.SamplerNode;136;-3088.474,661.6445;Inherit;True;Property;_TextureSample2;Texture Sample 2;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;128;-2936.416,222.8394;Inherit;False;Property;_Color3;Color 1;1;0;Create;True;0;0;False;0;False;0.3207547,0.1070996,0,0;0.7491226,0.7155572,0.7547169,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;65;-1576.079,-703.5638;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;130;-2346.456,769.2258;Inherit;False;Property;_Color4;Color 2;2;0;Create;True;0;0;False;0;False;1,0.4555214,0.0990566,0;0.8962264,0.5405617,0.3086061,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;129;-2096.533,375.5983;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;70;-1310.161,-894.9136;Inherit;False;Constant;_ColorX;Color X;4;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;132;-1821.68,820.6885;Inherit;False;Property;_Color5;Color 3;4;0;Create;True;0;0;False;0;False;1,0.4555214,0.0990566,0;0.5283019,0.3228821,0.1270914,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;118;-783.7141,324.5091;Inherit;False;Property;_FresnelScale;FresnelScale;6;0;Create;True;0;0;False;0;False;5.4;5.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;131;-1683.48,445.443;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;66;-1287.057,-703.751;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1325.125,-539.707;Inherit;False;Property;_WorldNormal;WorldNormal;0;0;Create;True;0;0;False;0;False;0.3;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-774.2042,398.2104;Inherit;False;Property;_FresnelPower;FresnelPower;7;0;Create;True;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;115;-352.0093,298.7016;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;5.4;False;3;FLOAT;5.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;112;-114.3691,77.42768;Float;False;Property;_FresnelColor;FresnelColor;5;0;Create;True;0;0;False;0;False;0.262367,0.4528302,0,0;0.2623669,0.45283,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;68;-989.8766,-726.248;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;135;-1339.728,523.4934;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;67;-121.4481,-406.8391;Inherit;True;SoftLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;152.126,324.4873;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;114;330.8194,-28.46206;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;117;756.0931,-239.8096;Inherit;False;Property;_Fresnel;Fresnel;3;0;Create;True;0;0;False;0;False;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;140;660.8051,-446.4572;Inherit;False;Property;_Albedo;Albedo;9;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;690.3453,-45.19369;Inherit;False;Property;_Emission;Emission;10;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;903.467,109.5147;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;127;-3008.68,436.0996;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;138;1020.219,-424.3015;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;139;1026.373,-211.3611;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;137;1320.114,-399.3091;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ahmet/SRP/Opac/Color/LerpThreeColorwithmask01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;129;0;136;0
WireConnection;129;1;128;0
WireConnection;129;2;136;1
WireConnection;131;0;129;0
WireConnection;131;1;130;0
WireConnection;131;2;136;2
WireConnection;66;0;65;0
WireConnection;115;2;118;0
WireConnection;115;3;119;0
WireConnection;68;0;70;0
WireConnection;68;1;66;0
WireConnection;68;2;69;0
WireConnection;135;0;131;0
WireConnection;135;1;132;0
WireConnection;135;2;136;3
WireConnection;67;0;68;0
WireConnection;67;1;135;0
WireConnection;116;0;115;0
WireConnection;116;1;112;0
WireConnection;114;0;67;0
WireConnection;114;1;112;0
WireConnection;114;2;116;0
WireConnection;117;0;67;0
WireConnection;117;1;114;0
WireConnection;138;1;117;0
WireConnection;138;2;140;0
WireConnection;139;1;117;0
WireConnection;139;2;141;0
WireConnection;137;0;138;0
WireConnection;137;2;139;0
WireConnection;137;3;111;0
WireConnection;137;4;111;0
ASEEND*/
//CHKSM=AEE0D7F7C19565628A8F83F47AAE6E21A146F1B3