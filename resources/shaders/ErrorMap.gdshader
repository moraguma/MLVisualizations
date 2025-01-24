shader_type canvas_item;


uniform sampler2D gradient;
uniform float minA = -1.0;
uniform float maxA = 1.0;
uniform float minB = 0.25;
uniform float maxB = 0.75;
uniform vec2 points[10];
uniform float maxError = 10000.0;


vec4 sample_grad(float pos) {
	return texture(gradient, vec2(pow(pos, 0.2), 0.5));
}


void fragment() {
	float a = minA + (maxA - minA) * UV.x;
	float b = (maxB + (minB - maxB) * UV.y) * 500.0;
	
	float e = 0.0;
	for (int i = 0; i < 10; i++) {
		e += pow(points[i][1] + a * points[i][0] + b, 2);
	}
	COLOR = sample_grad(min(e / maxError, 1.0));
}
