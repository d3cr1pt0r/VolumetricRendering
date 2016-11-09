bool sphereHit(float3 position, float3 center, float radius) {
	return distance(position, center) < radius;
}

float sphereDistance(float3 position, float3 center, float radius) {
	return distance(position, center) - radius;
}

float sphereDoubleDistance(float3 position, float3 center, float radius) {
	return min(
		sphereDistance(position, center - float3(0.1, 0, 0), radius),
		sphereDistance(position, center + float3(0.1, 0, 0), radius)
	);
}

float3 getNormal(float3 position, float3 center, float radius, float eps) {
	return normalize(
		float3(
			sphereDoubleDistance(position + float3(eps, 0, 0), center, radius) - sphereDoubleDistance(position - float3(eps, 0, 0), center, radius),
			sphereDoubleDistance(position + float3(0, eps, 0), center, radius) - sphereDoubleDistance(position - float3(0, eps, 0), center, radius),
			sphereDoubleDistance(position + float3(0, 0, eps), center, radius) - sphereDoubleDistance(position - float3(0, 0, eps), center, radius)
		)
	);
}

fixed4 renderSurface(float3 position, float3 center, float radius, float eps) {
	float3 n = getNormal(position, center, radius, eps);
	return fixed4(n.r, n.g, n.b, 1.0);
}

fixed4 raymarchSphere1(float3 position, float3 direction, float3 center, float radius, float steps, float step_size) {
	for(int i=0; i < steps; i++) {
		if (sphereHit(position, center, radius)) {
			return 1;
		}

		position += direction * step_size;
	}

	return 0;
}

fixed4 raymarchSphere2(float3 position, float3 direction, float3 center, float radius, float min_dist, float steps, float magic) {
	for(int i=0; i < steps; i++) {
		float dist = sphereDistance(position, center, radius);

		if (dist < min_dist) {
			return (i / steps) * magic;
		}

		position += dist * direction;
	}

	return 0;
}

fixed4 raymarchSphere3(float3 position, float3 direction, float3 center, float radius, float min_dist, float steps, float eps) {
	for(int i=0; i < steps; i++) {
		float dist = sphereDoubleDistance(position, center, radius);

		if (dist < min_dist) {
			return renderSurface(position, center, radius, eps);
		}

		position += dist * direction;
	}

	return 0;
}