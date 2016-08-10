using JADEG.Model;
using System.Linq;
using System;

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
                if(myTile != null)
                {
                    toReturn = myTile.ToDto();
                }
                else
                {
                    toReturn = GenerateNewTile(dungeonId, xCoord, yCoord);
                }
            }

            return toReturn;
        }

        private TileModel GenerateNewTile(int dungeonId, int xCoord, int yCoord)
        {
            // on récupère les tiles autour
            Tile northTile = null;
            Tile southtile = null;
            throw new NotImplementedException();
        }
    }
}
