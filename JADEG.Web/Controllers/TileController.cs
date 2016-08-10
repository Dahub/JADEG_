using JADEG.Business;
using JADEG.Model;
using System.Web.Mvc;

namespace JADEG.Web.Controllers
{
    public class TileController : Controller
    {
        [HttpPost]
        public JsonResult LoadTile(TileModel model)
        {
            TileManager manager = new TileManager();
            return Json(manager.GetTile(model.DungeonId, model.XCoord, model.YCoord));
        }
    }
}