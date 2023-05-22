// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ahmet/SRP/Opac/Texture/Toon01"
{
	Properties
	{
		_Texture1("Texture", 2D) = "white" {}
		_ColorContrast("ColorContrast", Float) = 1
		_WorldNormal("WorldNormal", Float) = 0.3
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Albedo("Albedo", Range( 0 , 1)) = 0.3
		_Emission("Emission", Range( 0 , 1)) = 0.85
		_Desaturation("Desaturation", Range( 0 , 1)) = 0
		[Toggle]_TintColorEmissionONOFF("TintColor Emission ON/OFF", Float) = 0
		[Toggle]_TintColorAlbedoONOFF("TintColor Albedo ON/OFF", Float) = 0
		_TintColor("TintColor", Color) = (0,0,0,0)
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
		};

		uniform float _TintColorAlbedoONOFF;
		uniform float _WorldNormal;
		uniform sampler2D _Texture1;
		uniform float _ColorContrast;
		uniform float _Albedo;
		uniform float _Desaturation;
		uniform float4 _TintColor;
		uniform float _TintColorEmissionONOFF;
		uniform float _Emission;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color108 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 color70 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_worldNormal = i.worldNormal;
			float3 desaturateInitialColor66 = ase_worldNormal;
			float desaturateDot66 = dot( desaturateInitialColor66, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar66 = lerp( desaturateInitialColor66, desaturateDot66.xxx, 1.0 );
			float4 lerpResult68 = lerp( color70 , float4( desaturateVar66 , 0.0 ) , _WorldNormal);
			float4 temp_cast_1 = (_ColorContrast).xxxx;
			float4 blendOpSrc67 = lerpResult68;
			float4 blendOpDest67 = pow( tex2D( _Texture1, i.uv_texcoord ) , temp_cast_1 );
			float4 temp_output_67_0 = ( saturate( 2.0f*blendOpDest67*blendOpSrc67 + blendOpDest67*blendOpDest67*(1.0f - 2.0f*blendOpSrc67) ));
			float4 lerpResult107 = lerp( color108 , temp_output_67_0 , _Albedo);
			float3 desaturateInitialColor116 = lerpResult107.rgb;
			float desaturateDot116 = dot( desaturateInitialColor116, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar116 = lerp( desaturateInitialColor116, desaturateDot116.xxx, _Desaturation );
			o.Albedo = (( _TintColorAlbedoONOFF )?( ( _TintColor * float4( desaturateVar116 , 0.0 ) ) ):( float4( desaturateVar116 , 0.0 ) )).rgb;
			float4 color105 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 lerpResult104 = lerp( color105 , temp_output_67_0 , _Emission);
			float3 desaturateInitialColor118 = lerpResult104.rgb;
			float desaturateDot118 = dot( desaturateInitialColor118, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar118 = lerp( desaturateInitialColor118, desaturateDot118.xxx, _Desaturation );
			o.Emission = (( _TintColorEmissionONOFF )?( ( _TintColor * float4( desaturateVar118 , 0.0 ) ) ):( float4( desaturateVar118 , 0.0 ) )).rgb;
			float temp_output_101_0 = _Smoothness;
			o.Metallic = temp_output_101_0;
			o.Smoothness = temp_output_101_0;
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
7;12;1906;1007;-460.4427;788.7732;1.275217;True;True
Node;AmplifyShaderEditor.WorldNormalVector;65;-899.8923,-956.5463;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;-2533.975,220.4725;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-1017.15,183.7778;Inherit;False;Property;_ColorContrast;ColorContrast;2;0;Create;True;0;0;False;0;False;1;1.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;137;-2016.643,213.2532;Inherit;True;Property;_Texture1;Texture;1;0;Create;True;0;0;False;0;False;-1;None;a0d34d7a9efa48f4db28e403e55c7584;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-648.9383,-792.6897;Inherit;False;Property;_WorldNormal;WorldNormal;3;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;66;-610.8709,-956.7335;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;70;-633.975,-1147.895;Inherit;False;Constant;_Color1;Color 1;4;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;35;-780.3648,14.8537;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;68;-313.6925,-979.2305;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;108;762.7164,-1089.716;Inherit;False;Constant;_Color0;Color 0;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;109;771.9305,-780.3233;Inherit;False;Property;_Albedo;Albedo;5;0;Create;True;0;0;False;0;False;0.3;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;67;225.3448,-496.0476;Inherit;True;SoftLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;105;337.8467,-188.0901;Inherit;False;Constant;_Color3;Color 3;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;106;303.9566,69.76778;Inherit;False;Property;_Emission;Emission;6;0;Create;True;0;0;False;0;False;0.85;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;104;740.8467,-182.0901;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.4433962;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;117;1053.642,-469.492;Inherit;False;Property;_Desaturation;Desaturation;7;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;107;1176.072,-1030.214;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.2735849;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;118;1389.486,-395.3856;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;125;1334.275,-1211.046;Inherit;False;Property;_TintColor;TintColor;11;0;Create;True;0;0;False;0;False;0,0,0,0;0.3163937,0.331328,0.8490566,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;116;1397.37,-576.7098;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;1642.368,-807.0529;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;1728.517,-1079.625;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;7;-1814.6,-52.73465;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;False;0;False;-1;None;a0d34d7a9efa48f4db28e403e55c7584;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;132;1966.554,-683.2726;Inherit;False;Property;_TintColorAlbedoONOFF;TintColor Albedo ON/OFF;10;0;Create;True;0;0;False;0;False;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;101;685.0593,194.5907;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;131;1858.558,-399.2691;Inherit;False;Property;_TintColorEmissionONOFF;TintColor Emission ON/OFF;8;0;Create;True;0;0;False;0;False;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;136;-2297.114,27.6514;Inherit;False;Property;_Keyword1;Keyword 0;9;0;Create;True;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;DayColors;NightColors;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;134;-2519.975,398.4725;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;138;2289.116,-450.3233;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ahmet/SRP/Opac/Texture/Toon01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;137;1;135;0
WireConnection;66;0;65;0
WireConnection;35;0;137;0
WireConnection;35;1;36;0
WireConnection;68;0;70;0
WireConnection;68;1;66;0
WireConnection;68;2;69;0
WireConnection;67;0;68;0
WireConnection;67;1;35;0
WireConnection;104;0;105;0
WireConnection;104;1;67;0
WireConnection;104;2;106;0
WireConnection;107;0;108;0
WireConnection;107;1;67;0
WireConnection;107;2;109;0
WireConnection;118;0;104;0
WireConnection;118;1;117;0
WireConnection;116;0;107;0
WireConnection;116;1;117;0
WireConnection;133;0;125;0
WireConnection;133;1;116;0
WireConnection;126;0;125;0
WireConnection;126;1;118;0
WireConnection;132;0;116;0
WireConnection;132;1;133;0
WireConnection;131;0;118;0
WireConnection;131;1;126;0
WireConnection;136;1;135;0
WireConnection;136;0;134;0
WireConnection;138;0;132;0
WireConnection;138;2;131;0
WireConnection;138;3;101;0
WireConnection;138;4;101;0
ASEEND*/
//CHKSM=C1468ED6A3619B3ED847EB8C286016B7F7E15A2F