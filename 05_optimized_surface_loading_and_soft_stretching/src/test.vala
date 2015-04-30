using SDL;

public class HelloWorld {
	private Window window;
	private unowned Surface surface;
	private Surface stretchedSurface;

	~HelloWorld() {
		SDL.quit();
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

				Rectangle rect = Rectangle();
				rect.x = 0;
				rect.y = 0;
				rect.w = 640;
				rect.h = 480;

				stretchedSurface.blit_scaled(null, surface, rect);
				window.update_surface();
			}
		}
	}

	public void load_media() {
		Surface surface = Surface.load_bmp("resources/stretch.bmp");
		stretchedSurface = surface.convert(surface.format);
	}

	public void init() {
		SDL.init(InitFlag.VIDEO);

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
