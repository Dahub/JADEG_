namespace JADEG.Model
{
    public class PlayerModel
    {
        public string Name { get; set; }
        public bool IsInDungeon { get; set; }
        public int? DungeonId { get; set; }
        public int? XCoord { get; set; }
        public int? YCoord { get; set; }
    }
}
