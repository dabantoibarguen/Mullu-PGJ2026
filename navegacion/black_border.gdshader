shader_type canvas_item;

// Allows you to change the color from the inspector (defaults to black)
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    // Get the size of an individual pixel in UV coordinates
    vec2 size = TEXTURE_PIXEL_SIZE / vec2(2,2);
    
    // Sample the current pixel's color
    vec4 current_color = texture(TEXTURE, UV);
    
    // Check alpha of the 4 surrounding pixels (up, down, left, right)
    float alpha = current_color.a;
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, -size.y)).a); // Up
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, size.y)).a);  // Down
    alpha = max(alpha, texture(TEXTURE, UV + vec2(-size.x, 0.0)).a); // Left
    alpha = max(alpha, texture(TEXTURE, UV + vec2(size.x, 0.0)).a);  // Right
    
    // Combine the original sprite texture with the outline
    vec4 final_color = mix(outline_color, current_color, current_color.a);
    
    // Apply the outline alpha mesh boundary
    COLOR = vec4(final_color.rgb, alpha);
}