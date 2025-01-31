shader_type canvas_item;


uniform vec4 guideColor: source_color;
uniform sampler2D gradient;

uniform float limits[4]; // minA, maxA, minB, maxB
uniform vec2 points[10];
uniform bool on;
uniform int model = 0;

uniform float maxError = 10000.0;

const float guidePoints[3] = {0.1, 0.4, 0.7};
uniform float guideTolerance = 0.008;

vec4 sample_grad(float pos) {
	vec4 multiplier = vec4(1.0);
	for (int i = 0; i < 3; i ++) {
		if (abs(pos - guidePoints[i]) < guideTolerance) {
			multiplier = guideColor;
			break;
		}
	}
	return texture(gradient, vec2(pow(pos, 0.2), 0.5)) * multiplier;
}


float linear_regression_error(float a, float b) {
	float e = 0.0;
	for (int i = 0; i < 10; i++) {
		e += pow(-points[i][1] + a * points[i][0] + b, 2);
	}
	return min(e / maxError, 1.0);
}


float logistic_regression_error(float a, float b) {
	float e = 1.0;
	for (int i = 0; i < 10; i++) {
		float val = exp(a * points[i][0] + b);
		float p = val / (1.0 + val);
		if (points[i][1] > 0.5) e *= p;
		else e *= 1.0 - p;
	}
	return 1.0 - pow(e, 0.2);
}


float calculate_error(float a, float b) {
	float e = 0.0;
	switch (model) {
		case 0: // Linear regression
			e = linear_regression_error(a, b);
			break; 
		case 1: // Logistic regression
			e = logistic_regression_error(a, b);
			break;
	}
	return e;
}


void fragment() {
	float a = limits[0] + (limits[1] - limits[0]) * UV.x;
	float b = 1.0 - limits[2] - (limits[3] - limits[2]) * UV.y;
	
	if (on) COLOR = sample_grad(calculate_error(a, b));
	float e = calculate_error(a, b);
	//COLOR = vec4(vec3(e), 1.0);
}