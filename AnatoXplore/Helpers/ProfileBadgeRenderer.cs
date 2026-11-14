using System;
using System.IO;
using System.Web;
using System.Web.Hosting;

namespace AnatoXplore
{
    public static class ProfileBadgeRenderer
    {
        public static string Render(object photoValue, object frameValue, object nameValue, string avatarClass)
        {
            string safeAvatarClass;
            switch (avatarClass ?? String.Empty)
            {
                case "site-avatar": safeAvatarClass = "site-avatar"; break;
                case "lb-avatar": safeAvatarClass = "lb-avatar"; break;
                case "lb-table-avatar": safeAvatarClass = "lb-table-avatar"; break;
                case "disc-avatar": safeAvatarClass = "disc-avatar"; break;
                case "dd-avatar": safeAvatarClass = "dd-avatar"; break;
                case "dd-avatar small": safeAvatarClass = "dd-avatar small"; break;
                default: safeAvatarClass = "disc-avatar"; break;
            }

            string frameClass = GetFrameCssClass(frameValue);
            string fullName = Convert.ToString(nameValue);
            string label = String.IsNullOrWhiteSpace(fullName) ? "Profile picture" : fullName.Trim() + " profile picture";
            string inner = null;
            string photoPath = photoValue == null || photoValue == DBNull.Value ? null : Convert.ToString(photoValue);

            if (IsSafePhotoPath(photoPath))
            {
                string absolutePath = HostingEnvironment.MapPath(photoPath);
                if (!String.IsNullOrEmpty(absolutePath) && File.Exists(absolutePath))
                {
                    string url = VirtualPathUtility.ToAbsolute(photoPath);
                    inner = "<img src=\"" + HttpUtility.HtmlAttributeEncode(url) + "\" alt=\"\" />";
                }
            }

            if (inner == null)
                inner = HttpUtility.HtmlEncode(GetInitials(fullName, safeAvatarClass == "site-avatar"));

            return "<span class=\"" + safeAvatarClass + " " + frameClass + "\" role=\"img\" aria-label=\"" +
                   HttpUtility.HtmlAttributeEncode(label) + "\">" + inner + "</span>";
        }

        public static string GetFrameCssClass(object frameValue)
        {
            switch (Convert.ToString(frameValue))
            {
                case "teal-frost": return "profile-frame-teal-frost";
                case "silver-frost": return "profile-frame-silver-frost";
                case "royal-blue": return "profile-frame-royal-blue";
                case "rose-pink": return "profile-frame-rose-pink";
                case "master-gold": return "profile-frame-master-gold";
                default: return "profile-frame-default-blue";
            }
        }

        private static bool IsSafePhotoPath(string path)
        {
            return !String.IsNullOrWhiteSpace(path) &&
                   path.StartsWith("~/Images/ProfilePhotos/", StringComparison.OrdinalIgnoreCase) &&
                   path.IndexOf("..", StringComparison.Ordinal) < 0 &&
                   !Path.IsPathRooted(path);
        }

        private static string GetInitials(string fullName, bool singleInitial)
        {
            if (String.IsNullOrWhiteSpace(fullName)) return "AX";
            string[] parts = fullName.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (singleInitial || parts.Length == 1) return parts[0].Substring(0, 1).ToUpperInvariant();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpperInvariant();
        }
    }
}
