using JADEG.Business;
using System.Web.Mvc;

namespace JADEG.Web.Controllers
{
    public class TileController : Controller
    {
        public JsonResult LoadTile()
        {
            TileManager manager = new TileManager();
            return Json(manager.GetTile(1, 0, 0), JsonRequestBehavior.AllowGet);
        }
    }
}