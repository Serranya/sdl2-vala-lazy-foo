using SDL;
using SDLImage;

public class HelloWorld {
	private static const int SCREEN_WIDTH = 640;
	private static const int SCREEN_HEIGHT = 480;

	private Window window;
	private Renderer renderer;
	private MyTexture modulatedTexture;

	~HelloWorld() {
		SDL.quit();
		SDLImage.quit();
	}

	public void run() {
		bool quit = false;
		Event e;
		uint8 r = 0xFF;
		uint8 g = 0xFF;
		uint8 b = 0xFF;

		while (!quit) {
			while (Event.poll(out e) != 0) {
				if (e.type == EventType.QUIT) {
					quit = true;
				} else if (e.type == EventType.KEYDOWN) {
					switch (e.key.keysym.sym) {
						case Keycode.Q:
						r += 32;
						break;

						case Keycode.W:
						g += 32;
						break;

						case Keycode.E:
						b +=32;
						break;

						case Keycode.A:
						r -= 32;
						break;

						case Keycode.S:
						g -= 32;
						break;

						case Keycode.D:
						b -= 32;
						break;
					}
				}
			}

			//Clear screen
			renderer.set_draw_color(0xFF, 0xFF, 0xFF, Alpha.OPAQUE);
			renderer.clear();

			modulatedTexture.set_color(r, g, b);
			modulatedTexture.render(renderer, 0, 0);

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
		modulatedTexture = MyTexture.from_file(renderer, "resources/colors.png");
		if (modulatedTexture == null) {
			stdout.puts("Failet to load colors texture!\n");
			return false;
		}

		return true;
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
