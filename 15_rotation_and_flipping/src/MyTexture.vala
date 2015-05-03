using SDL;
using SDLImage;

public class MyTexture : Object {
	private Texture texture;
	public int width {get; private set;}
	public int height {get; private set;}

	public static MyTexture? from_file(Renderer renderer, string path) {
		MyTexture mt = new MyTexture();
		Surface loadedSurface = SDLImage.load(path);

		if (loadedSurface == null) {
			stdout.printf("Unable to load image %s! SDL_image Error: %s\n", path, SDLImage.get_error());
			return null;
		} else {
			loadedSurface.set_colorkey(true, loadedSurface.format.map_rgb(0, 0xFF, 0xFF));

			mt.texture = Texture.create_from_surface(renderer, loadedSurface);
			if (mt.texture == null) {
				stdout.printf("Unable to create texture from %s! SDL Error: %s\n", path, SDL.get_error());
			} else {
				mt.width = loadedSurface.w;
				mt.height = loadedSurface.h;
			}
		}

		return mt;
	}

	public void render(Renderer renderer, int x, int y, Rectangle? clip = null, double angle = 0.0, Point? center = null, Renderer.Flip flip = Renderer.Flip.NONE) {
		Rectangle renderQuad = {x, y, width, height};
		if (clip != null) {
			renderQuad.w = clip.w;
			renderQuad.h = clip.h;
		}
		renderer.copy_ex(texture, clip, renderQuad, angle, center, flip);
	}

	public void set_color(uint8 red, uint8 green, uint8 blue) {
		texture.set_color_mod(red, green, blue);
	}

	public void set_blendmode(BlendMode blending) {
		texture.set_blendmode(blending);
	}

	public void set_alpha(uint8 alpha) {
		texture.set_alpha(alpha);
	}
}
