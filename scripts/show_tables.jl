using Revise
Revise.revise()

using Term
using Term.box



all_boxes = [
    ASCII, ASCII2, ASCII_DOUBLE_HEAD, SQUARE, SQUARE_DOUBLE_HEAD, MINIMAL, MINIMAL_HEAVY_HEAD,
    MINIMAL_DOUBLE_HEAD, SIMPLE, SIMPLE_HEAD, SIMPLE_HEAVY, HORIZONTALS, ROUNDED, HEAVY,
    HEAVY_EDGE, HEAVY_HEAD, DOUBLE, DOUBLE_EDGE,
]

for box in all_boxes
    println(box)
end