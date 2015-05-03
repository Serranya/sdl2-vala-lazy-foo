using SDL;

public class MyButton : Object {

	private enum ButtonSprite {
		MOUSE_OUT,
		MOUSE_OVER_MOTION,
		MOUSE_DOWN,
		MOUSE_UP;
	}

	public static const int BUTTON_WIDTH = 300;
	public static const int BUTTON_HEIGHT = 200;

	private static MyTexture buttonSpriteSheetTexture;
	private static Rectangle spriteClips[4];
	private Point position = Point() {x = 0, y = 0};
	private ButtonSprite currentSprite = ButtonSprite.MOUSE_OUT;

	static construct {
		for (int i = 0; i < 4; ++i) {
			spriteClips[i].x = 0;
			spriteClips[i].y = i * 200;
			spriteClips[i].w = BUTTON_WIDTH;
			spriteClips[i].h = BUTTON_HEIGHT;
		}
	}

	public static void init(MyTexture texture) {
		buttonSpriteSheetTexture = texture;
	}

	public int x {
		get { return position.x; }
		set {position.x = value;}
	}

	public int y {
		get { return position.y; }
		set {position.y = value;}
	}

	public void handle_event(Event e) {
		if (e.type == EventType.MOUSEMOTION
		 || e.type == EventType.MOUSEBUTTONDOWN
		 || e.type == EventType.MOUSEBUTTONUP) {
			int x, y;
			Cursor.get_state(out x, out y);
			bool inside = true;

			if (x < position.x)
				inside =false;
			else if (x > position.x + BUTTON_WIDTH)
				inside = false;
			else if (y < position.y)
				inside = false;
			else if (y > position.y + BUTTON_HEIGHT)
				inside = false;

			if (!inside) {
				currentSprite = ButtonSprite.MOUSE_OUT;
			} else {
				switch (e.type) {
					case EventType.MOUSEMOTION:
					currentSprite = ButtonSprite.MOUSE_OVER_MOTION;
					break;

					case EventType.MOUSEBUTTONDOWN:
					currentSprite = ButtonSprite.MOUSE_DOWN;
					break;

					case EventType.MOUSEBUTTONUP:
					currentSprite = ButtonSprite.MOUSE_UP;
					break;
				}
			}
		}
	}

	public void render(Renderer renderer) {
		buttonSpriteSheetTexture.render(renderer, position.x, position.y, spriteClips[currentSprite]);
	}
}
