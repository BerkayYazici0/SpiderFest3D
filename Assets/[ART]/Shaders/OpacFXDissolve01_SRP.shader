// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ahmet/SRP/FX/Dissolve01"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Texture1("Texture", 2D) = "white" {}
		_ColorContrast1("ColorContrast", Float) = 1
		_WorldNormal1("WorldNormal", Float) = 0.3
		_DissolveFX("DissolveFX", Range( 0 , 1)) = 0
		_Smoothness1("Smoothness", Range( 0 , 1)) = 0
		_EdgeThickness1("EdgeThickness", Range( 0 , 4)) = 0
		_Metallic1("Metallic", Range( 0 , 1)) = 0
		_ColorIntensity1("ColorIntensity", Range( 0 , 1)) = 0.85
		_AlbedoIntensity1("AlbedoIntensity", Range( 0 , 1)) = 0.3
		_EdgeColor1("EdgeColor", Color) = (1,0.5874085,0,0)
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float3 worldNormal;
		};

		uniform sampler2D _Texture1;
		uniform float4 _Texture1_ST;
		uniform float _AlbedoIntensity1;
		uniform float4 _EdgeColor1;
		uniform float _DissolveFX;
		uniform float _EdgeThickness1;
		uniform float _WorldNormal1;
		uniform float _ColorContrast1;
		uniform float _ColorIntensity1;
		uniform float _Metallic1;
		uniform float _Smoothness1;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color64 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 uv_Texture1 = i.uv_texcoord * _Texture1_ST.xy + _Texture1_ST.zw;
			float4 tex2DNode54 = tex2D( _Texture1, uv_Texture1 );
			float4 lerpResult70 = lerp( color64 , tex2DNode54 , _AlbedoIntensity1);
			float lerpResult31 = lerp( 12.0 , 0.0 , _DissolveFX);
			float Gradient41 = ( (-0.6 + (( 1.0 - lerpResult31 ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + ( i.uv2_texcoord2.y * 10.0 ) );
			float2 uv2_TexCoord38 = i.uv2_texcoord2 * float2( 5,5 );
			float simplePerlin2D40 = snoise( uv2_TexCoord38 );
			simplePerlin2D40 = simplePerlin2D40*0.5 + 0.5;
			float Noise42 = simplePerlin2D40;
			float temp_output_53_0 = ( ( ( 1.0 - Gradient41 ) * Noise42 ) - Gradient41 );
			float temp_output_58_0 = step( temp_output_53_0 , ( _EdgeThickness1 + (0.0 + (0.0 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) ) );
			float edge62 = temp_output_58_0;
			float4 lerpResult80 = lerp( lerpResult70 , _EdgeColor1 , edge62);
			o.Albedo = lerpResult80.rgb;
			float4 color65 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 color52 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_worldNormal = i.worldNormal;
			float3 desaturateInitialColor51 = ase_worldNormal;
			float desaturateDot51 = dot( desaturateInitialColor51, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar51 = lerp( desaturateInitialColor51, desaturateDot51.xxx, 1.0 );
			float4 lerpResult59 = lerp( color52 , float4( desaturateVar51 , 0.0 ) , _WorldNormal1);
			float4 temp_cast_2 = (_ColorContrast1).xxxx;
			float4 blendOpSrc63 = lerpResult59;
			float4 blendOpDest63 = pow( tex2DNode54 , temp_cast_2 );
			float4 lerpResult69 = lerp( color65 , ( saturate( 2.0f*blendOpDest63*blendOpSrc63 + blendOpDest63*blendOpDest63*(1.0f - 2.0f*blendOpSrc63) )) , _ColorIntensity1);
			float4 lerpResult79 = lerp( lerpResult69 , _EdgeColor1 , edge62);
			o.Emission = lerpResult79.rgb;
			o.Metallic = _Metallic1;
			o.Smoothness = _Smoothness1;
			o.Alpha = 1;
			float cutout71 = temp_output_53_0;
			clip( cutout71 - _Cutoff );
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
				float4 customPack1 : TEXCOORD1;
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
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
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
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
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
Version=17700
0;3;1920;1016;7145.81;-1713.504;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;26;-6618.483,2350.257;Inherit;False;Property;_DissolveFX;DissolveFX;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;-5474.851,2410.466;Inherit;False;3;0;FLOAT;12;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-5919.428,2797.081;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;33;-5674.56,2772.121;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;-5310.81,2411.339;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-5304.685,2640.632;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;36;-5057.033,2420.037;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;37;-5234.546,1940.69;Inherit;False;Constant;_NoiseScale1;NoiseScale;5;0;Create;True;0;0;False;0;5,5;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-5039.417,1950.072;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-4724.928,2502.627;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-4474.293,2567.801;Inherit;False;Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;-4755.691,1946.074;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-4448.914,2030.847;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-3831.414,1584.203;Inherit;True;41;Gradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-3669.585,1892.671;Inherit;True;42;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;45;-3523.694,1571.644;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;50;-4095.897,-307.1255;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;49;-3648.333,2134.993;Inherit;True;41;Gradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-3182.088,2623.567;Inherit;False;Property;_EdgeThickness1;EdgeThickness;8;0;Create;True;0;0;False;0;0;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-3184.753,1635.397;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;46;-3089.671,2725.77;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-2823.745,2665.972;Inherit;True;2;2;0;FLOAT;0.01;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-4144.401,417.911;Inherit;False;Property;_ColorContrast1;ColorContrast;3;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-4409.537,36.52882;Inherit;True;Property;_Texture1;Texture;2;0;Create;True;0;0;False;0;-1;None;d78befaab8ff43f43b4b0eb551efbca4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-3844.943,-143.2689;Inherit;False;Property;_WorldNormal1;WorldNormal;4;0;Create;True;0;0;False;0;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;52;-3829.98,-498.4753;Inherit;False;Constant;_Color2;Color 1;4;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;51;-3806.876,-307.3127;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;53;-2900.296,1928.161;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;60;-3795.54,218.7435;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;59;-3509.697,-329.8098;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;58;-2525.672,2679.621;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1746.337,-2.303876;Inherit;False;Property;_AlbedoIntensity1;AlbedoIntensity;11;0;Create;True;0;0;False;0;0.3;0.315;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;-2371.721,295.363;Inherit;False;Constant;_Color4;Color 3;6;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-2437.735,717.2208;Inherit;False;Property;_ColorIntensity1;ColorIntensity;10;0;Create;True;0;0;False;0;0.85;0.85;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;63;-2448.084,477.3617;Inherit;True;SoftLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-2214.831,2514.481;Inherit;False;edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;64;-1695.837,-417.3927;Inherit;False;Constant;_Color5;Color 4;6;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-2459.023,1876.126;Inherit;False;cutout;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-1340.664,-334.8298;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.2735849;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;69;-1606.361,292.6723;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.4433962;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1607.963,591.6509;Inherit;False;62;edge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;68;-1544.936,693.1089;Inherit;False;Property;_EdgeColor1;EdgeColor;13;0;Create;True;0;0;False;0;1,0.5874085,0,0;1,0.5874085,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;28;-6000.581,2115.993;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-6561.835,1492.335;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;False;0;1,1,1,1;0.9811321,0.2267711,0.2267711,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-104.3466,82.27694;Inherit;False;Property;_Smoothness1;Smoothness;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-108.0556,-0.4052113;Inherit;False;Property;_Metallic1;Metallic;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-15.23628,309.6771;Inherit;False;71;cutout;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;80;-710.7239,-689.304;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-2272.714,2717.439;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.InverseOpNode;78;-4790.454,2833.821;Inherit;False;1;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4x4;0
Node;AmplifyShaderEditor.OneMinusNode;75;-2419.969,2230.096;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-4085.956,285.9537;Inherit;False;MainTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-5795.648,2407.051;Inherit;False;Property;_Transition1;Transition;12;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;79;-959.4071,623.7312;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;27;-6389.006,2009.544;Inherit;False;Property;_Color0;Color 0;7;0;Create;True;0;0;False;0;1,1,1,1;0,0.3192677,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;25;340.2093,-486.2259;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ahmet/SRP/FX/Dissolve01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;2;26;0
WireConnection;33;0;32;2
WireConnection;34;0;31;0
WireConnection;35;0;33;0
WireConnection;36;0;34;0
WireConnection;38;0;37;0
WireConnection;39;0;36;0
WireConnection;39;1;35;0
WireConnection;41;0;39;0
WireConnection;40;0;38;0
WireConnection;42;0;40;0
WireConnection;45;0;43;0
WireConnection;48;0;45;0
WireConnection;48;1;44;0
WireConnection;57;0;47;0
WireConnection;57;1;46;0
WireConnection;51;0;50;0
WireConnection;53;0;48;0
WireConnection;53;1;49;0
WireConnection;60;0;54;0
WireConnection;60;1;55;0
WireConnection;59;0;52;0
WireConnection;59;1;51;0
WireConnection;59;2;56;0
WireConnection;58;0;53;0
WireConnection;58;1;57;0
WireConnection;63;0;59;0
WireConnection;63;1;60;0
WireConnection;62;0;58;0
WireConnection;71;0;53;0
WireConnection;70;0;64;0
WireConnection;70;1;54;0
WireConnection;70;2;66;0
WireConnection;69;0;65;0
WireConnection;69;1;63;0
WireConnection;69;2;61;0
WireConnection;28;0;27;0
WireConnection;28;1;1;0
WireConnection;28;2;26;0
WireConnection;80;0;70;0
WireConnection;80;1;68;0
WireConnection;80;2;67;0
WireConnection;73;0;75;0
WireConnection;73;1;58;0
WireConnection;75;0;53;0
WireConnection;72;0;54;0
WireConnection;79;0;69;0
WireConnection;79;1;68;0
WireConnection;79;2;67;0
WireConnection;25;0;80;0
WireConnection;25;2;79;0
WireConnection;25;3;74;0
WireConnection;25;4;76;0
WireConnection;25;10;77;0
ASEEND*/
//CHKSM=5A4F3B518944FB9396B7589563EEE3C336314D66