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
    pixel = newPixel();
    debugPixel();
  }
  function newPixel() {
    return [getRandomInt(canvas.width / resolution), getRandomInt(canvas.height / resolution)];
  }

  function debugPixel() {
    ctx.clearRect(0,15,100,15);
    ctx.fillText(pixel[0] + " " + pixel[1], 10, 30);
  }
  function debugEvent(e) {
    ctx.clearRect(0,0,100,15);
    var adjustedX = Math.floor(e.offsetX / resolution);
    var adjustedY = Math.floor(e.offsetY / resolution);
    ctx.fillText(adjustedX + " " + adjustedY, 10, 10);
  }
  function thisIsThePixel(x,y) {
    var adjustedX = Math.floor(x / resolution);
    var adjustedY = Math.floor(y / resolution);
    return adjustedX == pixel[0] && adjustedY == pixel[1];
  }

  function changeCursor(e) {
    debugEvent(e);
    if (thisIsThePixel(e.offsetX, e.offsetY)) {
      canvas.style.cursor = "pointer";
    }
    else {
      canvas.style.cursor = "default";
    }
  }

  function nextLevel(e) {
    if (thisIsThePixel(e.offsetX, e.offsetY)) {
      makeLevel(canvas, resolution);
    }
  }

  canvas.addEventListener('mousemove', changeCursor);
  canvas.addEventListener('click', nextLevel);
}

makeGame(canvas, 8);
