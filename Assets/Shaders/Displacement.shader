Shader "ProceduralShaders/Displacement"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Normal ("Normal Map", 2D) = "bump" {}
        _Height ("Height Map", 2D) = "bump" {}
        _HeightScale ("Height Scale", Range(0., 1.)) = 0.02
        _HeightPower ("Height Power", Range(0., 1.)) = 0
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Normal;
        sampler2D _Height;

        struct appdata {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            float4 texcoord1 : TEXCOORD1;
            float4 texcoord2 : TEXCOORD2;
            float4 texcoord3 : TEXCOORD3;
            fixed4 color : COLOR;
            uint instanceID : SV_InstanceID;
        };

        half _HeightScale;
        float _HeightPower;

        void vert(inout appdata v) {
            float4 heightMap = tex2Dlod(_Height, float4(v.texcoord.xy, 0, 0));
            v.vertex.z += heightMap.z * _HeightScale;
        }

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Normal;
            float2 uv_Height;
            float3 viewDir;
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 texOffset = ParallaxOffset(tex2D(_Height, IN.uv_Height).x, _HeightPower, IN.viewDir);
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal + texOffset));
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex + texOffset).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
