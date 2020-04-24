# pixel-hunter
Find the pixel!

# Ideas

## Zen mode

You can't lose!

## Hints

* Flash the pixel very briefly
* Flash a box briefly, containing but not centred on the pixel
* Remove pixels that aren't it
* Cold/warm/hot

## Lose conditions

### Time out

You have N seconds to find the pixel or you lose.

### Computer finds the pixel first

The game will start removing pixels. If it removes your pixel, you lose.

#### Lines

Horizontal, vertical, or oblique lines of pixels.

Type 1: The computer removes a line of pixels at once, telegraphed. Like imma chargin mah lazor or something.

Type 2: The computer removes a line of pixels one at a time.

#### Pits

The computer starts removing pixels at random from the remaining pixels.

#### Zap

The computer draws a line between two arbitrary points, but the pixels removed resemble the path lightning would take, i.e. jittery, and random.

#### Ring-a-roses

The computer starts removing pixels from the edges, in a spiral.

Type 1: Plain spiral, just go around the edges until you hit the pixel

Type 2: Offset spiral, removing pixels around some arbitrary centre point with a radius sufficient to start at one edge.

Type 2 would help balance because the centre could be somewhere near the target pixel.

#### Burn

A spot on the surface starts burning and pixels are removed outwardly from that with some sort of jitter.

## Difficulty levels

### Pixel size

An 8-pixel pixel size was still super difficult on a 1280x720 canvas. An X-by-Y grid might be a better way of defining the pixel size and therefore the difficulty.

### AI difficulty

By removing pixels faster you effectively reduce the time you have to find it. By using an AI antagonist instead of a clock you risk losing faster by accident.

By removing thicker lines, or bigger pits, you increase the likelihood of the pixel being removed.

By having more than one removal node at once.
