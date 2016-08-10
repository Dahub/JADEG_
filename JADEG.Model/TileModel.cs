using System.Collections.Generic;

namespace JADEG.Model
{
    public class TileModel
    {
        public TileModel()
        {
            Walls = new List<WallModel>();
        }

        public int XCoord { get; set; }
        public int YCoord { get; set; }
        public string Background { get; set; }
        public IList<WallModel> Walls { get; set; }
    }
}
