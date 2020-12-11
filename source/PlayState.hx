package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.FlxTrail;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	/* All moving sprites */
	var playerTwo:FlxSprite;
	var playerOne:FlxSprite;
	var ball:FlxSprite;

	/* Secondary sprites */
	var barriers:FlxGroup;
	var lPanel:FlxSprite;
	var rPanel:FlxSprite;
	var tPanel:FlxSprite;
	var bPanel:FlxSprite;

	/* All in game sounds */
	var collisionSound:FlxSound;
	var endGameSound:FlxSound;
	var wallBounceSound:FlxSound;
	var winnerSound:FlxSound;

	/* All in-game text */
	var _txtTitle:FlxText;
	var _txtMessage:FlxText;

	var scores:Array<Int> = [];

	// Get the score value
	var player1Score:Float;
	var player2Score:Float;

	// Create and add the text to the screen
	var player1ScoreText:FlxText;
	var player2ScoreText:FlxText;

	var _player1ScoreText:FlxText;
	var _player2ScoreText:FlxText;

	override public function create():Void
	{
		/* Adding a static background image */
		FlxG.camera.bgColor = 0xFF666666; // standard backdrop
		var bg:FlxSprite = new FlxSprite(0, 0);
		bg.loadGraphic(AssetPaths.bg__png);
		var bg:FlxBackdrop = new FlxBackdrop(AssetPaths.bg__png, 2, 0, true, false);
		// add elements (static background) onto screen
		add(bg);

		/* loading soundfiles in */
		collisionSound = FlxG.sound.load(AssetPaths.bpp__wav);
		endGameSound = FlxG.sound.load(AssetPaths.tlr__wav);
		wallBounceSound = FlxG.sound.load(AssetPaths.brrp__wav);
		winnerSound = FlxG.sound.load(AssetPaths.zzp__wav);

		/* creation of sprite paddle/racket one */
		playerOne = new FlxSprite(350, 450);
		playerOne.makeGraphic(60, 5, FlxColor.LIME);
		playerOne.immovable = true;
		/* creation of sprite paddle/racket two */
		playerTwo = new FlxSprite(150, 450);
		playerTwo.makeGraphic(60, 5, FlxColor.CYAN);
		playerTwo.immovable = true;
		// add elements (player paddles) onto screen
		add(playerOne);
		add(playerTwo);

		/* creation of sprite ball */
		ball = new FlxSprite(200, 180);
		ball.makeGraphic(10, 5, FlxColor.ORANGE);
		/* setting behaviour attributes for sprite ball */
		ball.elasticity = 1;
		ball.maxVelocity.set(222, 222);
		ball.velocity.y = 500;
		ball.velocity.x = 500;
		// Create trail
		var trail:FlxTrail = new FlxTrail(ball);
		// add elements (ball w/trail) onto screen
		add(trail);
		add(ball);

		/* creation and grouping of all barriers, i.e. simulating a squash court */
		barriers = new FlxGroup();
		lPanel = new FlxSprite(0, 0); // left side panel
		lPanel.makeGraphic(5, 540, FlxColor.GRAY);
		lPanel.immovable = true;
		barriers.add(lPanel);
		rPanel = new FlxSprite(550, 0); // right side panel
		rPanel.makeGraphic(5, 550, FlxColor.GRAY);
		rPanel.immovable = true;
		barriers.add(rPanel);
		tPanel = new FlxSprite(0, 0); // top side panel
		tPanel.makeGraphic(550, 10, FlxColor.GRAY);
		tPanel.immovable = true;
		barriers.add(tPanel);
		bPanel = new FlxSprite(0, 465); // bottom side panel
		bPanel.makeGraphic(550, 10, FlxColor.TRANSPARENT);
		bPanel.immovable = true;
		barriers.add(bPanel);
		// add elements (barriers) onto screen
		add(barriers);

		// If the value was not initialised, default to zero
		if (!(scores[0] > 0))
			scores[0] = 0;
		if (!(scores[1] > 0))
			scores[1] = 0;

		player1Score = scores[0];
		player2Score = scores[1];

		player1ScoreText = new FlxText(565, 25, 0, "P1 Score: ", 9);
		add(player1ScoreText);

		player2ScoreText = new FlxText(564, 225, 0, "P2 Score: ", 9);
		add(player2ScoreText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		/* Make sure both players are stationary */
		playerOne.velocity.x = 0;
		playerTwo.velocity.x = 0;

		/* Movement controls for P1 */
		if (FlxG.keys.pressed.LEFT && playerOne.x > 10)
		{
			playerOne.velocity.x = -500;
		}
		else if (FlxG.keys.pressed.RIGHT && playerOne.x < 500)
		{
			playerOne.velocity.x = 480;
		}
		/* Movement controls for P2 */
		if (FlxG.keys.pressed.A && playerTwo.x > 10)
		{
			playerTwo.velocity.x = -500;
		}
		else if (FlxG.keys.pressed.D && playerTwo.x < 500)
		{
			playerTwo.velocity.x = 480;
		}
		/* Hard reset button */
		if (FlxG.keys.justReleased.R)
		{
			FlxG.resetState();
		}
		/* Add to score, play collision sound and show winner on screen text, all for P1 */
		if (FlxG.collide(playerOne, ball))
		{
			collisionSound.play();
			scores[0] += 1;
			_player1ScoreText = new FlxText(615, 25, 0, "" + scores[0], 9);
			add(_player1ScoreText);
			if (scores[0] == 10)
			{
				_txtMessage = new FlxText(200, 85, 0, "Congratulations P1! 
										         You Won!", 14);
				add(_txtMessage);
				winnerSound.play();
				FlxG.camera.fade(FlxColor.BLUE, .15, true);
				ball.velocity.y = 0;
			}
		}
		/* Add to score, play collision sound and show winner on screen text, all for P2 */
		if (FlxG.collide(playerTwo, ball))
		{
			collisionSound.play();
			scores[1] += 1;

			_player2ScoreText = new FlxText(618, 225, 0, "" + scores[1], 9);
			add(_player2ScoreText);
			if (scores[1] == 10)
			{
				_txtMessage = new FlxText(200, 85, 0, "Congratulations P2! 
										         You Won!", 14);
				add(_txtMessage);
				winnerSound.play();
				FlxG.camera.fade(FlxColor.BLUE, .15, true);
				ball.velocity.y = 0;
			}
		}
		/* Make sure sound will play upon each wall collision */
		if (FlxG.collide(ball, tPanel))
		{
			wallBounceSound.play();
		}
		if (FlxG.collide(ball, lPanel))
		{
			wallBounceSound.play();
		}
		if (FlxG.collide(ball, rPanel))
		{
			wallBounceSound.play();
		}
		/* End the game if ball was to hit bottom panel */
		if (FlxG.collide(ball, bPanel))
		{
			endGameSound.play();
			FlxG.camera.fade(FlxColor.RED, .15, true);
			_txtTitle = new FlxText(200, 85, 0, "     Whoops! 
										Hit 'R' to reset!", 22);
			_txtTitle.screenCenter(FlxAxes.X);
			add(_txtTitle);
			ball.velocity.y = 0;
		}
	}
}
