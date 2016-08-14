namespace JADEG.Model
{
    public class PlayerModel
    {
        public string Name { get; set; }
        public bool IsInDungeon { get; set; }
        public int? DungeonId { get; set; }
        public int? TileXCoord { get; set; }
        public int? TileYCoord { get; set; }
        public int? PosX { get; set; } // position du joueur sur la tile
        public int? PosY { get; set; } // position du joueur sur la tile
        public string Skin { get; set; }
    }
}
