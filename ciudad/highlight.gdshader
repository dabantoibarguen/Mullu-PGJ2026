shader_type canvas_item;

uniform vec4 highlight_color : source_color = vec4(1.2, 1.2, 1.2, 1.0);
uniform float highlight_strength : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Only apply the highlight if the pixel is not transparent
    if (tex_color.a > 0.0) {
        // Blend original texture color with the highlight color
        vec3 final_rgb = mix(tex_color.rgb, highlight_color.rgb, highlight_strength);
        COLOR = vec4(final_rgb, tex_color.a);
    } else {
        // Keep transparent pixels transparent
        COLOR = tex_color;
    }
}