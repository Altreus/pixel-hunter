var canvas = document.getElementById('game-canvas');
var ctx = canvas.getContext('2d');
canvas.style.background = "#03fafa";

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

var pixel = [getRandomInt(canvas.width), getRandomInt(canvas.height)];

ctx.fillText(pixel[0] + " " + pixel[1], 10, 30);

canvas.addEventListener('mousemove', function(e) {
  ctx.clearRect(0,0,100,15);
  ctx.fillText(e.offsetX + " " + e.offsetY, 10, 10);

  if (e.offsetX == pixel[0] && e.offsetY == pixel[1]) {
    canvas.style.cursor = "pointer";
  }
  else {
    canvas.style.cursor = "default";
  }
});
