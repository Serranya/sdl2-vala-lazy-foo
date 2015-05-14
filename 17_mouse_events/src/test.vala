using SDL;
using SDLImage;
using SDLTTF;

public class HelloWorld {
	private static const int SCREEN_WIDTH = 640;
	private static const int SCREEN_HEIGHT = 480;

	private Window window;
	private Renderer renderer;
	private MyButton[] buttons = new MyButton[4];

	~HelloWorld() {
		SDL.quit();
		SDLImage.quit();
	}

	public void run() {
		bool quit = false;
		Event e;

		while (!quit) {
			while (Event.poll(out e) != 0) {
				if (e.type == EventType.QUIT) {
					quit = true;
				}

				foreach (MyButton b in buttons) {
					b.handle_event(e);
				}
			}

			//Clear screen
			renderer.set_draw_color(0xFF, 0xFF, 0xFF, Alpha.OPAQUE);
			renderer.clear();

			foreach (MyButton b in buttons) {
				b.render(renderer);
			}

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
		MyTexture buttonSpriteSheetTexture = MyTexture.from_file(renderer, "resources/button.png");
		if (buttonSpriteSheetTexture == null) {
			stdout.puts("Failed to load button sprite texture!\n");
			return false;
		}

		MyButton.init(buttonSpriteSheetTexture);

		int button_width = MyButton.BUTTON_WIDTH;
		int button_height = MyButton.BUTTON_HEIGHT;
		for (int i = 0; i < buttons.length; i++) {
			buttons[i] = new MyButton();
		}
		buttons[0].x = 0;
		buttons[0].y = 0;
		buttons[1].x = SCREEN_WIDTH - button_width;
		buttons[1].y = 0;
		buttons[2].x = 0;
		buttons[2].y = SCREEN_HEIGHT - button_height;
		buttons[3].x = SCREEN_WIDTH -button_width;
		buttons[3].y = SCREEN_HEIGHT - button_height;

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
