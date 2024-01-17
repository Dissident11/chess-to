--window constants
local window_width = pesto.window.getWidth()
local window_height = pesto.window.getHeight()
local board_x = (window_width - window_height) / 2 --top left corner's x of board
local board_y = 0 --top left corner's y of board
local tile_size = 64
local board_white_tiles = {}
local board_black_tiles = {}
local board_tiles = {}
local piece_available_tiles
local piece_selected = false
local current_piece
local first_tile_x = (window_height - 8 * tile_size) / 2 + board_x --top left corner tile's x
local first_tile_y = (window_height - 8 * tile_size) / 2 + board_y --top left corner tile's y

--default settings
local white_turn = true
local white_pieces = {}
local black_pieces = {}
local selected_tile_x = 0
local selected_tile_y = 0
local new_mouse_tile_x, new_mouse_tile_y
local moves = {}
local game_over = false

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

function Piece:new(x, y, white_team)
    self.board_x = x
    self.board_y = y
    self.x = first_tile_x + (x - 1) * tile_size
    self.y = first_tile_y + (y - 1) * tile_size
    self.white_team = white_team
end

local Pawn = Piece:extend()
local Rook = Piece:extend()
local Knight = Piece:extend()
local Bishop = Piece:extend()
local Queen = Piece:extend()
local King = Piece:extend()

function Pawn:new(x, y, white_team)
    Pawn.super.new(self, x, y, white_team)
    self.letter = ""
    if self.white_team then
        self.icon = white_pawn_image
    else
        self.icon = black_pawn_image
    end
end
function Pawn:draw()
    self.icon:draw(self.x, self.y, 0, 2, 2)
end

function Pawn:check_moving()

    local no_white, no_black = true, true

    if self.white_team then
        for _, v in pairs(board_white_tiles) do
            if v[1] == self.board_x and v[2] == self.board_y - 1 then
                no_white = false
            end
        end

        for _, v in pairs(board_black_tiles) do
            if v[1] == self.board_x and v[2] == self.board_y - 1 then
                no_black = false
            end
        end

    else
        for _, v in pairs(board_white_tiles) do
            if v[1] == self.board_x and v[2] == self.board_y + 1 then
                no_white = false
            end
        end

        for _, v in pairs(board_black_tiles) do
            if v[1] == self.board_x and v[2] == self.board_y + 1 then
                no_black = false
            end
        end
    end

    self.can_move = (no_white and no_black)
    return self.can_move
end

function Pawn:available_board_tiles()
    if self.can_move then
        self.available_tiles = {{self.board_x, self.board_y - 1}}
        return self.available_tiles
    end
end

function Pawn:move(x, y)
    if self.can_move and x == self.available_tiles[1] and y == self.available_tiles[2] then
        self.board_x = x
        self.board_y = y
        self.y = self.y - tile_size
    end
end

function Pawn:draw()
    self.icon:draw(self.x, self.y, 0, 2, 2)
end

--rook class
function Rook:new(x, y, white_team)
    Rook.super.new(self, x, y, white_team)
    self.letter = "R"
    if self.white_team then
        self.icon = white_rook_image
    else
        self.icon = black_rook_image
    end
end
function Rook:draw()
    self.icon:draw(self.x, self.y, 0, 2, 2)
end

--knight class
function Knight:new(x, y, white_team)
    Knight.super.new(self, x, y, white_team)
    self.letter = "N"
    if self.white_team then
        self.icon = white_knight_image
    else
        self.icon = black_knight_image
    end
end
function Knight:draw()
    self.icon:draw(self.x, self.y, 0, 2, 2)
end

--bishop class
function Bishop:new(x, y, white_team)
    Bishop.super.new(self, x, y, white_team)
    self.letter = "B"
    if self.white_team then
        self.icon = white_bishop_image
    else
        self.icon = black_bishop_image
    end
end
function Bishop:draw()
    self.icon:draw(self.x, self.y, 0, 2, 2)
end

