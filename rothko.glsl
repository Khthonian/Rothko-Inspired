// Created by Stewart Charles Fisher II
// Submission made for CMP3018M
// https://www.shadertoy.com/view/DdfSz4


vec2 random( in vec2 u )
{
    u = vec2( dot(u,vec2(200.0, 300.0)),
              dot(u,vec2(400.0, 500.0)));
    
    return -2.0 + 3.0*fract(sin(u)*45678.90);
}

float perlinNoise( in vec2 x )
{
    vec2 f = fract(x);
    vec2 i = floor(x);
    
    vec2 w = smoothstep(0.0, 1.0, f);
    
    // Interpolation of the dot product for each grid intersection
    return mix( mix( dot( random(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), w.x),
                mix( dot( random(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), w.x), w.y);
}

float rectangle( in vec2 pos, in vec2 size )
{
    vec2 a = abs(pos) - size;
    return length(max(a, vec2(0))) + min(max(a.x, a.y), 0.0);
    
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Time variables
    float timeSpeed = 5.0;
    float sintime = abs(sin(iTime / timeSpeed));
    float costime = abs(cos(iTime / timeSpeed));
    float tantime = abs(tan(iTime / (0.5 * timeSpeed)));
    
    // Zoom variables
    float lowerZoom = 0.1;
    float upperZoom = 0.1;
    float rightZoom = 0.1;
    
    // List of colours
    vec3 green = vec3(0.0, 0.61, 0.22);
    vec3 yellow = vec3(1.0, 0.82, 0.0);
    vec3 grey = vec3(0.1, 0.1, 0.1);
    vec3 white = vec3(1.0, 1.0, 1.0);
    vec3 red = vec3(0.6, 0.0, 0.0);
    vec3 blue = vec3(0.0, 0.0, 0.6);
    vec3 canvas = vec3(1.0, 0.98, 0.90);
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord.xy/iResolution.xy;
    uv.x -= 0.5;
    
    // Create base background colour
    vec3 colour = vec3(canvas);
    
    // Add noise to background to create canvas effect
    float noise = perlinNoise(uv * 300.0);
    colour = mix(colour, white, noise);
    
    // Set the frequency and amplitude
    // Frequency affects the 'cleanliness' on the edges of the rectangles, lower freq = more clean
    float frequency = 200.0;
    // Amplitude affects the 'spread' of the boxes, lower amplitude = more spread
    float amplitude = 100.0;
    
    // Create lower rectangle
    vec2 lowerPos = uv - vec2(-0.17, 0.2) + perlinNoise(uv * frequency) / amplitude;
    vec2 lowerSize = vec2(0.15, 0.04);
    float lowerRect = step(lowerZoom, rectangle(lowerPos, lowerSize));
    vec3 lowerColour = mix(green, yellow, sintime);
    colour = mix(colour, lowerColour, (1.0 - lowerRect) / 2.0);
    
    // Create upper rectangle
    vec2 upperPos = uv - vec2(-0.15, 0.65) + perlinNoise(uv * frequency) / amplitude;
    vec2 upperSize = vec2(0.2, 0.15);
    float upperRect = step(upperZoom, rectangle(upperPos, upperSize));
    vec3 upperColour = mix(green, yellow, costime);
    colour = mix(colour, upperColour, (1.0 - upperRect) / 2.0);
    
    // Create right hand side rectangle
    vec2 rightPos = uv - vec2(0.3, 0.5) + perlinNoise(uv * frequency) / amplitude;
    vec2 rightSize = vec2(0.03, 0.3);
    float rightRect = step(rightZoom, rectangle(rightPos, rightSize));
    vec3 rightColour = mix(green, blue, sintime);
    colour = mix(colour, rightColour, (1.0 - rightRect) / 2.0);

    // Output to screen
    fragColor = vec4(colour, 1.0);
}