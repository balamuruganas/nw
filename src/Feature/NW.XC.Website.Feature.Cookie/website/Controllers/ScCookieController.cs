using Naturesway.Feature.Webshop.Cookie.Models;
using Sitecore.Mvc.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Naturesway.Feature.Webshop.Cookie.Controllers
{
  public class ScCookieController : SitecoreController
  {
    public ActionResult SetCookies(CookiesViewModel model)
    {
      HttpContext.Response.Cookies.Add(new HttpCookie("SC_ANALYTICS_GLOBAL_COOKIE") { Value = model.ScAnalyticsGlobalCookie });
      return new EmptyResult();
    }

    public ActionResult CookiesIFrame()
    {
      var scAnalyticsGlobalCookie = HttpContext.Request.Cookies["SC_ANALYTICS_GLOBAL_COOKIE"].Value;

      var model = new CookiesViewModel()
      {
        ScAnalyticsGlobalCookie = scAnalyticsGlobalCookie,
      };
      return View("~/Views/Naturesway/Feature/Cookie/CookieView.cshtml", model);
    }
  }
}