--queen class
function Queen:new(x, y, white_team)
    Queen.super.new(self, x, y, white_team)
    self.letter = "Q"
    if self.white_team then
        self.icon = white_queen_image
    else
        self.icon = black_queen_image
    end
end
function Queen:draw()
    self.icon:draw(self.x, self.y, 0, 2, 2)
end

--king class
function King:new(x, y, white_team)
    King.super.new(self, x, y, white_team)
    self.letter = "K"
    if self.white_team then
        self.icon = white_king_image
    else
        self.icon = black_king_image
    end
end
function King:draw()
    self.icon:draw(self.x, self.y, 0, 2, 2)
end

--starting setup
--white pieces
local white_pawn1 = Pawn(1, 7, true)
local white_pawn2 = Pawn(2, 7, true)
local white_pawn3 = Pawn(3, 7, true)
local white_pawn4 = Pawn(4, 7, true)
local white_pawn5 = Pawn(5, 7, true)
local white_pawn6 = Pawn(6, 7, true)
local white_pawn7 = Pawn(7, 7, true)
local white_pawn8 = Pawn(8, 7, true)
local white_rook1 = Rook(1, 8, true)
local white_rook2 = Rook(8, 8, true)
local white_knight1 = Knight(2, 8, true)
local white_knight2 = Knight(7, 8, true)
local white_bishop1 = Bishop(3, 8, true)
local white_bishop2 = Bishop(6, 8, true)
local white_queen = Queen(4, 8, true)
local white_king = King(5, 8, true)

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

--black pieces
local black_pawn1 = Pawn(1, 2, false)
local black_pawn2 = Pawn(2, 2, false)
local black_pawn3 = Pawn(3, 2, false)
local black_pawn4 = Pawn(4, 2, false)
local black_pawn5 = Pawn(5, 2, false)
local black_pawn6 = Pawn(6, 2, false)
local black_pawn7 = Pawn(7, 2, false)
local black_pawn8 = Pawn(8, 2, false)
local black_rook1 = Rook(1, 1, false)
local black_rook2 = Rook(8, 1, false)
local black_knight1 = Knight(2, 1, false)
local black_knight2 = Knight(7, 1, false)
local black_bishop1 = Bishop(3, 1, false)
local black_bishop2 = Bishop(6, 1, false)
local black_queen = Queen(4, 1, false)
local black_king = King(5, 1, false)

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

--check which tiles are occuppied by white pieces
for _, v in pairs(white_pieces) do
    local piece_x, piece_y = v.board_x, v.board_y
    table.insert(board_white_tiles, {piece_x, piece_y})
end

--check which tiles are occuppied by black pieces
for _, v in pairs(black_pieces) do
    local piece_x, piece_y = v.board_x, v.board_y
    table.insert(board_black_tiles, {piece_x, piece_y})
end

--load board tiles
for i = 1, 8, 1 do
    for ii = 1, 8, 1 do
        new_tile = {first_tile_x + tile_size * (i - 1), first_tile_y + tile_size * (ii - 1), tile_size, tile_size}
        table.insert(board_tiles, new_tile)
    end
end

