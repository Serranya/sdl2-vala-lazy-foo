using SDL;

public class HelloWorld {
	private Window window;
	private unowned Surface surface;
	private Surface xOutSurface;

	~HelloWorld() {
		SDL.quit();
	}

	public void run() {
		bool quit = false;
		Event e;
		int ret = 0;

		while (!quit) {
			while ((ret = Event.poll(out e)) != 0) {
				quit = e.type == EventType.QUIT;
				stdout.printf("Poll: %d\n", ret);
			}

			stdout.puts("No events anymore or quit...\n");
			xOutSurface.blit(null, surface, null);
			window.update_surface();
		}
	}

	public void load_media() {
		xOutSurface = Surface.load_bmp("resources/x.bmp");
	}

	public void init() {
		SDL.init(InitFlag.EVERYTHING);

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
