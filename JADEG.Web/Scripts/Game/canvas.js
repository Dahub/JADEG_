var size = 600;
var pitch = 40;
var speed = 4;
var canvasOrigin = { x: 0, y: 0 };

var tileMoving = false; // indique si le joueur est entrain de sortir de la tile
var moveX = 0; // direction en x dans laquelle le joueur sort de la tile: -1 = ouest, +1 = est
var moveY = 0; // direction en y dans laquelle le joueur sort de la tile: -1 = sud, +1 = nord

function refreshCanvas(playerName, dungeonId) {
    var canvas = document.querySelector('#canvas');
    var context = canvas.getContext('2d');
    context.clearRect(0, 0, size, size);

    if (tileMoving === false) {
        evalPlayersPosition(playerName, dungeonId);
    }
    else {
        canvasOrigin.x -= moveX * 10;
        canvasOrigin.y -= moveY * 10;
        context.drawImage(ressources[nextTile.Background], canvasOrigin.x + size * moveX, canvasOrigin.y + size * moveY, size, size);
        if (Math.abs(canvasOrigin.x) >= size || Math.abs(canvasOrigin.y) >= size) {
            tileMoving = false;
            tile = nextTile;
            nextTile = null;
            canvasOrigin.x = 0;
            canvasOrigin.y = 0;
            moveX = 0;
            moveY = 0;
            var x = players[playerName].x;
            var y = players[playerName].y;
            var dx = players[playerName].dx;
            var dy = players[playerName].dy;
            var skin = players[playerName].skin;
            players = {};
            $.connection.dungeonHub.server.joinTile(dungeonId, tile.XCoord, tile.YCoord, playerName, x, y, dx, dy, skin);
        }
    }
    context.drawImage(ressources[tile.Background], canvasOrigin.x, canvasOrigin.y, size, size);

    // on trace les joueurs si le joueur en cours ne change pas de tile
    if (tileMoving === false) {
        $.each(players, function (index, value) {
            //if (index === playerName)
                drawPlayer(context, value);
            //else
            //    context.fillStyle = '#000000';
        });
    }
}

function drawPlayer(context, player) {

    player.ticks++;
    if (player.ticks === 51) {
        player.ticks = 0;
    }
    var xStart = 0;

    if (player.toGox !== player.x || player.toGoy !== player.y) {
        if (player.ticks <= 10)
            xStart = 0;
        else if (player.ticks <= 20)
            xStart = 40;
        else if (player.ticks <= 30)
            xStart = 80;
        else if (player.ticks <= 50)
            xStart = 40;
    }
    var yStart = 0;

    if (player.dx === 1)
        yStart = 80;
    else if (player.dx === -1)
        yStart = 40;
    else if (player.dy === -1)
        yStart = 120;
    context.drawImage(ressources[player.skin], xStart, yStart, pitch, pitch, player.x, player.y, pitch, pitch);
    context.font = "20px Arial";
    context.lineWidth = 1;
    context.textAlign = "center";
    context.strokeStyle = '#000000';
    context.fillStyle = '#ff6699';
    context.fillText(player.name, player.x + pitch / 2, player.y - 3);
    context.strokeText(player.name, player.x + pitch / 2, player.y - 3);
}

function evalPlayersPosition(playerName, dungeonId) {
    $.each(players, function (index, value) {
        var dx = 0;
        var dy = 0;
        var moveOk = false;
        if (value.toGox > value.x) {
            dx = speed;
            moveOk = true;
        }
        else if (value.toGox < value.x) {
            dx = -1 * speed;
            moveOk = true;
        }
        if (value.toGoy > value.y) {
            dy = speed;
            moveOk = true;
        }
        else if (value.toGoy < value.y) {
            dy = -1 * speed;
            moveOk = true;
        }
        if ((Math.abs(value.x / pitch) === value.x / pitch
            || Math.abs(value.y / pitch) === value.y / pitch)
            && checkIfCollision(index, value.x + dx, value.y + dy) === false) {
            value.x += dx;
            value.y += dy;
        }
        else {
            value.toGox = value.x;
            value.toGoy = value.y;
        }
        // on vérifie si on n'est pas sorti de la tile
        if (moveOk)
            checkTileChange(playerName, dungeonId);
    });
}

