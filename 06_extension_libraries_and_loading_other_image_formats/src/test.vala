using SDL;
using SDLImage;

public class HelloWorld {
	private Window window;
	private unowned Surface surface;
	private Surface pngSurface;

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
				} else if (e.type == EventType.KEYDOWN) {
					stdout.printf("%s\n", e.key.keysym.sym.to_string());
				}

				pngSurface.blit(null, surface, null);
				window.update_surface();
			}
		}
	}

	public void load_media() {
		Surface s = SDLImage.load("resources/loaded.png");
		pngSurface = s.convert(surface.format);
	}

	public void init() {
		SDL.init(SDL.InitFlag.VIDEO);
		SDLImage.init(SDLImage.InitFlags.PNG);

		window = Window.create("SDL Tutorial", Window.POS_CENTERED, Window.POS_CENTERED, 640, 480, Window.Flags.SHOWN);
		surface = window.get_surface();
		load_media();
	}

	public static void main(){
		var app = new HelloWorld();

		app.init();
		app.run();
	}
}
