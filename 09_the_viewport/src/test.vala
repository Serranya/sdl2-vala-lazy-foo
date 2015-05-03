using SDL;
using SDLImage;

public class HelloWorld {
	private static const int SCREEN_WIDTH = 640;
	private static const int SCREEN_HEIGHT = 480;

	private Window window;
	private Renderer renderer;
	private Texture texture;

	~HelloWorld() {
		SDL.quit();
		SDLImage.quit();
	}

	public void run() {
		bool quit = false;
		Event e;

		while (!quit) {
			while (Event.poll(out e) != 0) {
				quit = e.type == EventType.QUIT;
			}

			//Clear screen
			renderer.set_draw_color(0xFF, 0xFF, 0xFF, Alpha.OPAQUE);
			renderer.clear();

			//Top left corner viewport
			Rectangle topLeftViewport = {0, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2};
			renderer.set_viewport(topLeftViewport);

			//Render texture to screen
			renderer.copy(texture, null, null);

			//Top right viewport
			Rectangle topRightViewport = {SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT /2};
			renderer.set_viewport(topRightViewport);

			//Render texture to screen
			renderer.copy(texture, null, null);

			//Bottom viewport
			Rectangle bottomViewport = {0, SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT / 2};
			renderer.set_viewport(bottomViewport);

			//Render texture to screen
			renderer.copy(texture, null, null);

			renderer.present();
		}
	}

	public bool init() {
		if (SDL.init(SDL.InitFlag.VIDEO) < 0) {
			stdout.printf("SDL could not initialize! SDL Error: %s\n", SDL.get_error());
			return false;
		}

		if (SDLImage.init(SDLImage.InitFlags.PNG) < 0) {
			stdout.printf("SDL_image could not initialize! SDL_image Error: %s\n", SDLImage.get_error());
			return false;
		}

		if (!SDL.Hints.set(Hints.RENDER_SCALE_QUALITY, "1")) {
			stdout.puts("Warining: Linear texture filtering not enabled!");
		}

		window = Window.create("SDL Tutorial", Window.POS_CENTERED, Window.POS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, Window.Flags.SHOWN);
		if (window == null) {
			stdout.printf("Window could not be created! SDL Error: %s\n", SDL.get_error());
			return false;
		}

		renderer = Renderer.create_renderer(window, -1, Renderer.Flags.ACCELERATED);
		if (renderer == null) {
			stdout.printf("Renderer could not be created! SDL Error: %s\n", SDL.get_error());
			return false;
		}

		renderer.set_draw_color(0xFF, 0xFF, 0xFF, Alpha.OPAQUE);

		int imgInitFlags = SDLImage.InitFlags.PNG;
		int initResult = SDLImage.init(imgInitFlags);
		if ((initResult & imgInitFlags) != imgInitFlags) {
			stdout.printf("SDL_image could not initialize! SDL_image Error: %s\n", SDLImage.get_error());
			return false;
		}
		return true;
	}

	public bool load_media() {
		texture = loadTexture("resources/viewport.png");
		if (texture == null) {
			stdout.puts("Failet to load texture image!\n");
			return false;
		}
		return true;
	}

	private Texture loadTexture(string path) {
		Texture newTexture = null;
		Surface loadedSurface = SDLImage.load(path);
		if (loadedSurface == null) {
			stdout.printf("Unable to load image %s! SDL_image Error: %s\n", path, SDLImage.get_error());
		} else {
			newTexture = Texture.create_from_surface(renderer, loadedSurface);
			if (newTexture == null) {
				stdout.printf("Unable to create texture from %s! SDL Error: %s\n", path, SDL.get_error());
			}
		}
		return newTexture;
	}

	public static void main(){
		var app = new HelloWorld();

		if (!app.init()) {
			stdout.puts("failed to initialize!\n");
		} else {
			if (!app.load_media()) {
				stdout.puts("Failed to load media!\n");
			} else {
				app.run();
			}
		}
	}
}
