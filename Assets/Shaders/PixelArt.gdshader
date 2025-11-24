shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float pixel_size = 4.0;

void fragment() {
    vec2 resolution = vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 pixel_uv = floor(SCREEN_UV * resolution / pixel_size) * pixel_size / resolution;
    COLOR = texture(SCREEN_TEXTURE, pixel_uv);
}