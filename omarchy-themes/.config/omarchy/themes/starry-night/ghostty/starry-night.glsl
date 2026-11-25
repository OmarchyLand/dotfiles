// Starry Night — subtle Ghostty background shader inspired by Van Gogh.
// Slow cobalt/teal swirls and a few twinkling gold stars, drawn only
// where the terminal shows its background colour, so text stays crisp.

const vec3 BG     = vec3(0.055, 0.102, 0.200); // #0e1a33
const vec3 COBALT = vec3(0.184, 0.310, 0.561); // #2f4f8f
const vec3 TEAL   = vec3(0.435, 0.702, 0.769); // #6fb3c4
const vec3 GOLD   = vec3(0.949, 0.784, 0.294); // #f2c84b

const float SWIRL_STRENGTH = 0.24;  // raise for a bolder sky
const float STAR_STRENGTH  = 0.9;
const float SPEED          = 0.035;

float hash(vec2 p) {
  p = fract(p * vec2(123.34, 456.21));
  p += dot(p, p + 45.32);
  return fract(p.x * p.y);
}

float noise(vec2 p) {
  vec2 i = floor(p), f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(mix(hash(i), hash(i + vec2(1, 0)), u.x),
             mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), u.x), u.y);
}

float fbm(vec2 p) {
  float v = 0.0, a = 0.5;
  for (int i = 0; i < 4; i++) { v += a * noise(p); p = p * 2.03 + 17.0; a *= 0.5; }
  return v;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord / iResolution.xy;
  vec4 term = texture(iChannel0, uv);

  // Only paint the empty background, never glyphs or selections.
  float bgMask = 1.0 - smoothstep(0.02, 0.10, distance(term.rgb, BG));

  float aspect = iResolution.x / iResolution.y;
  vec2 p = vec2(uv.x * aspect, uv.y) * 2.2;
  float t = iTime * SPEED;

  // Domain-warped noise gives the brushstroke swirl.
  vec2 q = vec2(fbm(p + t), fbm(p + vec2(5.2, 1.3) - t));
  vec2 r = vec2(fbm(p + 3.0 * q + vec2(1.7, 9.2) + t * 0.7),
                fbm(p + 3.0 * q + vec2(8.3, 2.8) - t * 0.6));
  float f = fbm(p + 3.5 * r);

  // Streaky bands along the swirl, like impasto strokes.
  float strokes = 0.5 + 0.5 * sin(f * 18.0 + length(r) * 6.0);
  vec3 sky = mix(COBALT, TEAL, smoothstep(0.45, 0.85, f));
  float swirl = smoothstep(0.35, 0.9, f) * (0.6 + 0.4 * strokes);

  // Sparse twinkling stars with a soft halo.
  vec2 grid = fragCoord / 90.0;
  vec2 cell = floor(grid);
  float seed = hash(cell);
  float star = 0.0;
  if (seed > 0.93) {
    vec2 c = vec2(hash(cell + 3.1), hash(cell + 7.7)) * 0.6 + 0.2;
    float d = length(fract(grid) - c);
    float twinkle = 0.55 + 0.45 * sin(iTime * (0.6 + seed * 1.4) + seed * 40.0);
    star = (smoothstep(0.05, 0.0, d) + 0.35 * smoothstep(0.28, 0.0, d)) * twinkle;
  }

  vec3 col = term.rgb;
  col = mix(col, sky, swirl * SWIRL_STRENGTH * bgMask);
  col += GOLD * star * STAR_STRENGTH * 0.4 * bgMask;

  fragColor = vec4(col, term.a);
}