function clickOnCanvas(e, playerName, dungeonId) {
    var canvas = document.querySelector('#canvas');
    var rect = canvas.getBoundingClientRect();
    var xcord = Math.floor((e.clientX - rect.left) / pitch) * pitch;
    var ycord = Math.floor((e.clientY - rect.top) / pitch) * pitch;
    players[playerName].toGoy = ycord;
    players[playerName].toGox = xcord;

    if (players[playerName].toGox !== players[playerName].x || players[playerName].toGoy !== players[playerName].y) {
        // définition de la direction du joueur
        if (Math.abs(players[playerName].toGox - players[playerName].x) >= Math.abs(players[playerName].toGoy - players[playerName].y)) { // déplacement sur x
            players[playerName].dy = 0;
            if (players[playerName].toGox > players[playerName].x) {
                players[playerName].dx = 1;
            }
            else {
                players[playerName].dx = -1;
            }
        }
        else { // déplacement sur y
            players[playerName].dx = 0;
            if (players[playerName].toGoy > players[playerName].y) {
                players[playerName].dy = 1;
            }
            else {
                players[playerName].dy = -1;
            }
        }
        sendNewMoveInfo(dungeonId, playerName);
    }
}

function keyPressedOnCanvas(e, playerName, dungeonId) {
    if (tileMoving === false && players[playerName].toGoy === players[playerName].y && players[playerName].toGox === players[playerName].x) {
        var newMove = true;
        if (e.keyCode === 88) { // touche Z
            players[playerName].toGoy += pitch;
            players[playerName].dy = 1;
            players[playerName].dx = 0;
        }
        else if (e.keyCode === 90) { // touche X
            players[playerName].toGoy -= pitch;
            players[playerName].dy = -1;
            players[playerName].dx = 0;
        }
        else if (e.keyCode === 68) { // touche D
            players[playerName].toGox += pitch;
            players[playerName].dx = 1;
            players[playerName].dy = 0;
        }
        else if (e.keyCode === 81) { // tocuhe Q
            players[playerName].toGox -= pitch;
            players[playerName].dx = -1;
            players[playerName].dy = 0;
        }
        else
            newMove = false;

        if (newMove === true) {
            sendNewMoveInfo(dungeonId, playerName);
        }
    }
    return false;
}

function sendNewMoveInfo(dungeonId, playerName) {
    if (checkIfCollision(playerName, players[playerName].toGox, players[playerName].toGoy) === false) {
        $.connection.dungeonHub.server.move(dungeonId, tile.XCoord, tile.YCoord, playerName, players[playerName].toGox, players[playerName].toGoy, players[playerName].dx, players[playerName].dy, players[playerName].skin);
    }
    else {
        players[playerName].toGox = players[playerName].x;
        players[playerName].toGoy = players[playerName].y;
    }
}

function checkIfCollision(movingPlayer, toGoX, toGoY) {
    // on vérifie qu'on n'est pas dans un mur
    var collision = false;
    $.each(tile.Walls, function (i, val) {
        if (toGoX < val.EndX * pitch
          && toGoX > val.StartX * pitch - pitch
          && toGoY > val.StartY * pitch - pitch
          && toGoY < val.EndY * pitch) {
            collision = true;
            return false;
        }
    });

    // ou dans un autre joueur
    $.each(players, function (i, val) {
        if (i !== movingPlayer) {
            if (Math.abs(toGoX - val.x) < pitch && Math.abs(toGoY - val.y) < pitch) {
                collision = true;
                return false;
            }
        }
    });
    return collision
}

function checkTileChange(playerName, dungeonId) {
    if (players[playerName].x > size - pitch) {
        tileMoving = true;
        players[playerName].x = 0;
        moveX = 1;
    }
    else if (players[playerName].x < 0) {
        tileMoving = true;
        players[playerName].x = size - pitch;
        moveX = -1;
    }
    else if (players[playerName].y < 0) {
        tileMoving = true;
        players[playerName].y = size - pitch;
        moveY = -1;
    }
    else if (players[playerName].y > size - pitch) {
        tileMoving = true;
        players[playerName].y = 0;
        moveY = 1;
    }

    if (tileMoving) {
        nextTile = loadNextTile(dungeonId, tile.XCoord + moveX, tile.YCoord - moveY);
        $.connection.dungeonHub.server.quitTile(dungeonId, tile.XCoord, tile.YCoord, playerName);
    }
}
