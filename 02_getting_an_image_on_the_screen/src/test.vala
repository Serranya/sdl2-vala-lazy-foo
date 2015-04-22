using SDL;

public class HelloWorld {
	private Window window;
	private Surface surface;
	private Surface helloSurface;

	~HelloWorld() {
		SDL.quit();
	}

	public void run() {
		helloSurface.blit(null, surface, null);

		window.update_surface();

		SDL.Timer.delay(2000);
	}

	public void load_media() {
		helloSurface = Surface.load_bmp("resources/hello_world.bmp");
	}

	public void init() {
		SDL.init(InitFlag.EVERYTHING);

		window = Window.create("SDL Tutorial", Window.POS_CENTERED, Window.POS_CENTERED, 640, 480, Window.Flags.SHOWN);
		surface = window.get_surface().ref();
		load_media();
	}

	public static void main(){
		var app = new HelloWorld();

		app.init();
		app.run();
	}
}
