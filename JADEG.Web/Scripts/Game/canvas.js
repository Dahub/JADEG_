﻿var size = 600;
var pitch = 40;
var speed = 2;
var canvasOrigin = { x: 0, y: 0 };

var tileMoving = false; // indique si le joueur est entrain de sortir de la tile
var moveX = 0; // direction en x dans laquelle le joueur sort de la tile: -1 = ouest, +1 = est
var moveY = 0; // direction en y dans laquelle le joueur sort de la tile: -1 = sud, +1 = nord

function refreshCanvas(playerName, dungeonId) {
 
    var canvas = document.querySelector('#canvas');
    var context = canvas.getContext('2d');
    context.clearRect(0, 0, size, size);

    if (tileMoving === false) {
        evalPlayersPosition();
    }
    else {
        canvasOrigin.x -= moveX * 10;
        canvasOrigin.y -= moveY * 10;      
        context.drawImage(ressources[nextTile.Background], canvasOrigin.x + size * moveX, canvasOrigin.y - size * moveY, size, size);
        console.log(players[playerName].x);
        if (Math.abs(canvasOrigin.x) >= size || Math.abs(canvasOrigin.y) >= size) {
            tileMoving = false;
            tile = nextTile;
            nextTile = null;
            canvasOrigin.x = 0;
            canvasOrigin.y = 0;
            var x = players[playerName].x;
            var y = players[playerName].y;
            players = {};
            $.connection.dungeonHub.server.joinTile(dungeonId, tile.XCoord, tile.YCoord, playerName, x, y);
        }
    }
    context.drawImage(ressources[tile.Background], canvasOrigin.x, canvasOrigin.y, size, size);

    // on trace les joueurs si le joueur en cours ne change pas de tile
    if (tileMoving === false) {
        $.each(players, function (index, value) {
            if (index === playerName)
                context.fillStyle = '#FF0000';
            else
                context.fillStyle = '#000000';

            context.fillRect(value.x, value.y, pitch, pitch);
        });
    }
}

function evalPlayersPosition() {
    $.each(players, function (index, value) {
        if (value.toGox > value.x)
            value.x += speed;
        if (value.toGox < value.x)
            value.x -= speed;
        if (value.toGoy > value.y)
            value.y += speed;
        if (value.toGoy < value.y)
            value.y -= speed;
    });
}

function keyPressedOnCanvas(e, playerName, dungeonId) {
    if (tileMoving === false && players[playerName].toGoy === players[playerName].y && players[playerName].toGox === players[playerName].x) {
        var newMove = true;
        if (e.keyCode === 88) {
            players[playerName].toGoy += pitch;
        }
        else if (e.keyCode === 90) {
            players[playerName].toGoy -= pitch;
        }
        else if (e.keyCode === 68) {
            players[playerName].toGox += pitch;
        }
        else if (e.keyCode === 81) {
            players[playerName].toGox -= pitch;
        }
        else {
            newMove = false;
        }

        if (newMove === true) {
            $.connection.dungeonHub.server.move(dungeonId, tile.XCoord, tile.YCoord, playerName, players[playerName].toGox, players[playerName].toGoy);
            // on vérifie si on n'est pas sorti de la tile
            checkTileChange(playerName, dungeonId);
        }
    }
    return false;
}

function checkTileChange(playerName, dungeonId) {
    if (players[playerName].x >= size) {
        tileMoving = true;
        players[playerName].x = 0;
        moveX = 1;
    }
    else if (players[playerName].x <= 0 - pitch) {
        tileMoving = true;
        players[playerName].x = size - pitch;
        moveX = -1;
    }

    if (tileMoving) {
        nextTile = loadNextTile(dungeonId, tile.XCoord + moveX, tile.YCoord + moveY);
        $.connection.dungeonHub.server.quitTile(dungeonId, tile.XCoord, tile.YCoord, playerName);
    }
}