function pesto.update(dt)

    --get mouse coords
    local mouse_x = pesto.mouse.getX()
    local mouse_y = pesto.mouse.getY()
    
    --get mouse coords with respect to the board
    mouse_tile_x = math.ceil((mouse_x - first_tile_x)/tile_size)
    mouse_tile_y = math.ceil((mouse_y - first_tile_y)/tile_size)

    --select tile with mouse on board and left click
    if mouse_tile_x <= 8 and mouse_tile_x >= 1 and mouse_tile_y <= 8 and mouse_tile_y >= 1 and pesto.mouse.isPressed(0) then
        selected_tile_x = mouse_tile_x
        selected_tile_y = mouse_tile_y
    end

    --select tile with mouse on board and right click, used just to move pieces
    if mouse_tile_x <= 8 and mouse_tile_x >= 1 and mouse_tile_y <= 8 and mouse_tile_y >= 1 and pesto.mouse.isPressed(1) then
        new_mouse_tile_x = mouse_tile_x
        new_mouse_tile_y = mouse_tile_y
    end

    --set turn text
    if white_turn then 
        turn_text = "WHITE TURN"
    else
        turn_text = "BLACK TURN"
    end

    if not game_over then

        text = ""
        piece_available_tiles = {}
        current_piece = nil
        piece_selected = false

        if white_turn then

            

            for k, v in pairs(white_pieces) do --check if there is a piece on the selected tile
                if v.board_x == selected_tile_x and v.board_y == selected_tile_y then
                    piece_selected = true
                    text = tostring(v.letter)..string.char(97 + v.board_x - 1)..tostring(9 - v.board_y)
                    current_piece = white_pieces[k]
                end
                
                if piece_selected then

                    if current_piece:check_moving() then
                        piece_available_tiles = current_piece:available_board_tiles()

                        for _, v in pairs(piece_available_tiles) do --convert board coords to screen coords
                            v[1] = first_tile_x + (v[1] - 1) * tile_size
                            v[2] = first_tile_y + (v[2] - 1) * tile_size
                        end
                    end

                    if pesto.mouse.isPressed(1) then
                        current_piece:move(new_mouse_tile_x, new_mouse_tile_y)
                    end

                end

            end
        else

        end
    else

    end


end

function pesto.draw()

    --draw board background
    pesto.graphics.setColor(255, 255, 255)
    pesto.graphics.rectangle(board_x, board_y, window_height, window_height)

    --draw gay board tiles
    for _, v in pairs(board_tiles) do
        pesto.graphics.setColor(v[1] * _, v[2] *_, v[3] * _)
        pesto.graphics.rectangle(v[1], v[2], v[3], v[4])
    end

    --highlight selected tile
    pesto.graphics.setColor(255, 255, 255)
    pesto.graphics.rectangle(first_tile_x + (mouse_tile_x - 1) * tile_size,
            first_tile_y + (mouse_tile_y - 1) * tile_size, tile_size, tile_size)

    --if a piece is selected, draw the tiles it can move on if there are any
    if piece_available_tiles ~= nil then
        pesto.graphics.setColor(255, 0, 0)
        for _, v in pairs(piece_available_tiles) do
            pesto.graphics.rectangle(v[1], v[2], tile_size, tile_size)
        end
    end

    --draw white pieces
    pesto.graphics.setColor(255, 255, 255)
    for _, v in pairs(white_pieces) do
        v:draw()
    end

    --draw black pieces
    for _, v in pairs(black_pieces) do
        v:draw()
    end

    --draw mouse coords when on board
    if mouse_tile_x <= 8 and mouse_tile_x >= 1 and mouse_tile_y <= 8 and mouse_tile_y >= 1 then
        pesto.graphics.text((mouse_tile_x.. " ".. mouse_tile_y), 0, 0)
        pesto.graphics.text((string.char(97 + mouse_tile_x - 1).. " ".. (9 - mouse_tile_y)), 30, 0)
    end

    --draw selected tile's coords
    pesto.graphics.text((selected_tile_x.. " ".. selected_tile_y), 0, 15)
    pesto.graphics.text((string.char(97 + selected_tile_x - 1).. " ".. (9 - selected_tile_y)), 30, 15)
    
    --draw whose turn it is
    pesto.graphics.text(turn_text, 0, 30)

    --selected tile coords and piece type
    pesto.graphics.text(text, 0, 45)

    if new_mouse_tile_x then
        pesto.graphics.text((new_mouse_tile_x.." "..new_mouse_tile_y), 0, 60)
    end

    if current_piece ~= nil then
        if current_piece:check_moving() then
            pesto.graphics.text("can move", 0, 100)
        end
    end

    if piece_selected then
        for _, v in pairs(piece_available_tiles) do
            pesto.graphics.text((v[1].." "..v[2]), 0, 75)
        end
    end
end
