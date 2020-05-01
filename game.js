//var canvas = document.getElementById('game-canvas');
//canvas.style.background = "#03fafa";

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

// resolution: number of pixels per pixel
// we truncate, so you end up with a deadzone at the right and/or bottom border.
function makeGame(canvas, resolution) {
  var ctx = canvas.getContext('2d');
  canvas.style.cursor = "default";

  var pixel;

  makeLevel();

  function makeLevel() {
    canvas.style.cursor = "default";
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    pixel = newPixel();
  }
  function newPixel() {
    return [getRandomInt(canvas.width / resolution), getRandomInt(canvas.height / resolution)];
  }

  // returns the game pixel that contains the canvas pixel (x,y)
  function px2grid(x,y) {
    return [Math.floor(x / resolution), Math.floor(y / resolution)];
  }

  // returns the true-pixel coördinates for an area at game pixel x,y and h,w
  // game pixels in size
  function rect(x,y,w=1,h=1) {
    return [x * resolution, y * resolution, w * resolution, h * resolution];
  }

  function drawPixel() {
    ctx.fillStyle = 'rgb(200,10,10)';
    ctx.fillRect(...rect(pixel[0], pixel[1]));
  }
  function debugPixel() {
    ctx.clearRect(0,15,100,15);
    ctx.fillText(pixel[0] + " " + pixel[1], 10, 30);
  }
  function debugEvent(e) {
    ctx.clearRect(0,0,100,15);
    var rect = px2grid(e.offsetX, e.offsetY);
    ctx.fillText(rect[0] + " " + rect[1], 10, 10);
  }
  function thisIsThePixel(x,y) {
    var rect = px2grid(x,y);
    return rect[0] == pixel[0] && rect[1] == pixel[1];
  }

  function changeCursor(e) {
    //debugEvent(e);
    if (thisIsThePixel(e.offsetX, e.offsetY)) {
      canvas.style.cursor = "pointer";
    }
    else {
      canvas.style.cursor = "default";
    }
  }
  function highlightMousePixel(e) {
    if (this.lastpx) {
      ctx.clearRect(...rect(...this.lastpx));
    }
    var gridpx = px2grid(e.offsetX, e.offsetY);

    ctx.fillStyle = 'rgb(10,200,80)';
    ctx.fillRect(...rect(...gridpx));

    this.lastpx = gridpx;
  }

  function nextLevel(e) {
    if (thisIsThePixel(e.offsetX, e.offsetY)) {
      makeLevel(canvas, resolution);
    }
  }

  canvas.addEventListener('mousemove', changeCursor);
  canvas.addEventListener('mousemove', highlightMousePixel);
  canvas.addEventListener('click', nextLevel);
}

//makeGame(canvas, 8);

class Game {
  constructor(targetElement) {
    this.container = targetElement;
    var newGameButton = document.createElement('button');
    newGameButton.classList.add('new-game');
    newGameButton.innerHTML = "START";

    newGameButton.addEventListener('click', function() {
      this.classList.add('hidden');
      (new Level(0, this)).start();
    });

    this.container.appendChild(newGameButton);
  }

  // These construct callbacks
  changeCursor(level) {
    var self = this;

    return function(e) {
    }
  }
}

class Level {
  // This can become an algorithm later
  static levelParams(l) {
    var levels = [
      { h: 50, w: 20, s: 15, ai: null },
      { h: 50, w: 30, s: 15, ai: null },
      { h: 50, w: 35, s: 10, ai: null },
      { h: 50, w: 40, s: 10, ai: null },
      { h: 50, w: 50, s: 8,  ai: null },
    ];
  }

  constructor(level, game) {
    this.level = level;
    this.game = game;

    var params = Level.levelParams(level);
    var canvas = document.createElement('canvas');
    canvas.height = params.h * params.s;
    canvas.width = params.w * params.s;

    game.container.appendChild(canvas);

    canvas.addEventListener('mousemove', game.changeCursor(this));
    canvas.addEventListener('mousemove', this.highlightMousePixel());
    canvas.addEventListener('click',     game.nextLevel(this));

    this.goalPixel = [Math.floor(Math.rand(params.w)), Math.floor(Math.rand(params.h))];
    this.params = params;
  }

  targettedPixel(e) {
    return px2grid(e.offsetX, e.offsetY);
  }

  px2grid(x,y) {
    return [Math.floor(x / this.params.s), Math.floor(y / this.params.s)];
  }

  grid2px(x,y) {
    return [x * this.params.s, y * this.params.s];
  }

  highlightMousePixel() {
    var self = this;
    return function(e) {
      self.clear();
      self.drawRect(e.offsetX, e.offsetY, 1, 1, 'rgb(30,200,30)');
    }
  }

  clear() {
    var ctx = this.canvas.getContext('2d');

    ctx.clearRect(0,0,canvas.width,canvas.height);
  }

  clearRect(x, y, w=1, h=1, fillStyle) {
    var ctx = this.canvas.getContext('2d');
    var rect = [...this.grid2px(x,y), ...this.grid2px(w,h)];

    this.canvas.getContext('2d').clearRect(...rect);
  }

  drawRect(x, y, w=1, h=1, fillStyle) {
    var res = this.params.s;
    var ctx = this.canvas.getContext('2d');
    var rect = [...this.grid2px(x,y), ...this.grid2px(w,h)];

    ctx.fillStyle = fillStyle;
    ctx.fillRect(...rect);
  }
}

window.game = new Game(document.body);
