using SDL;
using SDLImage;
using SDLTTF;

public class HelloWorld {
	private static const int SCREEN_WIDTH = 640;
	private static const int SCREEN_HEIGHT = 480;

	private Window window;
	private Renderer renderer;
	private MyTexture pressTexture;
	private MyTexture upTexture;
	private MyTexture downTexture;
	private MyTexture leftTexture;
	private MyTexture rightTexture;

	~HelloWorld() {
		SDL.quit();
		SDLImage.quit();
	}

	public void run() {
		bool quit = false;
		Event e;
		MyTexture currentTexture;

		while (!quit) {
			while (Event.poll(out e) != 0) {
				if (e.type == EventType.QUIT) {
					quit = true;
				}

			}

			unowned uint8[] currentKeyStates = Keyboard.get_state();
			if (currentKeyStates[Scancode.UP] == 1) {
				currentTexture = upTexture;
			} else if (currentKeyStates[Scancode.DOWN] == 1) {
				currentTexture = downTexture;
			} else if (currentKeyStates[Scancode.LEFT] == 1) {
				currentTexture = leftTexture;
			} else if (currentKeyStates[Scancode.RIGHT] == 1) {
				currentTexture = rightTexture;
			} else {
				currentTexture = pressTexture;
			}

			//Clear screen
			renderer.set_draw_color(0xFF, 0xFF, 0xFF, Alpha.OPAQUE);
			renderer.clear();

			currentTexture.render(renderer, 0, 0);

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

		renderer = Renderer.create_renderer(window, -1, Renderer.Flags.ACCELERATED | Renderer.Flags.PRESENTVSYNC);
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

		if (SDLTTF.init() == -1) {
			stdout.printf("SDL_ttf could not initialize! SDL_ttf Error: %s\n", SDLTTF.get_error());
			return false;
		}

		return true;
	}

	public bool load_media() {
		pressTexture = MyTexture.from_file(renderer, "resources/press.png");
		if (pressTexture == null) {
			stdout.puts("Failed to load press texture!\n");
			return false;
		}

		upTexture = MyTexture.from_file(renderer, "resources/up.png");
		if (upTexture == null) {
			stdout.puts("Failed to load up texture!\n");
			return false;
		}

		downTexture = MyTexture.from_file(renderer, "resources/down.png");
		if (downTexture == null) {
			stdout.puts("Failed to load down texture!\n");
			return false;
		}

		leftTexture = MyTexture.from_file(renderer, "resources/left.png");
		if (leftTexture == null) {
			stdout.puts("Failed to load left texture!\n");
			return false;
		}

		rightTexture = MyTexture.from_file(renderer, "resources/right.png");
		if (rightTexture == null) {
			stdout.puts("Failed to load right texture!\n");
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
