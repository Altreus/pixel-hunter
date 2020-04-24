var canvas = document.getElementById('game-canvas');
canvas.style.background = "#03fafa";

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

makeGame(canvas, 8);
