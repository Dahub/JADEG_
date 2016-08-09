using JADEG.Business;
using System.Web.Mvc;

namespace JADEG.Web.Controllers
{
    public class TileController : Controller
    {
        public JsonResult LoadTile()
        {
            TileManager manager = new TileManager();
            var test = manager.GetTile(1, 0, 0);
            string jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(test);
            var tt = jsonString;
            return Json(test, JsonRequestBehavior.AllowGet);
        }
    }
}