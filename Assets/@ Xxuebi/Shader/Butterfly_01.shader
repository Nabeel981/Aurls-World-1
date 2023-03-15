// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "@Xxuebi/Butterfly_01"
{
	Properties
	{
		_Main_Tex("Main_Tex", 2D) = "white" {}
		[HDR]_Main_Color("Main_Color", Color) = (1,1,1,1)
		_Ver_Tex("Ver_Tex", 2D) = "white" {}
		_Ver_UV_Speed("Ver_UV_Speed", Vector) = (0,0,0,0)
		_Ver_Int("Ver_Int", Float) = 1
		_Ver_Mask("Ver_Mask", 2D) = "white" {}
		_Ver_Min("Ver_Min", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Ver_Tex;
			uniform float4 _Ver_UV_Speed;
			uniform float4 _Ver_Tex_ST;
			uniform float _Ver_Min;
			uniform float _Ver_Int;
			uniform sampler2D _Ver_Mask;
			uniform float4 _Ver_Mask_ST;
			uniform float4 _Main_Color;
			uniform sampler2D _Main_Tex;
			uniform float4 _Main_Tex_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float mulTime22 = _Time.y * _Ver_UV_Speed.z;
				float2 texCoord23 = v.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult20 = (float2(_Ver_UV_Speed.x , _Ver_UV_Speed.y));
				float2 uv_Ver_Tex = v.ase_texcoord.xy * _Ver_Tex_ST.xy + _Ver_Tex_ST.zw;
				float2 panner10 = ( ( mulTime22 + texCoord23.x ) * appendResult20 + uv_Ver_Tex);
				float2 uv_Ver_Mask = v.ase_texcoord.xy * _Ver_Mask_ST.xy + _Ver_Mask_ST.zw;
				
				o.ase_color = v.color;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( (_Ver_Min + (tex2Dlod( _Ver_Tex, float4( panner10, 0, 0.0) ).r - 0.0) * (1.0 - _Ver_Min) / (1.0 - 0.0)) * _Ver_Int ) * v.ase_normal * tex2Dlod( _Ver_Mask, float4( uv_Ver_Mask, 0, 0.0) ).r );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_Main_Tex = i.ase_texcoord1.xy * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
				float4 tex2DNode1 = tex2D( _Main_Tex, uv_Main_Tex );
				clip( ( i.ase_color.a * _Main_Color.a * tex2DNode1.a ) - 0.01);
				
				
				finalColor = ( i.ase_color * _Main_Color * tex2DNode1 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
372.6667;454;1436;925;2531.736;951.9247;3.152158;True;False
Node;AmplifyShaderEditor.Vector4Node;19;-1215.107,487.6602;Inherit;False;Property;_Ver_UV_Speed;Ver_UV_Speed;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;2,0,-1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;22;-972.1069,592.6602;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1183.35,749.7368;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-740.3496,618.7368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-884.1964,325.5691;Inherit;False;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;20;-939.1069,460.6602;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;10;-569.5599,377.7734;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;91.54919,612.2112;Inherit;False;Property;_Ver_Min;Ver_Min;6;0;Create;True;0;0;0;False;0;False;1;-0.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-226.6022,358.2226;Inherit;True;Property;_Ver_Tex;Ver_Tex;2;0;Create;True;0;0;0;False;0;False;-1;None;b6212b67d43598d4ba607b5d9adb4bab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;361.84,809.1049;Inherit;False;Property;_Ver_Int;Ver_Int;4;0;Create;True;0;0;0;False;0;False;1;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;26;-443.1435,-409.7052;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-536.0754,-15.43043;Inherit;True;Property;_Main_Tex;Main_Tex;0;0;Create;True;0;0;0;False;0;False;-1;None;363ea097febd5b143a0f3929541d637f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-472.3162,-216.9189;Inherit;False;Property;_Main_Color;Main_Color;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;29;304.0225,478.8303;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;308.8933,1064.823;Inherit;False;0;17;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-0.3036513,-36.24202;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;96.33257,214.7983;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;613.8003,1040.092;Inherit;True;Property;_Ver_Mask;Ver_Mask;5;0;Create;True;0;0;0;False;0;False;-1;None;1f5e9dca855cb83489476c7675a0b815;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;7;744.116,860.9725;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;0.1407655,-219.9379;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;654.5245,617.6865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;4;403.6308,110.305;Inherit;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;1169.127,457.4644;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;827.2849,-34.27983;Float;False;True;-1;2;ASEMaterialInspector;100;1;@Xxuebi/Butterfly_01;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;22;0;19;3
WireConnection;24;0;22;0
WireConnection;24;1;23;1
WireConnection;20;0;19;1
WireConnection;20;1;19;2
WireConnection;10;0;11;0
WireConnection;10;2;20;0
WireConnection;10;1;24;0
WireConnection;6;1;10;0
WireConnection;29;0;6;1
WireConnection;29;3;30;0
WireConnection;28;0;26;4
WireConnection;28;1;2;4
WireConnection;28;2;1;4
WireConnection;17;1;18;0
WireConnection;27;0;26;0
WireConnection;27;1;2;0
WireConnection;27;2;1;0
WireConnection;8;0;29;0
WireConnection;8;1;9;0
WireConnection;4;0;27;0
WireConnection;4;1;28;0
WireConnection;4;2;5;0
WireConnection;16;0;8;0
WireConnection;16;1;7;0
WireConnection;16;2;17;1
WireConnection;0;0;4;0
WireConnection;0;1;16;0
ASEEND*/
//CHKSM=F41F80B9F7E416C44DE361EE6E6C561175774079