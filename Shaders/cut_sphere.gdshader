shader_type spatial;

render_mode unshaded;

#include "funcs.gdshaderinc"
uniform vec3 spherePos;
uniform vec3 borderColor: source_color;
uniform float borderSize;
uniform float sphereRadius;
uniform float noiseSpeed;
uniform float noiseStrength;
uniform float noiseSize;
uniform bool invertCut;

uniform sampler2D _albedo: source_color;
varying vec3 wVex;

void vertex() {
	wVex = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
}

void fragment() {
	vec3 p = wVex-spherePos;
	float sdfSphere = sdSphere(p,sphereRadius);
	sdfSphere += (snoise(p*noiseSize+TIME*noiseSpeed)*noiseStrength);
	if (invertCut) {sdfSphere = sdfSphere;}
	else sdfSphere = -sdfSphere;
	float borderDist = smoothstep(0.0,borderSize,sdfSphere);

	//cut the sphere
	if (sdfSphere < 0.0) discard;
	vec3 albcolor =texture(_albedo,UV).rgb;
	vec3 bcol = borderColor;
	ALBEDO = (mix(bcol,albcolor,borderDist));
	EMISSION = (mix(bcol * 7.0,vec3(0.0),borderDist));
}
