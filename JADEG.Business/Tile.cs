//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace JADEG.Business
{
    using System;
    using System.Collections.Generic;
    
    public partial class Tile
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Tile()
        {
            this.Walls = new HashSet<Wall>();
            this.LinkDungeonTile = new HashSet<LinkDungeonTile>();
        }
    
        public int Id { get; set; }
        public int FK_TypeTile { get; set; }
        public int Pitch { get; set; }
        public string Backgound { get; set; }
        public bool CanLinkNorth { get; set; }
        public bool CanLinkSouth { get; set; }
        public bool CanLinkEast { get; set; }
        public bool CanLinkWest { get; set; }
        public int Rate { get; set; }
    
        public virtual TypeTile TypeTile { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Wall> Walls { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<LinkDungeonTile> LinkDungeonTile { get; set; }
    }
}
