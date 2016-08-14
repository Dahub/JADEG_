using JADEG.Model;
using System.Linq;
using System;
using System.Collections.Generic;

namespace JADEG.Business
{
    public class TileManager
    {
        public TileModel GetTile(int dungeonId, int xCoord, int yCoord)
        {
            TileModel toReturn = new TileModel();

            using (var ctx = new Entities())
            {
                var myTile = ctx.LinkDungeonTile.Where(t => t.FK_Dungeon.Equals(dungeonId) && t.XCoord.Equals(xCoord) && t.YCoord.Equals(yCoord)).FirstOrDefault();
                if (myTile != null)
                {
                    toReturn = myTile.ToDto();
                }
                else
                {
                    toReturn = GenerateNewTileModel(dungeonId, xCoord, yCoord);
                }
            }

            return toReturn;
        }

        private TileModel GenerateNewTileModel(int dungeonId, int xCoord, int yCoord)
        {
            TileModel toReturn = null;

            using (var ctx = new Entities())
            {
                IList<Tile> tiles = ctx.GetPossiblesTiles(xCoord, yCoord, dungeonId).ToList();
                Tile choisedTile = ChoiseOntileInList(tiles);

                // on sauvegarde   
                LinkDungeonTile added = null;
                added = new LinkDungeonTile()
                {
                    FK_Dungeon = dungeonId,
                    FK_Tile = choisedTile.Id,
                    Tile = choisedTile,
                    XCoord = xCoord,
                    YCoord = yCoord                    
                };

                ctx.LinkDungeonTile.Add(added);
                ctx.SaveChanges();
                toReturn = added.ToDto();
            }

            return toReturn;
        }

        private static Tile ChoiseOntileInList(IList<Tile> tiles)
        {
            int totalRand = tiles.Select(t => t.Rate).Sum();
            Random rand = new Random(DateTime.Now.Millisecond);
            int choisedInt = rand.Next(0, totalRand);
            int stack = 0;
            Tile choisedTile = null;
            foreach (var t in tiles)
            {
                stack += t.Rate;
                if (stack > choisedInt)
                {
                    choisedTile = t;
                    break;
                }
            }

            return choisedTile;
        }
    }
}
