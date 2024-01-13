--window variables
local window_width = pesto.window.getWidth()
local window_height = pesto.window.getHeight()
local grid_x = (window_width - window_height) / 2 --top left corners of board
local grid_y = 0
local tile_size = 64
local grid_tiles = {}
local first_tile_x = (window_height - 8 * tile_size) / 2 + grid_x --top left corner tile's x
local first_tile_y = (window_height - 8 * tile_size) / 2 + grid_y --top left corner tile's y
local start = true
local white_turn = true
local white_pieces = {}
local black_pieces = {}

--load sprites
local black_pawn_image = pesto.graphics.loadTexture("assets/sprites/black/Pawn.png")
local black_rook_image = pesto.graphics.loadTexture("assets/sprites/black/Rook.png")
local black_knight_image = pesto.graphics.loadTexture("assets/sprites/black/Knight.png")
local black_bishop_image = pesto.graphics.loadTexture("assets/sprites/black/Bishop.png")
local black_queen_image = pesto.graphics.loadTexture("assets/sprites/black/Queen.png")
local black_king_image = pesto.graphics.loadTexture("assets/sprites/black/King.png")
local white_pawn_image = pesto.graphics.loadTexture("assets/sprites/white/Pawn.png")
local white_rook_image = pesto.graphics.loadTexture("assets/sprites/white/Rook.png")
local white_knight_image = pesto.graphics.loadTexture("assets/sprites/white/Knight.png")
local white_bishop_image = pesto.graphics.loadTexture("assets/sprites/white/Bishop.png")
local white_queen_image = pesto.graphics.loadTexture("assets/sprites/white/Queen.png")
local white_king_image = pesto.graphics.loadTexture("assets/sprites/white/King.png")

--pieces' classes
local Object = require "assets/classic"
local Piece = Object:extend()

function Piece:new(x, y, icon, white_team)
    self.x = first_tile_x + (x - 1) * tile_size
    self.y = first_tile_y + (y - 1) * tile_size
    self.icon = icon
    self.white_team = white_team
end

function Piece:draw()
    self.icon:draw(self.x, self.y, 0, 2, 2)
end

local Pawn = Piece:extend()
local Rook = Piece:extend()
local Knight = Piece:extend()
local Bishop = Piece:extend()
local Queen = Piece:extend()
local King = Piece:extend()

--starting setup
local white_pawn1 = Pawn(1, 7, white_pawn_image, true)
local white_pawn2 = Pawn(2, 7, white_pawn_image, true)
local white_pawn3 = Pawn(3, 7, white_pawn_image, true)
local white_pawn4 = Pawn(4, 7, white_pawn_image, true)
local white_pawn5 = Pawn(5, 7, white_pawn_image, true)
local white_pawn6 = Pawn(6, 7, white_pawn_image, true)
local white_pawn7 = Pawn(7, 7, white_pawn_image, true)
local white_pawn8 = Pawn(8, 7, white_pawn_image, true)
local white_rook1 = Rook(1, 8, white_rook_image, true)
local white_rook2 = Rook(8, 8, white_rook_image, true)
local white_knight1 = Knight(2, 8, white_knight_image, true)
local white_knight2 = Knight(7, 8, white_knight_image, true)
local white_bishop1 = Bishop(3, 8, white_bishop_image, true)
local white_bishop2 = Bishop(6, 8, white_bishop_image, true)
local white_queen = Queen(4, 8, white_queen_image, true)
local white_king = King(5, 8, white_king_image, true)

table.insert(white_pieces, white_pawn1)
table.insert(white_pieces, white_pawn2)
table.insert(white_pieces, white_pawn3)
table.insert(white_pieces, white_pawn4)
table.insert(white_pieces, white_pawn5)
table.insert(white_pieces, white_pawn6)
table.insert(white_pieces, white_pawn7)
table.insert(white_pieces, white_pawn8)
table.insert(white_pieces, white_rook1)
table.insert(white_pieces, white_rook2)
table.insert(white_pieces, white_knight1)
table.insert(white_pieces, white_knight2)
table.insert(white_pieces, white_bishop1)
table.insert(white_pieces, white_bishop2)
table.insert(white_pieces, white_queen)
table.insert(white_pieces, white_king)

--starting setup
local black_pawn1 = Pawn(1, 2, black_pawn_image, true)
local black_pawn2 = Pawn(2, 2, black_pawn_image, true)
local black_pawn3 = Pawn(3, 2, black_pawn_image, true)
local black_pawn4 = Pawn(4, 2, black_pawn_image, true)
local black_pawn5 = Pawn(5, 2, black_pawn_image, true)
local black_pawn6 = Pawn(6, 2, black_pawn_image, true)
local black_pawn7 = Pawn(7, 2, black_pawn_image, true)
local black_pawn8 = Pawn(8, 2, black_pawn_image, true)
local black_rook1 = Rook(1, 1, black_rook_image, true)
local black_rook2 = Rook(8, 1, black_rook_image, true)
local black_knight1 = Knight(2, 1, black_knight_image, true)
local black_knight2 = Knight(7, 1, black_knight_image, true)
local black_bishop1 = Bishop(3, 1, black_bishop_image, true)
local black_bishop2 = Bishop(6, 1, black_bishop_image, true)
local black_queen = Queen(4, 1, black_queen_image, true)
local black_king = King(5, 1, black_king_image, true)

table.insert(black_pieces, black_pawn1)
table.insert(black_pieces, black_pawn2)
table.insert(black_pieces, black_pawn3)
table.insert(black_pieces, black_pawn4)
table.insert(black_pieces, black_pawn5)
table.insert(black_pieces, black_pawn6)
table.insert(black_pieces, black_pawn7)
table.insert(black_pieces, black_pawn8)
table.insert(black_pieces, black_rook1)
table.insert(black_pieces, black_rook2)
table.insert(black_pieces, black_knight1)
table.insert(black_pieces, black_knight2)
table.insert(black_pieces, black_bishop1)
table.insert(black_pieces, black_bishop2)
table.insert(black_pieces, black_queen)
table.insert(black_pieces, black_king)

for i = 1, 8, 1 do
    for ii = 1, 8, 1 do
        new_tile = {first_tile_x + tile_size * (i - 1), first_tile_y + tile_size * (ii - 1), tile_size, tile_size}
        table.insert(grid_tiles, new_tile)
    end
end

function pesto.update(dt)

    local mouse_x = pesto.mouse.getX()
    local mouse_y = pesto.mouse.getY()
    
    mouse_tile_x = math.ceil((mouse_x - first_tile_x)/tile_size)
    mouse_tile_y = math.ceil((mouse_y - first_tile_y)/tile_size)

end

function pesto.draw()

    --draw board background
    pesto.graphics.setColor(255, 255, 255)
    pesto.graphics.rectangle(grid_x, grid_y, window_height, window_height)

    --draw gay board tiles
    for _, v in pairs(grid_tiles) do
        pesto.graphics.setColor(v[1] * _, v[2] *_, v[3] * _)
        pesto.graphics.rectangle(v[1], v[2], v[3], v[4])
    end

    --highlight selected tile
    pesto.graphics.setColor(255, 255, 255)
    pesto.graphics.rectangle(first_tile_x + (mouse_tile_x - 1) * tile_size,
            first_tile_y + (mouse_tile_y - 1) * tile_size, tile_size, tile_size)

    --draw white pieces
    pesto.graphics.setColor(255, 255, 255)
    for _, v in pairs(white_pieces) do
        v:draw()
    end

    --draw black pieces
    for _, v in pairs(black_pieces) do
        v:draw()
    end

end