using SDL;

public class HelloWorld {
	private Window window;
	private unowned Surface surface;
	private Surface[] surfaces = new Surface[5];

	~HelloWorld() {
		SDL.quit();
	}

	public void run() {
		bool quit = false;
		Event e;
		unowned Surface currentSurface = surfaces[0];

		while (!quit) {
			while (Event.poll(out e) != 0) {
				if (e.type == EventType.QUIT) {
					quit = true;
				} else if (e.type == EventType.KEYDOWN) {
					stdout.printf("%s\n", e.key.keysym.sym.to_string());
					switch (e.key.keysym.sym) {
						case Keycode.UP:
							currentSurface = surfaces[1];
							break;
						case Keycode.DOWN:
							currentSurface = surfaces[2];
							break;
						case Keycode.LEFT:
							currentSurface = surfaces[3];
							break;
						case Keycode.RIGHT:
							currentSurface = surfaces[4];
							break;
						default:
							currentSurface = surfaces[0];
							break;
					}
				}
			}
			currentSurface.blit(null, surface, null);
			window.update_surface();
		}
	}

	public void load_media() {
		surfaces[0] = Surface.load_bmp("resources/press.bmp");
		surfaces[1] = Surface.load_bmp("resources/up.bmp");
		surfaces[2] = Surface.load_bmp("resources/down.bmp");
		surfaces[3] = Surface.load_bmp("resources/left.bmp");
		surfaces[4] = Surface.load_bmp("resources/right.bmp");
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
