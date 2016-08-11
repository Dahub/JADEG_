using System.Web.Mvc;

namespace JADEG.Web.Controllers
{
    public class DungeonController : Controller
    {
        public ActionResult Explore()
        {           
            if(Session["player"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            return View(Session["player"]);
        }
    }
}