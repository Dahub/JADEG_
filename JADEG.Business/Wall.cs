//------------------------------------------------------------------------------
// <auto-generated>
//     Ce code a été généré à partir d'un modèle.
//
//     Des modifications manuelles apportées à ce fichier peuvent conduire à un comportement inattendu de votre application.
//     Les modifications manuelles apportées à ce fichier sont remplacées si le code est régénéré.
// </auto-generated>
//------------------------------------------------------------------------------

namespace JADEG.Business
{
    using System;
    using System.Collections.Generic;
    
    public partial class Wall
    {
        public int Id { get; set; }
        public int FK_Tile { get; set; }
        public int StartXCoord { get; set; }
        public int EndXCoord { get; set; }
        public int StartYCoord { get; set; }
        public int EndYCoord { get; set; }
    
        public virtual Tile Tile { get; set; }
    }
}
