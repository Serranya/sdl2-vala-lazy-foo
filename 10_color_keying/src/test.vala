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

	public void render(Renderer renderer, int x, int y) {
		Rectangle renderQuad = {x, y, width, height};
		renderer.copy(texture, null, renderQuad);
	}
}

public class HelloWorld {
	private static const int SCREEN_WIDTH = 640;
	private static const int SCREEN_HEIGHT = 480;

	private Window window;
	private Renderer renderer;
	private MyTexture fooTexture;
	private MyTexture backgroundTexture;

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

			renderer.set_draw_color(0xFF, 0xFF, 0xFF, Alpha.OPAQUE);
			renderer.clear();

			backgroundTexture.render(renderer, 0, 0);
			fooTexture.render(renderer, 240, 190);

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

		if (!SDL.Hints.set_hint(Hints.RENDER_SCALE_QUALITY, "1")) {
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
		fooTexture = MyTexture.from_file(renderer, "resources/foo.png");
		if (fooTexture == null) {
			stdout.puts("Failet to load foo texture image!\n");
			return false;
		}

		backgroundTexture = MyTexture.from_file(renderer, "resources/background.png");
		if (backgroundTexture == null) {
			stdout.puts("Failet to load background texture image!\n");
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
